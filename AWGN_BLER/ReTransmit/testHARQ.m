clear all;
noTransportBlocks = 5000;
tmpResult = [];
for SNRdB = -7:0.1:-2
%SNRdB = -10; % SNR in dB
%rng("default");

% DL-SCH parameters
codeRate = 150/1024;
NHARQProcesses = 1; % Number of parallel HARQ processes to use
rvSeq = [0 2 3 1];

% Create DL-SCH encoder object
encodeDLSCH = nrDLSCH;
encodeDLSCH.MultipleHARQProcesses = true;
encodeDLSCH.TargetCodeRate = codeRate;

% Create DL-SCH decoder object
decodeDLSCH = nrDLSCHDecoder;
decodeDLSCH.MultipleHARQProcesses = true;
decodeDLSCH.TargetCodeRate = codeRate;
decodeDLSCH.LDPCDecodingAlgorithm = "Normalized min-sum";
decodeDLSCH.MaximumLDPCIterationCount = 6;

% Numerology
SCS = 15;                         % SCS: 15, 30, 60, 120 or 240 (kHz)
NRB = 52;                         % BW in number of RBs (52 RBs at 15 kHz SCS for 10 MHz BW)

carrier = nrCarrierConfig;
carrier.NSizeGrid = NRB;
carrier.SubcarrierSpacing = SCS;
carrier.CyclicPrefix = "Normal";  % "Normal" or "Extended"

modulation = "QPSK";             % Modulation scheme

pdsch = nrPDSCHConfig;
pdsch.Modulation = modulation;
pdsch.PRBSet = 0:2-1;           % Assume full band allocation
pdsch.NumLayers = 1;              % Assume only one layer and one codeword

harqEntity = HARQEntity(0:NHARQProcesses-1,rvSeq,pdsch.NumCodewords);

% Initialize loop variables
noiseVar = 1./(10.^(SNRdB/10)); % Noise variance
numBlkErr = 0;                  % Number of block errors
numRxBits = [];                 % Number of successfully received bits per transmission
txedTrBlkSizes = [];            % Number of transmitted info bits per transmission

ackItemCount = [0, 0, 0, 0, 0];
for nTrBlk = 1:noTransportBlocks
    % A transport block or transmission time interval (TTI) corresponds to
    % one slot
    carrier.NSlot = carrier.NSlot+1;

    % Generate PDSCH indices info, which is used to calculate the transport
    % block size
    [~,pdschInfo] = nrPDSCHIndices(carrier,pdsch);

    % Calculate transport block sizes
    Xoh_PDSCH = 0;
    trBlkSizes = nrTBS(pdsch.Modulation,pdsch.NumLayers,numel(pdsch.PRBSet),pdschInfo.NREPerPRB,codeRate,Xoh_PDSCH);

    % Get new transport blocks and flush decoder soft buffer, as required
    for cwIdx = 1:pdsch.NumCodewords
        if harqEntity.NewData(cwIdx)
            % Create and store a new transport block for transmission
            trBlk = randi([0 1],trBlkSizes(cwIdx),1);
            setTransportBlock(encodeDLSCH,trBlk,cwIdx-1,harqEntity.HARQProcessID);

            % If the previous RV sequence ends without successful decoding,
            % flush the soft buffer explicitly
            if harqEntity.SequenceTimeout(cwIdx)
                resetSoftBuffer(decodeDLSCH,cwIdx-1,harqEntity.HARQProcessID);
            end
        end
    end
    codedTrBlock = encodeDLSCH(pdsch.Modulation,pdsch.NumLayers,pdschInfo.G, harqEntity.RedundancyVersion,harqEntity.HARQProcessID);
    modOut = nrPDSCH(carrier,pdsch,codedTrBlock);

    rxSig = awgn(modOut,SNRdB);    
    
    rxLLR = nrPDSCHDecode(carrier,pdsch,rxSig,noiseVar);
    decodeDLSCH.TransportBlockLength = trBlkSizes;
    [decbits,blkerr] = decodeDLSCH(rxLLR,pdsch.Modulation,pdsch.NumLayers, harqEntity.RedundancyVersion,harqEntity.HARQProcessID);

    % Store values to calculate throughput (only for active transport blocks)
    if(any(trBlkSizes ~= 0))
        numRxBits = [numRxBits trBlkSizes.*(1-blkerr)];
        txedTrBlkSizes = [txedTrBlkSizes trBlkSizes];
    end
    
    if blkerr   
        numBlkErr = numBlkErr + 1;
        if harqEntity.RedundancyVersion == 1
            ackItemCount(5) = ackItemCount(5) + 1;
        end
    else
        ackItemCount(harqEntity.RedundancyVersion+1) = ackItemCount(harqEntity.RedundancyVersion+1)+1;
    end

    statusReport = updateAndAdvance(harqEntity,blkerr,trBlkSizes,pdschInfo.G);    
    %disp("Slot "+(nTrBlk)+". "+statusReport);
end % for nTrBlk = 1:noTransportBlocks

maxThroughput = sum(txedTrBlkSizes); % Maximum possible throughput
totalNumRxBits = sum(numRxBits,2);   % Number of successfully received bits

disp("Block Error Rate: "+string(numBlkErr/noTransportBlocks))
disp("Throughput: " + string(totalNumRxBits*100/maxThroughput) + "%")


%%
eee = [1 - ackItemCount(1) / sum(ackItemCount);
1 - ackItemCount(3) / (ackItemCount(3) + ackItemCount(4) + ackItemCount(2) + ackItemCount(5));
1 - ackItemCount(4) / (ackItemCount(4) + ackItemCount(2) + ackItemCount(5));
1 - ackItemCount(2) / (ackItemCount(2) + ackItemCount(5))];
tmpResult = [tmpResult eee];

end
