function [theH_d] = calChannelH(rayList, distD, mu, nData)
%CALCHANNELH 此处显示有关此函数的摘要
%   此处显示详细说明

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

%%
theH_d = zeros(nData, numSymbolPerSubFrame);
n0 = zeros(1, numSymbolPerSubFrame);
wn = 2*pi/nFFT;
for sym = 1:numSymbolPerSubFrame
    n0(sym) = nFFT * (sym-1) + sum(nCP_List(1:sym));
end
for idxRay = 1:size(rayList,1)
    scaler = db2mag(0 - rayList(idxRay, 1));
    delay_sample = (rayList(idxRay, 2) * 1e-9) * sampleRate;
    delay_n = fix(delay_sample);
    tao = delay_n;
    assert(tao < min(nCP_List));
    kds = rayList(idxRay, 3) / subCarriarSpace;
    fsAll = exp(1i*wn*distD*tao) * quick_freqShift(distD, kds, nFFT);
    initPhi = exp(1i * (wn .* kds .* n0 + rayList(idxRay, 4)));
    tmpV = fsAll .* scaler .* exp((-nFFT/2 : nFFT/2 - 1)' .* (-1i * wn * tao));
    tmpV = ifftshift(tmpV * initPhi, 1);
    theH_d(1:nData/2, :) = theH_d(1:nData/2, :) + tmpV(1:nData/2, :);
    theH_d(nData/2+1 : nData, :) = theH_d(nData/2+1 : nData, :) + tmpV(nFFT - nData/2 + 1:nFFT, :);
end

end

function theFilterFactor = quick_freqShift(d, k_ds, nFFT)
    kTotal = d - k_ds;
    theFilterFactor = (exp(-1i * pi * kTotal * (1-1/nFFT)) / nFFT) ...
                      * sin(pi * kTotal) / sin(pi * kTotal / nFFT);
end

