function [timeData] = FreqToTime(freqData, mu)
%FREQTOTIME 此处显示有关此函数的摘要
%   此处显示详细说明

%%
subFrameDuration = 1e-3;
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
simulationTimeMs = size(freqData, 2) / numSymbolPerSubFrame;
nData = size(freqData, 1);
nFFT = 2 ^ ceil(log2(nData));
sampleRate = nFFT * subCarriarSpace;
nCP_Normal = nFFT + 72*(nFFT / 1024);
nCP_Extra = (sampleRate * subFrameDuration - nCP_Normal * (numSymbolPerSubFrame - 2)) / 2;
nCP_Normal = nCP_Normal - nFFT;
nCP_Extra = nCP_Extra - nFFT;
nCP_List = [nCP_Extra, nCP_Normal * ones(1, numSymbolPerSubFrame/2 - 1)];
nCP_List = repmat(nCP_List, 1, 2 * simulationTimeMs);

%%
timeData = zeros(1, sampleRate * subFrameDuration * simulationTimeMs);
sIdx = 1;
for sym = 1:numSymbolPerSubFrame * simulationTimeMs
    X = [freqData(1:nData/2, sym); zeros(nFFT-nData, 1); freqData(nData/2+1 : nData, sym)];
    x = ifft(X) * sqrt(nFFT);
    xAll = [x(nFFT-nCP_List(sym)+1:nFFT); x];
    eIdx = sIdx + nCP_List(sym) + nFFT - 1;
    timeData(1, sIdx : eIdx) = xAll.';
    sIdx = eIdx + 1;
end
end

