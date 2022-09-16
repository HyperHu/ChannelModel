
%%
clearvars;

theQm = int32(4);
nLay = int32(4);
nPrb = int32(16);
nRePerPrb = int32(12*12);
targetCr = double(0.5);
theG = nLay * nPrb * nRePerPrb;
[tbSize, bgn, nCb, effCr, kDot] = getLdpcInfo(theQm, nLay, nPrb, nRePerPrb, targetCr, theG);

SNRdB = double(10.0);
theBler = getCbBler(double(SNRdB), double(effCr), double(kDot), int32(theQm), int32(bgn));




