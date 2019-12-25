%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

lenHexagon_meter = 1;
virticalDiff_meter = 0.10;
nSamples = 500;

%% 
tmpDelta = lenHexagon_meter/nSamples; 
tmpX = 0:tmpDelta:(2*lenHexagon_meter);
tmpY = (-floor(size(tmpX,2)/2):floor(size(tmpX,2)/2)) * tmpDelta;
cellRange = zeros(size(tmpX,2), size(tmpY,2));
sampleInRange = 0;
for idxX = 1:size(cellRange, 1)
    if tmpX(idxX) < 0.5*lenHexagon_meter
        tmpEdge = sqrt(3) * tmpX(idxX);
    elseif tmpX(idxX) < 1.5*lenHexagon_meter
        tmpEdge = sqrt(3)/2 * lenHexagon_meter;
    else
        tmpEdge = sqrt(3) * (2*lenHexagon_meter - tmpX(idxX));
    end
    for idxY = 1:size(cellRange, 2)
        if abs(tmpY(idxY)) <= tmpEdge
            cellRange(idxX, idxY) = 1;
            sampleInRange = sampleInRange + 1;
        end
    end
end

sampleIdx = 0;
distRawData = zeros(1,sampleInRange);
thetaRawData = zeros(1,sampleInRange);
phiRawData = zeros(1,sampleInRange);
antLossV_dB = zeros(1,sampleInRange);
antLossH_dB = zeros(1,sampleInRange);

for idxX = 1:size(cellRange, 1)
    for idxY = 1:size(cellRange, 2)
        if cellRange(idxX, idxY) == 1
            sampleIdx = sampleIdx + 1;
            distRawData(sampleIdx) = sqrt(tmpX(idxX)^2 + tmpY(idxY)^2 + virticalDiff_meter^2);
            thetaRawData(sampleIdx) = 90 + asind(virticalDiff_meter / distRawData(sampleIdx));
            phiRawData(sampleIdx) = angle(tmpX(idxX) + 1j*tmpY(idxY))/pi*180;
            antLossV_dB(sampleIdx) = min(12*((thetaRawData(sampleIdx) - 90)/65)^2, 30);
            antLossH_dB(sampleIdx) = min(12*(phiRawData(sampleIdx)/65)^2, 30);
        end
    end
end
%%
figure(1); hold on; grid on; histogram(distRawData, 'Normalization', 'pdf');
figure(2); hold on; grid on; histogram(thetaRawData, 'Normalization', 'pdf');
figure(3); hold on; grid on; histogram(phiRawData, 'Normalization', 'pdf');
figure(4); hold on; grid on; histogram(antLossV_dB, 'Normalization', 'pdf');
figure(5); hold on; grid on; histogram(antLossH_dB, 'Normalization', 'pdf');


%%
tmpDelta = lenHexagon_meter/nSamples; 
tmpX = 0:tmpDelta:(sqrt(3)*lenHexagon_meter);
tmpY = -1.5*lenHexagon_meter:tmpDelta:1.5*lenHexagon_meter;
cellRange = zeros(size(tmpX,2), size(tmpY,2));
sampleInRange = 0;
for idxX = 1:size(cellRange, 1)
    if tmpX(idxX) < sqrt(3)*lenHexagon_meter/2
        tmpEdge = sqrt(3) * tmpX(idxX);
    else
        tmpEdge = sqrt(3) * (sqrt(3)*lenHexagon_meter - tmpX(idxX));
    end
    for idxY = 1:size(cellRange, 2)
        if abs(tmpY(idxY)) <= tmpEdge
            cellRange(idxX, idxY) = 1;
            sampleInRange = sampleInRange + 1;
        end
    end
end

sampleIdx = 0;
distRawData = zeros(1,sampleInRange);
thetaRawData = zeros(1,sampleInRange);
phiRawData = zeros(1,sampleInRange);
antLossV_dB = zeros(1,sampleInRange);
antLossH_dB = zeros(1,sampleInRange);

for idxX = 1:size(cellRange, 1)
    for idxY = 1:size(cellRange, 2)
        if cellRange(idxX, idxY) == 1
            sampleIdx = sampleIdx + 1;
            distRawData(sampleIdx) = sqrt(tmpX(idxX)^2 + tmpY(idxY)^2 + virticalDiff_meter^2);
            thetaRawData(sampleIdx) = 90 + asind(virticalDiff_meter / distRawData(sampleIdx));
            phiRawData(sampleIdx) = angle(tmpX(idxX) + 1j*tmpY(idxY))/pi*180;
            antLossV_dB(sampleIdx) = min(12*((thetaRawData(sampleIdx) - 90)/65)^2, 30);
            antLossH_dB(sampleIdx) = min(12*(phiRawData(sampleIdx)/65)^2, 30);
        end
    end
end

figure(1); hold on; grid on; histogram(distRawData, 'Normalization', 'pdf');
figure(2); hold on; grid on; histogram(thetaRawData, 'Normalization', 'pdf');
figure(3); hold on; grid on; histogram(phiRawData, 'Normalization', 'pdf');
figure(4); hold on; grid on; histogram(antLossV_dB, 'Normalization', 'pdf');
figure(5); hold on; grid on; histogram(antLossH_dB, 'Normalization', 'pdf');