%%
% clear all;
% load("TablesIn3GPP.mat");
% nPrb = 10;
% [tbBlerSurf, cbBlerSurf, snrPoint, AList, BList, CList, XList] = LoadAllData(nPrb);
% 
% figure(1); hold on; grid on;
% plot(XList .* BitsPerSymbol_Table', AList .* CList, '*-');
% figure(2); hold on; grid on;
% plot(XList .* BitsPerSymbol_Table', BList, '*-');
% figure(3); hold on; grid on;
% plot(XList .* BitsPerSymbol_Table', CList, '*-');

%%
clear all;
load("TablesIn3GPP.mat");

% load("blerMatQPSK_PRB5.mat", 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
% [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(4, :), snrdB_List, 1);
% 
% load("blerMatQPSK_PRB5_new.mat", 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
% [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(4, :), snrdB_List, 1);

%%
allX = [];
allB = [];
allC = [];
%%
%%%% QPSK:1-16, 16QAM:17-23, 64QAM:24-35, 256QAM:36-43 %%%%
theFileName = "NewData\blerMatQPSK_PRB10.mat"; startSeIdx = 1; endSeIdx = 16;
% theFileName = "blerMatQPSK_PRB10.mat"; startSeIdx = 1; endSeIdx = 16;
%theFileName = "blerMat16QAM_PRB10.mat"; startSeIdx = 17; endSeIdx = 23;
%theFileName = "blerMat64QAM_PRB10.mat"; startSeIdx = 24; endSeIdx = 35;
%theFileName = "blerMat256QAM_PRB10.mat"; startSeIdx = 36; endSeIdx = 43;
load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');

tmpX = zeros(1, endSeIdx-startSeIdx+1);
tmpB = zeros(1, endSeIdx-startSeIdx+1);
tmpC = zeros(1, endSeIdx-startSeIdx+1);
for seIdx = startSeIdx:endSeIdx
    [theTbSize, bgn, nCb, effCodeRate] = CalSchInfo(seIdx, nPrb, 12);
    [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 1);
    theTbCurve = 1 - (1 - theCbCurve) .^ nCb;
    
    tmpX(seIdx-startSeIdx+1) = effCodeRate;
    tmpB(seIdx-startSeIdx+1) = B;
    tmpC(seIdx-startSeIdx+1) = C;
    
%     figure(10); hold on; grid on;
%     if (bgn == 1)
%         plot(log(effCodeRate), B, '*');
%     else
%         plot(log(effCodeRate), B, 'x');
%     end
%     figure(11); hold on; grid on;
%     if (bgn == 1)
%         plot(log(effCodeRate), C, '*');
%     else
%         plot(log(effCodeRate), C, 'x');
%     end
    
    figure(30); hold on; grid on;
    if (nCb > 1)
        plot(snrdB_List, cbBlerMatrix(seIdx, :), '.'); plot(snrPoint, theCbCurve, '--');
    end
    plot(snrdB_List, tbBlerMatrix(seIdx, :), '.'); plot(snrPoint, theTbCurve);
end
allX = [allX tmpX]; allB = [allB tmpB]; allC = [allC tmpC];


%%
function [estBlerCurve, snrPoint, A, B, C] = FitOneBlerCurve(theBlerCurve, snrdB_List, showFigure)
    theL = 1; margin = -2;
    nPoint = floor(size(theBlerCurve,2) / theL) * theL;
    filterCurve = sum(reshape(theBlerCurve(1:nPoint), theL, []), 1);
    filterSnr = mean(reshape(snrdB_List(1:nPoint), theL, []), 1);
    diffVal = [theL filterCurve(1:end-1)] - filterCurve;
    diffVal = diffVal ./ sum(diffVal);
    idxL = max(1, find(diffVal > 0, 1, 'first') - margin);
    idxR = min(size(filterCurve, 2), find(diffVal > 0, 1, 'last') + margin);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [0.1 (filterSnr(idxL) + filterSnr(idxR))/2 0.25];
    fff_gauss = fit(filterSnr(idxL:idxR)',diffVal(idxL:idxR)',gaussEqn, 'Start', startPoints);
    
    snrPoint = -15:0.001:30;
    estDiff_gauss = fff_gauss(snrPoint); estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
    tmpL = find(estDiff_gauss > 0.0001, 1, 'first'); tmpR = find(estDiff_gauss > 0.0001, 1, 'last');
    gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [fff_gauss.a fff_gauss.b fff_gauss.c];
    fff_gauss = fit(snrPoint(tmpL:tmpR)',estDiff_gauss(tmpL:tmpR),gaussEqn, 'Start', startPoints);
    
    estDiff_gauss = fff_gauss(snrPoint); estDiff = estDiff_gauss; fff = fff_gauss;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [0.1 (filterSnr(idxL) + filterSnr(idxR))/2 0.25];
%     fff_gauss = fit(filterSnr(idxL:idxR)',diffVal(idxL:idxR)',gaussEqn, 'Start', startPoints);
%     estDiff_gauss = fff_gauss(filterSnr); estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
%     gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [fff_gauss.a fff_gauss.b fff_gauss.c];
%     fff_gauss = fit(filterSnr(idxL:idxR)',estDiff_gauss(idxL:idxR),gaussEqn, 'Start', startPoints);
%     newEqn = 'a+b*(c/(10^(x/10))-x)'; startPoints = [-30 5 -db2pow(fff_gauss.b + pow2db(10/log(10)))];
%     fff_new = fit(filterSnr(idxL:idxR)',log(diffVal(idxL:idxR)'), newEqn, 'Start', startPoints);
%     estDiff_new = exp(fff_new(filterSnr));
%     estDiff = estDiff_new ./ sum(estDiff_new); fff = fff_new;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    estBlerCurve = zeros(1, size(estDiff, 1)); estBlerCurve(1) = 1;
    for idx = 2:size(estDiff,1)
        estBlerCurve(idx) = estBlerCurve(idx-1) - estDiff(idx);
    end
    A = fff.a; B = fff.b; C = fff.c;
    
    if showFigure > 0
        
        figure(showFigure); hold on; grid on;
        tmpIdx = 1 + (0:size(snrdB_List,2)-1) * floor((snrdB_List(2)-snrdB_List(1)) / (snrPoint(2) - snrPoint(1)));
        plot(snrdB_List, theBlerCurve - estBlerCurve(tmpIdx), '.-');
        
        figure(showFigure+1); hold on; grid on;
        tmpIdx = 1 + (idxL-1:idxR-1) * floor((filterSnr(2)-filterSnr(1)) / (snrPoint(2) - snrPoint(1)));
        plot(filterSnr(idxL:idxR), diffVal(idxL:idxR), '*');
        plot(filterSnr(idxL:idxR), estDiff(tmpIdx)*floor((filterSnr(2)-filterSnr(1)) / (snrPoint(2) - snrPoint(1))), '--');   
    end
end

%%
function [theTbSize, bgn, nCb, effCodeRate] = CalSchInfo(seIdx, nPrb, nSymbol)
    load("TablesIn3GPP.mat", 'TargetCodeRate_Table', 'BitsPerSymbol_Table', 'ModulationOrder_Table');
    pdsch = struct(); pdsch.NLayers = 1;
    pdsch.PRBSet = 0:nPrb - 1; pdsch.nPrb = nPrb; pdsch.nSymbol = nSymbol;
    pdsch.TargetCodeRate = TargetCodeRate_Table(seIdx) / 1024;
    pdsch.Modulation = ModulationOrder_Table{seIdx};
    pdsch.BitsPerSymbol = BitsPerSymbol_Table(seIdx);
    
    theTbSize = hPDSCHTBS(pdsch, 12*pdsch.nSymbol);
    tmpInfo = nrDLSCHInfo(theTbSize, pdsch.TargetCodeRate);
    bgn = tmpInfo.BGN; nCb = tmpInfo.C;
    effCodeRate = theTbSize + tmpInfo.L + tmpInfo.C * tmpInfo.Lcb;
    effCodeRate = effCodeRate / (12 * nSymbol * nPrb * pdsch.BitsPerSymbol * pdsch.NLayers);
end

function [tbBlerSurf, cbBlerSurf, snrPoint, AList, BList, CList, XList] = LoadAllData(nPrb)

    snrPoint = -15:0.001:30;
    tbBlerSurf = zeros(43, size(snrPoint,2));
    cbBlerSurf = zeros(43, size(snrPoint,2));
    AList = zeros(43,1);
    BList = zeros(43,1);
    CList = zeros(43,1);
    XList = zeros(43,1);

    theFileName = "blerMatQPSK_PRB" + nPrb + ".mat"; startSeIdx = 1; endSeIdx = 16;
    load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix');
    for seIdx = startSeIdx:endSeIdx
        [~, ~, nCb, effCodeRate] = CalSchInfo(seIdx, nPrb, 12);
        [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 0);
        theTbCurve = 1 - (1 - theCbCurve) .^ nCb;
        XList(seIdx) = effCodeRate;
        AList(seIdx) = A;
        BList(seIdx) = B;
        CList(seIdx) = C;
        tbBlerSurf(seIdx, :) = theTbCurve;
        cbBlerSurf(seIdx, :) = theCbCurve;
    end
    
    theFileName = "blerMat16QAM_PRB" + nPrb + ".mat"; startSeIdx = 17; endSeIdx = 23;
    load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix');
    for seIdx = startSeIdx:endSeIdx
        [~, ~, nCb, effCodeRate] = CalSchInfo(seIdx, nPrb, 12);
        [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 0);
        theTbCurve = 1 - (1 - theCbCurve) .^ nCb;
        XList(seIdx) = effCodeRate;
        AList(seIdx) = A;
        BList(seIdx) = B;
        CList(seIdx) = C;
        tbBlerSurf(seIdx, :) = theTbCurve;
        cbBlerSurf(seIdx, :) = theCbCurve;
    end

    theFileName = "blerMat64QAM_PRB" + nPrb + ".mat"; startSeIdx = 24; endSeIdx = 35;
    load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix');
    for seIdx = startSeIdx:endSeIdx
        [~, ~, nCb, effCodeRate] = CalSchInfo(seIdx, nPrb, 12);
        [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 0);
        theTbCurve = 1 - (1 - theCbCurve) .^ nCb;
        XList(seIdx) = effCodeRate;
        AList(seIdx) = A;
        BList(seIdx) = B;
        CList(seIdx) = C;
        tbBlerSurf(seIdx, :) = theTbCurve;
        cbBlerSurf(seIdx, :) = theCbCurve;
    end
    
    theFileName = "blerMat256QAM_PRB" + nPrb + ".mat"; startSeIdx = 36; endSeIdx = 43;
    load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix');
    for seIdx = startSeIdx:endSeIdx
        [~, ~, nCb, effCodeRate] = CalSchInfo(seIdx, nPrb, 12);
        [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 0);
        theTbCurve = 1 - (1 - theCbCurve) .^ nCb;
        XList(seIdx) = effCodeRate;
        AList(seIdx) = A;
        BList(seIdx) = B;
        CList(seIdx) = C;
        tbBlerSurf(seIdx, :) = theTbCurve;
        cbBlerSurf(seIdx, :) = theCbCurve;
    end

end

