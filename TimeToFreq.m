function [freqData] = TimeToFreq(timeData,mu, nData)
%TIMETOFREQ �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%
subFrameDuration = 1e-3;
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
nFFT = 2 ^ ceil(log2(nData));
sampleRate = nFFT * subCarriarSpace;
nCP_Normal = nFFT + 72*(nFFT / 1024);
nCP_Extra = (sampleRate * subFrameDuration - nCP_Normal * (numSymbolPerSubFrame - 2)) / 2;
nCP_Normal = nCP_Normal - nFFT;
nCP_Extra = nCP_Extra - nFFT;
nCP_List = [nCP_Extra, nCP_Normal * ones(1, numSymbolPerSubFrame/2 - 1)];
nCP_List = [nCP_List nCP_List];
assert(size(timeData,2) == sampleRate * subFrameDuration);

%%
freqData = zeros(nData, numSymbolPerSubFrame);
sIdx = 1;
for sym = 1:numSymbolPerSubFrame
    sIdx = sIdx + nCP_List(sym);
    eIdx = sIdx + nFFT - 1;
    x = timeData(sIdx:eIdx);
    X = fft(x) / sqrt(nFFT);
    freqData(1:nData/2, sym) = X(1:nData/2).';
    freqData(nData/2+1:nData, sym) = X(nFFT-nData/2+1:nFFT).';
    sIdx = eIdx + 1;
end
end

