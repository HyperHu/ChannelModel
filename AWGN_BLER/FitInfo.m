%% parameter set
clear all;
addpath(pwd + "\Utility");

%% Load data
makeNewRawData = false; showFigure = 1; theFitMode = 4;
if (makeNewRawData == true)
    load("4QAMSampleSet.mat");
    effCodeRate_4QAM = zeros(size(seIdxSetAll)); allK_dot_4QAM = zeros(size(seIdxSetAll));
    muSINR_4QAM = zeros(size(seIdxSetAll)); sigmadB_4QAM = zeros(size(seIdxSetAll));
    blerErr_4QAM = zeros(size(seIdxSetAll)); bgn_4QAM = zeros(size(seIdxSetAll));
    for itemIdx = 1:size(seIdxSetAll, 2)
        seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx}; nSym = nSymSetAll{itemIdx};
        [~, bgn, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, nSym);
        [theB, theC, theErr, ~, ~] = FitOneBlerCurve(snrdBSetAll{itemIdx}, cbBlerListSetAll{itemIdx}, theFitMode, showFigure);
        effCodeRate_4QAM(itemIdx) = effCR; allK_dot_4QAM(itemIdx) = k_dot;
        muSINR_4QAM(itemIdx) = theB; sigmadB_4QAM(itemIdx) = theC;
        blerErr_4QAM(itemIdx) = theErr; bgn_4QAM(itemIdx) = bgn;
    end
    
    load("16QAMSampleSet.mat");
    effCodeRate_16QAM = zeros(size(seIdxSetAll)); allK_dot_16QAM = zeros(size(seIdxSetAll));
    muSINR_16QAM = zeros(size(seIdxSetAll)); sigmadB_16QAM = zeros(size(seIdxSetAll));
    blerErr_16QAM = zeros(size(seIdxSetAll)); bgn_16QAM = zeros(size(seIdxSetAll));
    for itemIdx = 1:size(seIdxSetAll, 2)
        seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx}; nSym = nSymSetAll{itemIdx};
        [~, bgn, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, nSym);
        [theB, theC, theErr, ~, ~] = FitOneBlerCurve(snrdBSetAll{itemIdx}, cbBlerListSetAll{itemIdx}, theFitMode, showFigure);
        effCodeRate_16QAM(itemIdx) = effCR; allK_dot_16QAM(itemIdx) = k_dot;
        muSINR_16QAM(itemIdx) = theB; sigmadB_16QAM(itemIdx) = theC;
        blerErr_16QAM(itemIdx) = theErr; bgn_16QAM(itemIdx) = bgn;
    end
    
    load("64QAMSampleSet.mat");
    effCodeRate_64QAM = zeros(size(seIdxSetAll)); allK_dot_64QAM = zeros(size(seIdxSetAll));
    muSINR_64QAM = zeros(size(seIdxSetAll)); sigmadB_64QAM = zeros(size(seIdxSetAll));
    blerErr_64QAM = zeros(size(seIdxSetAll)); bgn_64QAM = zeros(size(seIdxSetAll));
    for itemIdx = 1:size(seIdxSetAll, 2)
        seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx}; nSym = nSymSetAll{itemIdx};
        [~, bgn, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, nSym);
        [theB, theC, theErr, ~, ~] = FitOneBlerCurve(snrdBSetAll{itemIdx}, cbBlerListSetAll{itemIdx}, theFitMode, showFigure);
        effCodeRate_64QAM(itemIdx) = effCR; allK_dot_64QAM(itemIdx) = k_dot;
        muSINR_64QAM(itemIdx) = theB; sigmadB_64QAM(itemIdx) = theC;
        blerErr_64QAM(itemIdx) = theErr; bgn_64QAM(itemIdx) = bgn;
    end
    
    load("256QAMSampleSet.mat");
    effCodeRate_256QAM = zeros(size(seIdxSetAll)); allK_dot_256QAM = zeros(size(seIdxSetAll));
    muSINR_256QAM = zeros(size(seIdxSetAll)); sigmadB_256QAM = zeros(size(seIdxSetAll));
    blerErr_256QAM = zeros(size(seIdxSetAll)); bgn_256QAM = zeros(size(seIdxSetAll));
    for itemIdx = 1:size(seIdxSetAll, 2)
        seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx}; nSym = nSymSetAll{itemIdx};
        [~, bgn, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, nSym);
        [theB, theC, theErr, ~, ~] = FitOneBlerCurve(snrdBSetAll{itemIdx}, cbBlerListSetAll{itemIdx}, theFitMode, showFigure);
        effCodeRate_256QAM(itemIdx) = effCR; allK_dot_256QAM(itemIdx) = k_dot;
        muSINR_256QAM(itemIdx) = theB; sigmadB_256QAM(itemIdx) = theC;
        blerErr_256QAM(itemIdx) = theErr; bgn_256QAM(itemIdx) = bgn;
    end
    
    realSpectralEff_4QAM = 2 * effCodeRate_4QAM; realSpectralEff_16QAM = 4 * effCodeRate_16QAM;
    realSpectralEff_64QAM = 6 * effCodeRate_64QAM; realSpectralEff_256QAM = 8 * effCodeRate_256QAM;
    realSpectralEff = [realSpectralEff_4QAM realSpectralEff_16QAM...
                       realSpectralEff_64QAM realSpectralEff_256QAM];
    effCodeRate = [effCodeRate_4QAM effCodeRate_16QAM effCodeRate_64QAM effCodeRate_256QAM];
    allK_dot = [allK_dot_4QAM allK_dot_16QAM allK_dot_64QAM allK_dot_256QAM];
    muSINR = [muSINR_4QAM muSINR_16QAM muSINR_64QAM muSINR_256QAM];
    sigmadB = [sigmadB_4QAM sigmadB_16QAM sigmadB_64QAM sigmadB_256QAM];
    blerErr = [blerErr_4QAM blerErr_16QAM blerErr_64QAM blerErr_256QAM];
    bgnAll = [bgn_4QAM bgn_16QAM bgn_64QAM bgn_256QAM];
    save("UniformedFormulaRawdata_Mode4.mat",...
        'realSpectralEff', 'effCodeRate', 'allK_dot', 'muSINR', 'sigmadB', 'blerErr', 'bgnAll',...
        'realSpectralEff_4QAM', 'effCodeRate_4QAM', 'allK_dot_4QAM', 'muSINR_4QAM', 'sigmadB_4QAM', 'blerErr_4QAM', 'bgn_4QAM',...
        'realSpectralEff_16QAM', 'effCodeRate_16QAM', 'allK_dot_16QAM', 'muSINR_16QAM', 'sigmadB_16QAM', 'blerErr_16QAM', 'bgn_16QAM',...
        'realSpectralEff_64QAM', 'effCodeRate_64QAM', 'allK_dot_64QAM', 'muSINR_64QAM', 'sigmadB_64QAM', 'blerErr_64QAM', 'bgn_64QAM',...
        'realSpectralEff_256QAM', 'effCodeRate_256QAM', 'allK_dot_256QAM', 'muSINR_256QAM', 'sigmadB_256QAM', 'blerErr_256QAM', 'bgn_256QAM');
