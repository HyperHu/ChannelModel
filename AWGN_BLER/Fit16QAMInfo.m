%% parameter set
clear all;
addpath(pwd + "\Utility");

%% Fit Info

realSpectralEff = []; effCodeRate = []; allK_dot = []; muSINR = []; sigmadB = [];

load("16QAMSampleSet.mat");
for itemIdx = 1:size(seIdxSetAll, 2)
    seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx};
    [~, ~, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 12);
    [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerListSetAll{itemIdx}, snrdBSetAll{itemIdx}, 0);
    effCodeRate = [effCodeRate effCR]; allK_dot = [allK_dot k_dot];
    muSINR = [muSINR B]; sigmadB = [sigmadB C];
    realSpectralEff = [realSpectralEff effCR*4];
end

load("QPSKSampleSet.mat");
for itemIdx = 1:size(seIdxSetAll, 2)
    seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx};
    [~, ~, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 12);
    [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerListSetAll{itemIdx}, snrdBSetAll{itemIdx}, 0);
    effCodeRate = [effCodeRate effCR]; allK_dot = [allK_dot k_dot];
    muSINR = [muSINR B]; sigmadB = [sigmadB C];
    realSpectralEff = [realSpectralEff effCR*2];
end



xData = log2(realSpectralEff); yData = log2(allK_dot);

muSinrFunc = fit([xData', yData'], muSINR', 'poly33');
figure(1); plot(muSinrFunc, [xData', yData'], muSINR');

sigmaSinrFunc = fit([xData', yData'], sigmadB', 'poly33');
figure(2); plot(sigmaSinrFunc, [xData', yData'], sigmadB');

%% Varify Info -- 50% Bler Point
% blerTb = 1 - ((1 - blerCb) .^ n)
% blerCb = 1 - ((1 - blerTb) .^ (1/n))
nPrbTest = [1 2 3 4 5 6 8 10 16 20 32 48 50 64 80 96 ...
             100 112 128 144 160 176 192 208 224 250 256 273];
% startSeIdx = 1; endSeIdx = 16;
% testBlerTb = zeros(endSeIdx-startSeIdx+1, size(nPrbTest,2));
% testBlerCb = zeros(endSeIdx-startSeIdx+1, size(nPrbTest,2));
% for seIdx = startSeIdx:endSeIdx
%     tic
%     for nPrbIdx = 1:size(nPrbTest, 2)
%         nPrb = nPrbTest(nPrbIdx);
%         % est SINR point
%         [~, ~, nCb, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 12);
%         tmpX = log2(effCR * 2); tmpY = log2(k_dot);
%         estSINR = muSinrFunc([tmpX, tmpY]);
%         
%         % do testing
%         [theTbBler, theCbBler] = calBler(seIdx, nPrb, 12, estSINR, 1000*10);
%         
%         testBlerCb(seIdx, nPrbIdx) = theCbBler - 0.5;
%         testBlerTb(seIdx, nPrbIdx) = theTbBler - (1 - ((1 - 0.5) .^ nCb));
%         fprintf('cfg: [ %d %d %d ] estBler: [ %.4f %.4f ] testBler: [ %.4f %.4f ] \n',...
%                 seIdx, nPrb, 12, (1 - ((1 - 0.5) .^ nCb)), 0.5, theTbBler, theCbBler);
%     end
%     toc
%     save("testBlerResult.mat", 'testBlerTb', 'testBlerCb');
% end

%% Varify Info -- 10% Bler Point

%% Varify Info -- 90% Bler Point

%% Calculate SINR Point
tbBlerTarget = 0.1;
nPrbTest = [51 106 162 217 273]; startSeIdx = 1; endSeIdx = 23;
sinrPoint = zeros(23, size(nPrbTest,2));
for seIdx = startSeIdx:endSeIdx
    for nPrbIdx = 1:size(nPrbTest, 2)
        nPrb = nPrbTest(nPrbIdx);
        [~, ~, nCb, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 10);
        estMu = muSinrFunc([log2(effCR * 2), log2(k_dot)]);
        estSig = sigmaSinrFunc([log2(effCR * 2), log2(k_dot)]);
        cbBlerTarget = 1 - ((1 - tbBlerTarget) .^ (1/nCb));
        sinrPoint(seIdx, nPrbIdx) = icdf('Normal', 1 - cbBlerTarget, estMu, estSig);
    end
end
figure(3); hold on; grid on;
mesh(startSeIdx:endSeIdx, nPrbTest, sinrPoint(startSeIdx:endSeIdx, :)');

