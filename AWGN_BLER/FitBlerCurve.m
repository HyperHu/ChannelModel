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
% theFileName = "NewData\blerMatQPSK_PRB10.mat"; startSeIdx = 1; endSeIdx = 16;
theFileName = "NewData\blerMat16QAM_PRB10.mat"; startSeIdx = 17; endSeIdx = 20;
% theFileName = "NewData\blerMat64QAM_PRB10.mat"; startSeIdx = 24; endSeIdx = 35;

% theFileName = "blerMatQPSK_PRB10.mat"; startSeIdx = 1; endSeIdx = 16;
% theFileName = "blerMat16QAM_PRB10.mat"; startSeIdx = 17; endSeIdx = 23;
% theFileName = "blerMat64QAM_PRB10.mat"; startSeIdx = 24; endSeIdx = 35;
% theFileName = "blerMat256QAM_PRB10.mat"; startSeIdx = 36; endSeIdx = 43;
load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');

tmpX = zeros(1, endSeIdx-startSeIdx+1);
tmpB = zeros(1, endSeIdx-startSeIdx+1);
tmpC = zeros(1, endSeIdx-startSeIdx+1);
for seIdx = startSeIdx:endSeIdx
    [theTbSize, bgn, nCb, effCodeRate] = CalSchInfo(seIdx, nPrb, 12);
    [theCbCurve, snrPoint, A, B, C, theErr] = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 1);
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
    figure(31); hold on; grid on;
    plot(seIdx, theErr, 'x');
end
allX = [allX tmpX]; allB = [allB tmpB]; allC = [allC tmpC];


%%
function [estBlerCurve, snrPoint, A, B, C, stdErr] = FitOneBlerCurve(theBlerCurve, snrdB_List, showFigure)
    idxS = find(theBlerCurve < 1, 1, 'first'); idxE = find(theBlerCurve > 0, 1, 'last');
    tmpY = theBlerCurve(idxS:idxE-1) - theBlerCurve(idxS+1:idxE); tmpX = snrdB_List(idxS+1:idxE);
  
    %%%%%%%%%%%%%%%%%%%%%%%%%% Fit based on Gauss %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [0.05 mean(tmpX) 0.25];
    fff_gauss = fit(tmpX', tmpY', gaussEqn, 'Start', startPoints);
    
    snrPoint = -15:0.001:30; estY = fff_gauss(snrPoint); estY = estY ./ sum(estY);
    tmpL = find(estY > 0.000001, 1, 'first'); tmpR = find(estY > 0.000001, 1, 'last');
    gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [fff_gauss.a fff_gauss.b fff_gauss.c];
    fff_gauss = fit(snrPoint(tmpL:tmpR)', estY(tmpL:tmpR), gaussEqn, 'Start', startPoints);
    
    estY = fff_gauss(snrPoint); estDiff = estY; fff = fff_gauss;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% New Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    deltaXXX = min(max(tmpX) - fff.b, fff.b - min(tmpX)); x0 = fff.b; x1 = x0 + deltaXXX;
    y0 = fff(x0); y1 = fff(x1); yy0 = db2pow(-x0) * exp(-db2pow(fff.b - x0)); yy1 = db2pow(-x1) * exp(-db2pow(fff.b - x1));
    tmpC = log(y0 / y1) / log(yy0 / yy1); tmpB = fff.b; 
    
    testNList = tmpC/4:1:tmpC*2; testBList = tmpB-0.5:0.001:tmpB+0.5; minErr = 1e10; ccc = 0; bbb = 0;
    for iii = 1:size(testNList,2)
        for jjj = 1:size(testBList,2)
            tmpYY = db2pow(-tmpX) .* exp(-db2pow(testBList(jjj)-tmpX)); tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ testNList(iii);
            tmpYY = tmpYY / sum(tmpYY); tmpYY = tmpYY * sum(tmpY);
            tmpV = std(tmpY - tmpYY);
            if tmpV < minErr
                minErr = tmpV; ccc = testNList(iii); bbb = testBList(jjj);
            end
        end
    end
    
    tmpYY = db2pow(-snrPoint) .* exp(-db2pow(bbb-snrPoint)); tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ ccc;
    tmpYY = tmpYY / sum(tmpYY); estDiff = tmpYY';
    figure(showFigure+3); hold on; grid on;
    plot(snrPoint, tmpYY);

   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    estBlerCurve = zeros(1, size(estDiff, 1)); estBlerCurve(1) = 1;
    for idx = 2:size(estDiff,1)
        estBlerCurve(idx) = estBlerCurve(idx-1) - estDiff(idx);
    end
    A = fff.a; B = fff.b; C = fff.c;
    tmpIdx = 1 + (idxS-1:idxE-1) * floor((snrdB_List(2)-snrdB_List(1)) / (snrPoint(2) - snrPoint(1)));
    stdErr = std(theBlerCurve(idxS:idxE) - estBlerCurve(tmpIdx));
    
    if showFigure > 0
        figure(showFigure); hold on; grid on;
        plot(snrdB_List(idxS:idxE), theBlerCurve(idxS:idxE) - estBlerCurve(tmpIdx), '.-');
        
        figure(showFigure+1); hold on; grid on;
        plot(tmpX, tmpY, '.'); plot(tmpX, estBlerCurve(tmpIdx(1:end-1)) - estBlerCurve(tmpIdx(2:end)), '--');
        
        tmpYY = db2pow(-tmpX) .* exp(-db2pow(bbb-tmpX));
        tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ ccc;
        plot(tmpX, tmpYY * sum(tmpY) / sum(tmpYY), ':');
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