else
    load("UniformedFormulaRawdata_Mode3.mat");
end

checkingFLag = false;
if checkingFLag == true
    showFigure = 20;
    figure(10); hold on; grid on;
    %plot3(realSpectralEff, allK_dot, blerErr, '*');
    histogram(blerErr, 'Normalization','probability');
    selectIdx = find(blerErr > 0.011) - 890;
    load("256QAMSampleSet.mat");
    for tmpIdx = 2:3
        itemIdx = selectIdx(tmpIdx);
        seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx}; nSym = nSymSetAll{itemIdx};
        [~, bgn, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, nSym);
        [theB, theC, theErr, ~, ~] = FitOneBlerCurve(snrdBSetAll{itemIdx}, cbBlerListSetAll{itemIdx}, 3, showFigure);
        fprintf('seIdx %d, nPRB %d, nSymbol %d, effCR %.2f, k_dot %d, theErr %.4f \n',...
                seIdx, nPrb, nSym, effCR, k_dot, theErr);
    end
    
end

%% Fit Uniformed Formula -- MuSinr with Shannon
% tmpIdx = find(bgnAll == 2);
% xData = realSpectralEff(tmpIdx); yData = log2(allK_dot(tmpIdx));
% estEdge = pow2db(2.^(xData) - 1);
% diffMu = muSINR(tmpIdx) - estEdge;
% cftool(xData, yData, diffMu);

