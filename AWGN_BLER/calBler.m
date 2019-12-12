function theBler = calBler(mcsIdx, snrdB, nPrb, nSample)
ModulationOrder_Table = {'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' ...
                         '16QAM' '16QAM' '16QAM' '16QAM' '16QAM' '16QAM' '16QAM' ...
                         '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' ...
                         '256QAM' '256QAM' '256QAM' '256QAM' '256QAM' '256QAM' '256QAM' '256QAM'};

TargetCodeRate_Table = [30 40 50 64 78 99 120 157 193 251 308 379 449 526 602 679 ...
                        340 378 434 490 553 616 658 ...
                        438 466 517 567 616 666 719 772 822 873 910 948 ...
                        682.5 711 754 797 841 885 916.5 948];

BitsPerSymbol_Table = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, ...
                       4, 4, 4, 4, 4, 4, 4, ...
                       6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, ...
                       8, 8, 8, 8, 8, 8, 8, 8];

%%
    nSymbol = 12;
    pdsch = struct();
    pdsch.NLayers = 1;
    pdsch.TargetCodeRate = TargetCodeRate_Table(mcsIdx) / 1024;
    pdsch.PRBSet = 0:nPrb - 1;
    pdsch.Modulation = ModulationOrder_Table{mcsIdx};
    pdsch.BitsPerSymbol = BitsPerSymbol_Table(mcsIdx);
    pdsch.nPrb = nPrb;
    pdsch.nSymbol = nSymbol;

    trBlkLen = hPDSCHTBS(pdsch, 12*pdsch.nSymbol);
    outlen = 12 * pdsch.nSymbol * pdsch.nPrb * pdsch.BitsPerSymbol;
    rv = 0;
    encDL = nrDLSCH('TargetCodeRate', pdsch.TargetCodeRate);
    decDL = nrDLSCHDecoder('TargetCodeRate', pdsch.TargetCodeRate, ...
                           'TransportBlockLength', trBlkLen);
    
%%
    totalErr = 0;
    for iii = 1:nSample
        encDL.reset();
        decDL.reset();
        setTransportBlock(encDL,randi([0 1],trBlkLen,1,'int8'));
        codedTrBlock = encDL(pdsch.Modulation, pdsch.NLayers, outlen, rv);
        txSoftBits = nrSymbolModulate(codedTrBlock, pdsch.Modulation);
        
        noiseBits = randn(size(txSoftBits)) + 1i * randn(size(txSoftBits));
        noiseBits = noiseBits .* db2mag(-(snrdB+3));
            
        rxSoftBits = nrSymbolDemodulate(txSoftBits + noiseBits, pdsch.Modulation, db2pow(-snrdB));
        [~, nacked] = decDL(rxSoftBits, pdsch.Modulation, pdsch.NLayers, rv);
        
        if nacked == true
            totalErr = totalErr + 1;
        end

    end
    theBler = totalErr / nSample;
end
