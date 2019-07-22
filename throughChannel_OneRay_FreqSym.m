function [outSym, signal, initPhase] = throughChannel_OneRay_FreqSym(inSym, mu, powerLoss_dB, delay_ns, freqShift_Hz, randomPhase_rad)
%THROUGHTCHANNEL_ONERAY_FREQSYM 此处显示有关此函数的摘要
%   此处显示详细说明
%%
subFrameDuration = 1e-3;
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
assert(size(inSym, 2) == numSymbolPerSubFrame);
nData = size(inSym, 1);
nFFT = 2 ^ ceil(log2(nData));
sampleRate = nFFT * subCarriarSpace;
nCP_Normal = nFFT + 72*(nFFT / 1024);
nCP_Extra = (sampleRate * subFrameDuration - nCP_Normal * (numSymbolPerSubFrame - 2)) / 2;
nCP_Normal = nCP_Normal - nFFT;
nCP_Extra = nCP_Extra - nFFT;
nCP_List = [nCP_Extra, nCP_Normal * ones(1, numSymbolPerSubFrame/2 - 1)];
nCP_List = [nCP_List nCP_List];

%%
scaler = db2mag(0 - powerLoss_dB);
delay_sample = (delay_ns * 1e-9) * sampleRate;
delay_n = fix(delay_sample);
tao = delay_n;
assert(tao < min(nCP_List));
kds = freqShift_Hz / subCarriarSpace;
wn = 2*pi/nFFT;
hMargin = (nFFT - nData) / 2;
[FSfilter, hWin] = freqShift_FilterFuntion(kds, nFFT);
hWin = min(hWin*10, hMargin-1);
%assert(hMargin > hWin)

%%
outSym = zeros(nData, numSymbolPerSubFrame);
signal = zeros(nData, numSymbolPerSubFrame);
initPhase = zeros(1, numSymbolPerSubFrame);
for sym = 1:numSymbolPerSubFrame
    n0 = nFFT * (sym-1) + sum(nCP_List(1:sym));
    initPhi = exp(1i * (wn * kds * n0 + randomPhase_rad));
    initPhase(1, sym) = initPhi;
    X = ifftshift([inSym(1:nData/2, sym); zeros(nFFT-nData, 1); inSym(nData/2+1 : nData, sym)]);
    
    sig = X .* FSfilter(nFFT/2 + 1);
    ici = zeros(nFFT, 1);
    for k = hMargin + 1 : hMargin + nData
        for d = 1:hWin
            tmpV1 = exp(-1i*wn*d*tao) .* FSfilter(nFFT/2 + 1-d) .* X(k+d);
            tmpV2 = exp(1i*wn*d*tao) .* FSfilter(nFFT/2 + 1+d) .* X(k-d);
            ici(k) = ici(k) + (1 .* tmpV1) + (1 .* tmpV2);
        end
    end
        
    tmpV = scaler .* initPhi .* exp((-nFFT/2 : nFFT/2 - 1)' .* (-1i*wn*tao));
    pureSig = ifftshift(tmpV .* sig);
    allSig = ifftshift(tmpV .* (sig + ici));
    outSym(1:nData/2, sym) = allSig(1:nData/2);
    outSym(nData/2+1 : nData, sym) = allSig(nFFT - nData/2 + 1:nFFT);
    signal(1:nData/2, sym) = pureSig(1:nData/2);
    signal(nData/2+1 : nData, sym) = pureSig(nFFT - nData/2 + 1:nFFT);
end

end