%% Fit Uniformed Formula -- MuSinr
makeNewFit = false;
if makeNewFit == true
    xList = -4.3:0.01:3.3; yList = 5.3:0.01:13.2;
    % QPSK
    tmpIdx = find(bgn_4QAM > 0);
%     xData = log2(realSpectralEff_4QAM(tmpIdx)); yData = log2(allK_dot_4QAM(tmpIdx)); checkMu = muSINR_4QAM(tmpIdx);
    xData = 2.^(realSpectralEff_4QAM(tmpIdx)); yData = log2(allK_dot_4QAM(tmpIdx)); checkMu = db2pow(muSINR_4QAM(tmpIdx));
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_4QAM = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(xData, yData, checkMu - muSinrFunc(xData,yData), 'o');

    tmpIdx = find(bgn_4QAM == 1);
    xData = log2(realSpectralEff_4QAM(tmpIdx)); yData = log2(allK_dot_4QAM(tmpIdx)); checkMu = muSINR_4QAM(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_4QAM_BGN1 = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), '*');
    
    tmpIdx = find(bgn_4QAM == 2);
    xData = log2(realSpectralEff_4QAM(tmpIdx)); yData = log2(allK_dot_4QAM(tmpIdx)); checkMu = muSINR_4QAM(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_4QAM_BGN2 = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), '*');
    % 16QAM
    tmpIdx = find(bgn_16QAM > 0);
    %xData = log2(realSpectralEff_16QAM(tmpIdx)); yData = log2(allK_dot_16QAM(tmpIdx)); checkMu = muSINR_16QAM(tmpIdx);
    xData = 2.^(realSpectralEff_16QAM(tmpIdx)); yData = log2(allK_dot_16QAM(tmpIdx)); checkMu = db2pow(muSINR_16QAM(tmpIdx));
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_16QAM = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(xData, yData, checkMu - muSinrFunc(xData,yData), 'o');

    tmpIdx = find(bgn_16QAM == 1);
    xData = log2(realSpectralEff_16QAM(tmpIdx)); yData = log2(allK_dot_16QAM(tmpIdx)); checkMu = muSINR_16QAM(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_16QAM_BGN1 = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), '*');
    
    tmpIdx = find(bgn_16QAM == 2);
    xData = log2(realSpectralEff_16QAM(tmpIdx)); yData = log2(allK_dot_16QAM(tmpIdx)); checkMu = muSINR_16QAM(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_16QAM_BGN2 = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), '*');
    % 64QAM
    tmpIdx = find(bgn_64QAM > 0);
    %xData = log2(realSpectralEff_64QAM(tmpIdx)); yData = log2(allK_dot_64QAM(tmpIdx)); checkMu = muSINR_64QAM(tmpIdx);
    xData = 2.^(realSpectralEff_64QAM(tmpIdx)); yData = log2(allK_dot_64QAM(tmpIdx)); checkMu = db2pow(muSINR_64QAM(tmpIdx));
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_64QAM = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(xData, yData, pow2db(checkMu) - pow2db(muSinrFunc(xData,yData)), 'o');

    tmpIdx = find(bgn_64QAM == 1);
    xData = log2(realSpectralEff_64QAM(tmpIdx)); yData = log2(allK_dot_64QAM(tmpIdx)); checkMu = muSINR_64QAM(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_64QAM_BGN1 = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), '*');
    
    tmpIdx = find(bgn_64QAM == 2);
    xData = log2(realSpectralEff_64QAM(tmpIdx)); yData = log2(allK_dot_64QAM(tmpIdx)); checkMu = muSINR_64QAM(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_64QAM_BGN2 = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), '*');
    % 256QAM
    tmpIdx = find(bgn_256QAM > 0);
    xData = log2(realSpectralEff_256QAM(tmpIdx)); yData = log2(allK_dot_256QAM(tmpIdx)); checkMu = muSINR_256QAM(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_256QAM = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), 'o');
    muSinrFunc_256QAM_BGN1 = muSinrFunc_256QAM; muSinrFunc_256QAM_BGN2 = muSinrFunc_256QAM;
    % All
    tmpIdx = find(bgnAll == 1);
    xData = log2(realSpectralEff(tmpIdx)); yData = log2(allK_dot(tmpIdx)); checkMu = muSINR(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_BGN1 = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), 'o');
    
    tmpIdx = find(bgnAll == 2);
    xData = log2(realSpectralEff(tmpIdx)); yData = log2(allK_dot(tmpIdx)); checkMu = muSINR(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33'); muSinrFunc_BGN2 = muSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), 'o');
    
    tmpIdx = find(bgnAll > 0);
    xData = log2(realSpectralEff(tmpIdx)); yData = log2(allK_dot(tmpIdx)); checkMu = muSINR(tmpIdx);
    muSinrFunc = fit([xData', yData'], checkMu', 'poly33');
    [xGrid, yGrid] = meshgrid(xList, yList); estMuSinr = muSinrFunc(xGrid, yGrid);
    figure(1); hold on; grid on; mesh(xList, yList, estMuSinr); plot(muSinrFunc, [xData', yData'], checkMu');
    figure(2); hold on; grid on; plot3(2.^xData, 2.^yData, checkMu - muSinrFunc(xData,yData), 'o');
    %save("UniformedFormulaFunction_BGN.mat", '-regexp', 'muSinrFunc*');
else
%     load("UniformedFormulaFunction.mat",...
%          'muSinrFunc_4QAM', 'muSinrFunc_16QAM',...
%          'muSinrFunc_64QAM', 'muSinrFunc_256QAM');
    load("UniformedFormulaFunction_BGN.mat", '-regexp', 'muSinrFunc*');
end


%% Fit Uniformed Formula -- SigmadB
makeNewFit = false;
if makeNewFit == true
    xList = -4.3:0.01:3.3; yList = 5.3:0.01:13.2;
    tmpIdx = find(bgnAll == 1);
    xData = log2(realSpectralEff(tmpIdx)); yData = log2(allK_dot(tmpIdx)); checkSigma = sigmadB(tmpIdx);
    sigmaSinrFunc = fit([xData', yData'], checkSigma', 'poly33'); sigmaSinrFunc_BGN1 = sigmaSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estSigmadB = sigmaSinrFunc_BGN1(xGrid, yGrid);
    figure(3); hold on; grid on; mesh(xList, yList, estSigmadB); plot(sigmaSinrFunc, [xData', yData'], checkSigma');
    figure(4); hold on; grid on; plot3(realSpectralEff(tmpIdx), allK_dot(tmpIdx), checkSigma - sigmaSinrFunc(xData,yData), '*');
    tmpIdx = find(bgnAll == 2);
    xData = log2(realSpectralEff(tmpIdx)); yData = log2(allK_dot(tmpIdx)); checkSigma = sigmadB(tmpIdx);
    sigmaSinrFunc = fit([xData', yData'], checkSigma', 'poly33'); sigmaSinrFunc_BGN2 = sigmaSinrFunc;
    [xGrid, yGrid] = meshgrid(xList, yList); estSigmadB = sigmaSinrFunc_BGN1(xGrid, yGrid);
    figure(3); hold on; grid on; mesh(xList, yList, estSigmadB); plot(sigmaSinrFunc, [xData', yData'], checkSigma');
    figure(4); hold on; grid on; plot3(realSpectralEff(tmpIdx), allK_dot(tmpIdx), checkSigma - sigmaSinrFunc(xData,yData), '*');
    tmpIdx = find(bgnAll > 0);
    xData = log2(realSpectralEff(tmpIdx)); yData = log2(allK_dot(tmpIdx)); checkSigma = sigmadB(tmpIdx);
    sigmaSinrFunc = fit([xData', yData'], checkSigma', 'poly33');
    [xGrid, yGrid] = meshgrid(xList, yList); estSigmadB = sigmaSinrFunc_BGN1(xGrid, yGrid);
    figure(3); hold on; grid on; mesh(xList, yList, estSigmadB); plot(sigmaSinrFunc, [xData', yData'], checkSigma');
    figure(4); hold on; grid on; plot3(realSpectralEff(tmpIdx), allK_dot(tmpIdx), checkSigma - sigmaSinrFunc(xData,yData), 'o');
    save("UniformedFormulaFunction_BGN.mat", '-regexp', 'sigmaSinrFunc*', '-append');
else
    load("UniformedFormulaFunction.mat", 'sigmaSinrFunc');
    load("UniformedFormulaFunction_BGN.mat", '-regexp', 'sigmaSinrFunc*');
end

%%
% checkSpecEff = realSpectralEff_4QAM; checkKdot = allK_dot_4QAM; checkBgn = bgn_4QAM;
% checkMu = muSINR_4QAM; checkSigma = sigmadB_4QAM;
% checkMuSinrFunc_1 = muSinrFunc_4QAM_BGN1; checkMuSinrFunc_2 = muSinrFunc_4QAM_BGN2;

% checkSpecEff = realSpectralEff_16QAM; checkKdot = allK_dot_16QAM; checkBgn = bgn_16QAM;
% checkMu = muSINR_16QAM; checkSigma = sigmadB_16QAM;
% checkMuSinrFunc_1 = muSinrFunc_16QAM_BGN1; checkMuSinrFunc_2 = muSinrFunc_16QAM_BGN2;

% checkSpecEff = realSpectralEff_64QAM; checkKdot = allK_dot_64QAM; checkBgn = bgn_64QAM;
% checkMu = muSINR_64QAM; checkSigma = sigmadB_64QAM;
% checkMuSinrFunc_1 = muSinrFunc_64QAM_BGN1; checkMuSinrFunc_2 = muSinrFunc_64QAM_BGN2;

checkSpecEff = realSpectralEff_256QAM; checkKdot = allK_dot_256QAM; checkBgn = bgn_256QAM;
checkMu = muSINR_256QAM; checkSigma = sigmadB_256QAM;
checkMuSinrFunc_1 = muSinrFunc_256QAM_BGN1; checkMuSinrFunc_2 = muSinrFunc_256QAM_BGN2;

doChecking = true; ttttAAA = [];
if doChecking == true
    snrTestList = -15:0.01:30; blerAveErr = zeros(size(checkSpecEff));
    for idx = 1:size(checkSpecEff,2)
        tmpCurve1 = erfc((snrTestList - checkMu(idx)) / checkSigma(idx))/2;
        tmpX = log2(checkSpecEff(idx)); tmpY = log2(checkKdot(idx));
        if checkBgn(idx) == 1
            tmpCurve2 = erfc((snrTestList - checkMuSinrFunc_1(tmpX, tmpY)) / sigmaSinrFunc(tmpX,tmpY))/2;
        else
            tmpCurve2 = erfc((snrTestList - checkMuSinrFunc_2(tmpX, tmpY)) / sigmaSinrFunc(tmpX,tmpY))/2;
        end
        diffCurve = (tmpCurve1 - tmpCurve2); tmpIdx = find(abs(diffCurve) > 0.0001);
        blerAveErr(idx) = sqrt(mean((diffCurve(tmpIdx)).^2));
        
        figure(7); hold on; grid on;
        %plot((snrTestList(tmpIdx) - checkMu(idx)) / (3*checkSigma(idx)), diffCurve(tmpIdx), '.');
        plot(snrTestList(tmpIdx), diffCurve(tmpIdx), '.');
    end
%     ttttAAA = [ttttAAA blerAveErr];
    figure(5); hold on; grid on;
    plot3(checkSpecEff, checkKdot, blerAveErr, '*');
    [maxV, maxI] = max(blerAveErr);
    figure(6); hold on; grid on;
    tmpCurve1 = erfc((snrTestList - checkMu(maxI)) / checkSigma(maxI))/2;
    tmpX = log2(checkSpecEff(maxI)); tmpY = log2(checkKdot(maxI));
    if checkBgn(maxI) == 1
        tmpCurve2 = erfc((snrTestList - checkMuSinrFunc_1(tmpX, tmpY)) / sigmaSinrFunc(tmpX,tmpY))/2;
    else
        tmpCurve2 = erfc((snrTestList - checkMuSinrFunc_2(tmpX, tmpY)) / sigmaSinrFunc(tmpX,tmpY))/2;
    end
    plot(snrTestList, tmpCurve1, '--'); plot(snrTestList, tmpCurve2);
end

checkingFLag = false;
if checkingFLag == true
    showFigure = 6;
    %selectIdx = find(blerAveErr > 0.2);
    selectIdx = [maxI];
    load("64QAMSampleSet.mat");
    for tmpIdx = 1:1
        itemIdx = selectIdx(tmpIdx);
        seIdx = seIdxSetAll{itemIdx}; nPrb = nPrbSetAll{itemIdx}; nSym = nSymSetAll{itemIdx};
        [~, bgn, ~, effCR, k_dot] = CalSchInfo(seIdx, nPrb, nSym);
        [theB, theC, theErr, ~, ~] = FitOneBlerCurve(snrdBSetAll{itemIdx}, cbBlerListSetAll{itemIdx}, 3, showFigure);
        fprintf('seIdx %d, nPRB %d, nSymbol %d, effCR %.2f, k_dot %d, theErr %.4f \n',...
                seIdx, nPrb, nSym, effCR, k_dot, theErr);
    end
    
end

%%
% realSpectralEff = [realSpectralEff_4QAM realSpectralEff_16QAM realSpectralEff_64QAM realSpectralEff_256QAM];
% effCodeRate = [effCodeRate_4QAM effCodeRate_16QAM effCodeRate_64QAM effCodeRate_256QAM];
% allK_dot = [allK_dot_4QAM allK_dot_16QAM allK_dot_64QAM allK_dot_256QAM];
% muSINR = [muSINR_4QAM muSINR_16QAM muSINR_64QAM muSINR_256QAM];
% sigmadB = [sigmadB_4QAM sigmadB_16QAM sigmadB_64QAM sigmadB_256QAM];
% 
% xData = log2(realSpectralEff); yData = log2(allK_dot);
% tmpCor = [cosd(45) -sind(45); sind(45) cosd(45)] * [xData; yData];
% cftool(xData, yData, muSINR); cftool(xData, yData, sigmadB);
% cftool(tmpCor(1,:), tmpCor(2,:), sigmadB);


% muSinrFunc = fit([xData', yData'], muSINR', 'poly33');
% figure(1); plot(muSinrFunc, [xData', yData'], muSINR');
% sigmaSinrFunc = fit([xData', yData'], sigmadB', 'poly33');
% figure(2); plot(sigmaSinrFunc, [xData', yData'], sigmadB');

%%


%% Varify Info -- 10% 50% 90% Bler Point
doVarify = false;
if doVarify == true
    % blerTb = 1 - ((1 - blerCb) .^ n)
    % blerCb = 1 - ((1 - blerTb) .^ (1/n))
    startSeIdx = 1; endSeIdx = 35; nSymbol = 10;
    nPrbTest = [1 2 3 4 5 6 8 10 16 20 32 48 50 64 80 96 ...
                100 112 128 144 160 176 192 208 224 250 256 273];

    testBlerTbErr = zeros(endSeIdx, size(nPrbTest,2), 3);
    testBlerCbErr = zeros(endSeIdx, size(nPrbTest,2), 3);
    for seIdx = startSeIdx:endSeIdx
        tic
        for nPrbIdx = 1:size(nPrbTest, 2)
            nPrb = nPrbTest(nPrbIdx);
            % est SINR point
            [~, bgn, nCb, effCR, k_dot] = CalSchInfo(seIdx, nPrb, nSymbol);
            if seIdx <= 16
                usingMuFunc_BGN1 = muSinrFunc_4QAM_BGN1; usingMuFunc_BGN2 = muSinrFunc_4QAM_BGN2;
                usingSpecEff = effCR * 2;
            elseif seIdx <= 23
                usingMuFunc_BGN1 = muSinrFunc_16QAM_BGN1; usingMuFunc_BGN2 = muSinrFunc_16QAM_BGN2;
                usingSpecEff = effCR * 4;
            elseif seIdx <= 35
                usingMuFunc_BGN1 = muSinrFunc_64QAM_BGN1; usingMuFunc_BGN2 = muSinrFunc_64QAM_BGN2;
                usingSpecEff = effCR * 6;
            else
                usingMuFunc_BGN1 = muSinrFunc_256QAM_BGN1; usingMuFunc_BGN2 = muSinrFunc_256QAM_BGN2;
                usingSpecEff = effCR * 8;
            end
            tmpX = log2(usingSpecEff); tmpY = log2(k_dot);
            if bgn == 1
                estMu = usingMuFunc_BGN1([tmpX, tmpY]); estSigma = sigmaSinrFunc_BGN1([tmpX, tmpY]);
            else
                estMu = usingMuFunc_BGN2([tmpX, tmpY]); estSigma = sigmaSinrFunc_BGN2([tmpX, tmpY]);
            end
            
            % 10% CBLER
            estSINR = estMu + (0.9 * estSigma);
            estCbBler = 0.1015; estTbBler = 1 - ((1 - estCbBler) .^ nCb);
            [theTbBler, theCbBler] = calBler(seIdx, nPrb, nSymbol, estSINR, estSINR, 1000*5);
            testBlerCbErr(seIdx, nPrbIdx,1) = theCbBler - estCbBler;
            testBlerTbErr(seIdx, nPrbIdx,1) = theTbBler - estTbBler;
            fprintf('cfg: [ %d %d %d ] estBler: [ %.4f %.4f ] testBler: [ %.4f %.4f ] \n',...
                    seIdx, nPrb, nSymbol, estTbBler, estCbBler, theTbBler, theCbBler);
            % 50% CBLER
            estSINR = estMu + (0.0 * estSigma);
            estCbBler = 0.5; estTbBler = 1 - ((1 - estCbBler) .^ nCb);
            [theTbBler, theCbBler] = calBler(seIdx, nPrb, nSymbol, estSINR, estSINR, 1000*5);
            testBlerCbErr(seIdx, nPrbIdx,2) = theCbBler - estCbBler;
            testBlerTbErr(seIdx, nPrbIdx,2) = theTbBler - estTbBler;
            fprintf('cfg: [ %d %d %d ] estBler: [ %.4f %.4f ] testBler: [ %.4f %.4f ] \n',...
                    seIdx, nPrb, nSymbol, estTbBler, estCbBler, theTbBler, theCbBler);
            % 90% CBLER
            estSINR = estMu + (-0.9 * estSigma);
            estCbBler = 0.8985; estTbBler = 1 - ((1 - estCbBler) .^ nCb);
            [theTbBler, theCbBler] = calBler(seIdx, nPrb, nSymbol, estSINR, estSINR, 1000*5);
            testBlerCbErr(seIdx, nPrbIdx,3) = theCbBler - estCbBler;
            testBlerTbErr(seIdx, nPrbIdx,3) = theTbBler - estTbBler;
            fprintf('cfg: [ %d %d %d ] estBler: [ %.4f %.4f ] testBler: [ %.4f %.4f ] \n',...
                    seIdx, nPrb, nSymbol, estTbBler, estCbBler, theTbBler, theCbBler);
            
        end
        toc
        save("testBlerResult.mat", 'startSeIdx', 'endSeIdx', 'nSymbol', 'nPrbTest',...
            'testBlerTbErr', 'testBlerCbErr');
    end
end

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
