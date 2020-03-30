%% parameter set
clear all;
addpath(pwd + "\Utility");

%% Fit Info
load("4QAMSampleSet.mat");
effCodeRate_4QAM = zeros(size(seIdxSetAll)); allK_dot_4QAM = zeros(size(seIdxSetAll));
muSINR_4QAM = zeros(size(seIdxSetAll)); sigmadB_4QAM = zeros(size(seIdxSetAll));
for itemIdx = 1:size(seIdxSetAll, 2)
    seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx};
    [~, ~, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 12);
    [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerListSetAll{itemIdx}, snrdBSetAll{itemIdx}, 0);
    effCodeRate_4QAM(itemIdx) = effCR; allK_dot_4QAM(itemIdx) = k_dot;
    muSINR_4QAM(itemIdx) = B; sigmadB_4QAM(itemIdx) = C;
end
realSpectralEff_4QAM = 2 * effCodeRate_4QAM;

load("16QAMSampleSet.mat");
effCodeRate_16QAM = zeros(size(seIdxSetAll)); allK_dot_16QAM = zeros(size(seIdxSetAll));
muSINR_16QAM = zeros(size(seIdxSetAll)); sigmadB_16QAM = zeros(size(seIdxSetAll));
for itemIdx = 1:size(seIdxSetAll, 2)
    seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx};
    [~, ~, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 12);
    [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerListSetAll{itemIdx}, snrdBSetAll{itemIdx}, 0);
    effCodeRate_16QAM(itemIdx) = effCR; allK_dot_16QAM(itemIdx) = k_dot;
    muSINR_16QAM(itemIdx) = B; sigmadB_16QAM(itemIdx) = C;
end
realSpectralEff_16QAM = 4 * effCodeRate_16QAM;

load("64QAMSampleSet.mat");
effCodeRate_64QAM = zeros(size(seIdxSetAll)); allK_dot_64QAM = zeros(size(seIdxSetAll));
muSINR_64QAM = zeros(size(seIdxSetAll)); sigmadB_64QAM = zeros(size(seIdxSetAll));
for itemIdx = 1:size(seIdxSetAll, 2)
    seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx};
    [~, ~, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 12);
    [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerListSetAll{itemIdx}, snrdBSetAll{itemIdx}, 0);
    effCodeRate_64QAM(itemIdx) = effCR; allK_dot_64QAM(itemIdx) = k_dot;
    muSINR_64QAM(itemIdx) = B; sigmadB_64QAM(itemIdx) = C;
end
realSpectralEff_64QAM = 6 * effCodeRate_64QAM;

load("256QAMSampleSet.mat");
effCodeRate_256QAM = zeros(size(seIdxSetAll)); allK_dot_256QAM = zeros(size(seIdxSetAll));
muSINR_256QAM = zeros(size(seIdxSetAll)); sigmadB_256QAM = zeros(size(seIdxSetAll));
for itemIdx = 1:size(seIdxSetAll, 2)
    seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx};
    [~, ~, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 12);
    [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerListSetAll{itemIdx}, snrdBSetAll{itemIdx}, 0);
    effCodeRate_256QAM(itemIdx) = effCR; allK_dot_256QAM(itemIdx) = k_dot;
    muSINR_256QAM(itemIdx) = B; sigmadB_256QAM(itemIdx) = C;
end
realSpectralEff_256QAM = 8 * effCodeRate_256QAM;

%%
xData = log2(realSpectralEff_256QAM); yData = log2(allK_dot_256QAM);
tmpCor = [cosd(45) -sind(45); sind(45) cosd(45)] * [xData; yData];
cftool(xData, yData, muSINR_256QAM); cftool(tmpCor(1,:), tmpCor(2,:), sigmadB_256QAM);

%%
realSpectralEff = [realSpectralEff_4QAM realSpectralEff_16QAM realSpectralEff_64QAM realSpectralEff_256QAM];
effCodeRate = [effCodeRate_4QAM effCodeRate_16QAM effCodeRate_64QAM effCodeRate_256QAM];
allK_dot = [allK_dot_4QAM allK_dot_16QAM allK_dot_64QAM allK_dot_256QAM];
muSINR = [muSINR_4QAM muSINR_16QAM muSINR_64QAM muSINR_256QAM];
sigmadB = [sigmadB_4QAM sigmadB_16QAM sigmadB_64QAM sigmadB_256QAM];

xData = log2(realSpectralEff); yData = log2(allK_dot);
tmpCor = [cosd(45) -sind(45); sind(45) cosd(45)] * [xData; yData];
cftool(xData, yData, muSINR); cftool(xData, yData, sigmadB);
cftool(tmpCor(1,:), tmpCor(2,:), sigmadB);




% muSinrFunc = fit([xData', yData'], muSINR', 'poly33');
% figure(1); plot(muSinrFunc, [xData', yData'], muSINR');
% sigmaSinrFunc = fit([xData', yData'], sigmadB', 'poly33');
% figure(2); plot(sigmaSinrFunc, [xData', yData'], sigmadB');

%% Varify Info -- 50% Bler Point
% blerTb = 1 - ((1 - blerCb) .^ n)
% blerCb = 1 - ((1 - blerTb) .^ (1/n))
% nPrbTest = [1 2 3 4 5 6 8 10 16 20 32 48 50 64 80 96 ...
%              100 112 128 144 160 176 192 208 224 250 256 273];
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
% tbBlerTarget = 0.1;
% nPrbTest = [51 106 162 217 273]; startSeIdx = 1; endSeIdx = 23;
% sinrPoint = zeros(23, size(nPrbTest,2));
% for seIdx = startSeIdx:endSeIdx
%     for nPrbIdx = 1:size(nPrbTest, 2)
%         nPrb = nPrbTest(nPrbIdx);
%         [~, ~, nCb, effCR, k_dot] = CalSchInfo(seIdx, nPrb, 10);
%         estMu = muSinrFunc([log2(effCR * 2), log2(k_dot)]);
%         estSig = sigmaSinrFunc([log2(effCR * 2), log2(k_dot)]);
%         cbBlerTarget = 1 - ((1 - tbBlerTarget) .^ (1/nCb));
%         sinrPoint(seIdx, nPrbIdx) = icdf('Normal', 1 - cbBlerTarget, estMu, estSig);
%     end
% end
% figure(3); hold on; grid on;
% mesh(startSeIdx:endSeIdx, nPrbTest, sinrPoint(startSeIdx:endSeIdx, :)');
% 
