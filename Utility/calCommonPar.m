function [subFrameDuration, subCarriarSpace, numSymbolPerSubFrame, ...
          sampleRate, nCP_List_subFrame] = calCommonPar(mu, nFFT)
%CALCOMMONPAR 此处显示有关此函数的摘要
%   此处显示详细说明

subFrameDuration = 1e-3;    % 1ms
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
sampleRate = nFFT * subCarriarSpace;
nCP_Normal = nFFT + 72*(nFFT / 1024);
nCP_Extra = (sampleRate * subFrameDuration - nCP_Normal * (numSymbolPerSubFrame - 2)) / 2;
nCP_Normal = nCP_Normal - nFFT;
nCP_Extra = nCP_Extra - nFFT;
nCP_List = [nCP_Extra, nCP_Normal * ones(1, numSymbolPerSubFrame/2 - 1)];
nCP_List_subFrame = repmat(nCP_List, 1, 2);
end

