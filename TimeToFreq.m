function [freqData] = TimeToFreq(timeData,mu, nData)
%TIMETOFREQ 此处显示有关此函数的摘要
%   此处显示详细说明
%%
subFrameDuration = 1e-3;
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
nFFT = 2 ^ ceil(log2(nData));
sampleRate = nFFT * subCarriarSpace;
simulationTimeMs = size(timeData, 2) / sampleRate / subFrameDuration;
nCP_Normal = nFFT + 72*(nFFT / 1024);
nCP_Extra = (sampleRate * subFrameDuration - nCP_Normal * (numSymbolPerSubFrame - 2)) / 2;
nCP_Normal = nCP_Normal - nFFT;
nCP_Extra = nCP_Extra - nFFT;
nCP_List = [nCP_Extra, nCP_Normal * ones(1, numSymbolPerSubFrame/2 - 1)];
nCP_List = repmat(nCP_List, 1, 2 * simulationTimeMs);

%%
freqData = zeros(nData, numSymbolPerSubFrame*simulationTimeMs);
sIdx = 1;
for sym = 1:numSymbolPerSubFrame*simulationTimeMs
    sIdx = sIdx + nCP_List(sym);
    eIdx = sIdx + nFFT - 1;
    x = timeData(sIdx:eIdx);
    X = fft(x) / sqrt(nFFT);
    freqData(1:nData/2, sym) = X(1:nData/2).';
    freqData(nData/2+1:nData, sym) = X(nFFT-nData/2+1:nFFT).';
    sIdx = eIdx + 1;
end
end

