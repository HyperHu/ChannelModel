%%
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

%%
simulationTimeMs = 1; %ms;
mu = 1;
numPRB = 50;
nFFT = 2 ^ ceil(log2(numPRB * 12));
nData = numPRB * 12;
[subFrameDuration, subCarriarSpace, numSymbolPerSubFrame, ...
    sampleRate, nCP_List_subFrame] = calCommonPar(mu, nFFT);


IFFTMat = exp(1j * (2*pi/nFFT) * (0:nFFT-1)' * (0:nFFT-1)) ./ sqrt(nFFT);
FFTMat = exp(-1j * (2*pi/nFFT) * (0:nFFT-1)' * (0:nFFT-1)) ./ sqrt(nFFT);

tmpCPLen = nCP_List_subFrame(1);
CPADDMat = [zeros(tmpCPLen, nFFT - tmpCPLen) eye(tmpCPLen); eye(nFFT)];
CPDELMat = [zeros(nFFT, tmpCPLen) eye(nFFT)];

[DirToLCS, DirToGCS, FCToLCS, FCToGCS] = GenCoordSysTransformer([0 0 45]);

cFreq_Hz = 3 * 1e9;
pMax_dBm = 20;
theDirectivity_dB = 0;

nTxPort = 2;
nTxTrx = 16;
nRxTrx = 4;
nRxPort = 2;

%% Baseband signal process in TX side.
modulateOrder = 2;
sigmaRE = 1;
[reMat, ~] = genRandomREValue(nData, nTxPort, modulateOrder, sigmaRE);
tmpX = [reMat(1:nData/2, :); zeros(nFFT-nData, nTxPort); reMat(nData/2+1 : nData, :)];
BB_TimeSamples = CPADDMat * IFFTMat * tmpX;
disp("=================== Tx BB signal info =======================");
fprintf('The std of RE is %.4f\n', std(reMat, 0, 'all'));
fprintf('The std of samples is %.4f\n', std(BB_TimeSamples, 0, 'all'));

%% Beamforming and radiated to air, without direction factor.
if nTxPort == 1
    if nTxTrx == 1
        txBeamWeight = 1;
    else
        txBeamWeight = [ones(1, nTxTrx/2) 1i*ones(1, nTxTrx/2)];
    end
else
    txBeamWeight = [ones(nTxPort/2, nTxTrx/2) zeros(nTxPort/2, nTxTrx/2);
                    zeros(nTxPort/2, nTxTrx/2) ones(nTxPort/2, nTxTrx/2)];
    % how many ports are connect to one TRX.
    txBeamWeight = txBeamWeight ./ sqrt(nTxPort/2);
end
if nTxTrx == 1
    theTrxGain_V = getTrxGain(pMax_dBm, 1, theDirectivity_dB, 'V');
    txBeamWeight_G = kron(txBeamWeight, theTrxGain_V);
else
    theTrxGain_V = getTrxGain(pMax_dBm, 1, theDirectivity_dB, 'V');
    theTrxGain_H = getTrxGain(pMax_dBm, 1, theDirectivity_dB, 'H');
    txBeamWeight_G = [kron(txBeamWeight(:, 1:nTxTrx/2), theTrxGain_V) kron(txBeamWeight(:, nTxTrx/2+1:end), theTrxGain_H)];
end
TxSIG = BB_TimeSamples * txBeamWeight_G;
disp("=================== Tx Field Component info in LCS ==========");
% fprintf('The field component in LCS: [%.4f %.4f] dBm/m^2\n', pow2db(theTrxGain_V .^ 2)+30);
% fprintf('The field component in LCS: [%.4f %.4f] dBm/m^2\n', pow2db(theTrxGain_H .^ 2)+30);
fprintf('The EIRP power: %.4f dBm\n', pow2db((4*pi*sum((abs(TxSIG)) .^ 2, 'all'))/size(TxSIG,1)) + 30);

%% Parameters for one Ray
gcs_departure_deg = [90 0];
gcs_arrive_deg = [90 -180];
ray_PathLoss_dB = 0;


%% Consider the direction and LCS to GCS.
lcs_departure_deg = DirToLCS(gcs_departure_deg);
radiatePattern = getRadiationPattern(lcs_departure_deg);
[~, ~, dMat] = FCToGCS(lcs_departure_deg, [0 0]);
FiledComponent_Tx = TxSIG * radiatePattern * kron(eye(nTxTrx), dMat);
fprintf('Tx Radiation pattern: %.4f dB at[%d, %d]\n', mag2db(radiatePattern), lcs_departure_deg);


%% Feed to Ray via steering vector.
if nTxTrx == 1
    aePosition = [0 0 0];
else
    aePosition = [zeros(nTxTrx/2,1) (0:nTxTrx/2-1)' - (nTxTrx/2-1)/2 zeros(nTxTrx/2,1)];
    aePosition = [aePosition; aePosition];
    aePosition = aePosition * (299792458 / cFreq_Hz);
end
steeringVecTx = getSteeringVector(aePosition, cFreq_Hz, gcs_departure_deg);
CHIN_ray = FiledComponent_Tx * kron(steeringVecTx, eye(2));
disp("=================== Power Feed to ray ==========");
fprintf('Power in Vertical: %.4f dBm/m^2\n', mag2db(std(CHIN_ray(:,1)))+30);
fprintf('Power in Horizontal: %.4f dBm/m^2\n', mag2db(std(CHIN_ray(:,2)))+30);

%% Pass through channel.
% TODO
CHOUT_ray = db2mag(-ray_PathLoss_dB) .* CHIN_ray;

%% Feed to Antenna Element via steering vector.
if nRxTrx == 1
    aePosition = [0 0 0];
else
    aePosition = [zeros(nRxTrx/2,1) (0:nRxTrx/2-1)' - (nRxTrx/2-1)/2 zeros(nRxTrx/2,1)];
    aePosition = [aePosition; aePosition];
    aePosition = aePosition * (299792458 / cFreq_Hz);
end
steeringVecRx = getSteeringVector(aePosition, cFreq_Hz, gcs_arrive_deg);
FiledComponent_Rx = CHOUT_ray * ((kron(steeringVecRx, eye(2))).');

%% Consider the direction and GCS to LCS.
lcs_arrive_deg = DirToLCS([180 - gcs_arrive_deg(1), mod(gcs_arrive_deg(2) + 360, 360)-180]);
radiatePattern = getRadiationPattern(lcs_arrive_deg);
[~, ~, dMat] = FCToLCS([180 - gcs_arrive_deg(1), mod(gcs_arrive_deg(2) + 360, 360)-180], [0 0]);
RxSIG = FiledComponent_Rx * kron(eye(nRxTrx), dMat) * radiatePattern;
fprintf('Rx Radiation pattern: %.4f dB at[%d, %d]\n', mag2db(radiatePattern), lcs_arrive_deg);

%% Receive from Air and Beamforming, without direction factor.
if nRxPort == 1
    if nRxTrx == 1
        rxBeamWeight = 1;
    else
        rxBeamWeight = [ones(nRxTrx/2, 1);
                        -1i*ones(nRxTrx/2, 1)];
    end
else
    rxBeamWeight = [ones(nRxTrx/2, nRxPort/2) zeros(nRxTrx/2, nRxPort/2);
                    zeros(nRxTrx/2, nRxPort/2) ones(nRxTrx/2, nRxPort/2)];
end
rxBeamWeight = rxBeamWeight ./ sqrt(nRxTrx);
scaledEffAperture = mag2db(299792458 / cFreq_Hz) + 30;
if nRxTrx == 1
    theTrxGain_V = getTrxGain(scaledEffAperture, 1, theDirectivity_dB, 'V')';
    rxBeamWeight_G = kron(rxBeamWeight, theTrxGain_V);
else
    theTrxGain_V = getTrxGain(scaledEffAperture, 1, theDirectivity_dB, 'V')';
    theTrxGain_H = getTrxGain(scaledEffAperture, 1, theDirectivity_dB, 'H')';
    if nRxPort == 1
        rxBeamWeight_G = [kron(rxBeamWeight(1:nRxTrx/2, 1), theTrxGain_V);
                          kron(rxBeamWeight(nRxTrx/2+1:end, 1), theTrxGain_H)];
    else
        rxBeamWeight_G = [kron(rxBeamWeight(:, 1:nRxPort/2), theTrxGain_V) kron(rxBeamWeight(:, nRxPort/2+1:end), theTrxGain_H)];
    end
end
% Scaling in RX channel.
% Antenna feed X dBm to load, then the std of channel output is 1.
scalingFactor = db2mag(-((0) - 30));
BB_TimeSamples_Rx = RxSIG * rxBeamWeight_G * scalingFactor;


%% Baseband signal process in RX side.
tmpY = FFTMat * CPDELMat * BB_TimeSamples_Rx;
disp("=================== Rx BB signal info =======================");
fprintf('The std of RE is %.4f\n', std(tmpY, 0, 'all'));
fprintf('The std of samples is %.4f\n', std(BB_TimeSamples_Rx, 0, 'all'));

%%
tmpS = std(BB_TimeSamples, 0, 'all') / std(BB_TimeSamples_Rx, 0, 'all');
errStd = std((tmpY * tmpS) - tmpX);

%%
% figure(); hold on; grid on;
% plot(real(tmpX), '*');
% plot(real(tmpY), '*');
% plot(imag(tmpX), '.');
% plot(imag(tmpY), '.');