%%
% clear all;
% SpectralEfficiency_Table_size = 43;
% testPRB_list = 36:6:78;
% seIdx = 12;

% snrdB_List = -15:0.01:30;
% tbBlerMatrix = zeros(size(testPRB_list,2), size(snrdB_List,2));
% cbBlerMatrix = zeros(size(testPRB_list,2), size(snrdB_List,2));
% for nPrbIdx = 1:size(testPRB_list,2)
%     load("SINRMidPoint.mat");
%     assert(size(SINRMidPoint, 2) == SpectralEfficiency_Table_size);
%     nPrb = testPRB_list(nPrbIdx);
%     tmpIII = find(nPrb >= nPRB_list, 1, 'last');
%     midIdx = find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1);    

%     tic
%     [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx);
%     tbBlerMatrix(nPrbIdx, :) = tbBlerCurve;
%     cbBlerMatrix(nPrbIdx, :) = cbBlerCurve;
%     toc
%     save("testData_SE12.mat", "tbBlerMatrix", "cbBlerMatrix", "snrdB_List", "testPRB_list");
% end

%%
clear all;

testPRB_list = [5, 10, 20, 50, 100];
for nPrbIdx = 1:size(testPRB_list,2)
    load("SINRMidPoint.mat"); assert(size(SINRMidPoint, 2) == 43);
    nPrb = testPRB_list(nPrbIdx); tmpIII = find(nPrb >= nPRB_list, 1, 'last');

    %%%% QPSK:1-16, 16QAM:17-23, 64QAM:24-35, 256QAM:36-43 %%%%
    theMod = "QPSK"; seStart = 1; seEnd = 16; ddd = 0.01; snrdB_List = -15:ddd:30;
    tbBlerMatrix = zeros(43, size(snrdB_List,2)); cbBlerMatrix = zeros(43, size(snrdB_List,2));
    for seIdx = seStart:seEnd
        tic
        [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1));
        tbBlerMatrix(seIdx, :) = tbBlerCurve; cbBlerMatrix(seIdx, :) = cbBlerCurve;
        save("blerMat"+theMod+"_PRB"+nPrb, "tbBlerMatrix", "cbBlerMatrix", "snrdB_List", "nPrb");
        toc
    end

    theMod = "16QAM"; seStart = 17; seEnd = 23; ddd = 0.01; snrdB_List = -15:ddd:30;
    tbBlerMatrix = zeros(43, size(snrdB_List,2)); cbBlerMatrix = zeros(43, size(snrdB_List,2));
    for seIdx = seStart:seEnd
        tic
        [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1));
        tbBlerMatrix(seIdx, :) = tbBlerCurve; cbBlerMatrix(seIdx, :) = cbBlerCurve;
        save("blerMat"+theMod+"_PRB"+nPrb, "tbBlerMatrix", "cbBlerMatrix", "snrdB_List", "nPrb");
        toc
    end

    theMod = "64QAM"; seStart = 24; seEnd = 35; ddd = 0.01; snrdB_List = -15:ddd:30;
    tbBlerMatrix = zeros(43, size(snrdB_List,2)); cbBlerMatrix = zeros(43, size(snrdB_List,2));
    for seIdx = seStart:seEnd
        tic
        [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1));
        tbBlerMatrix(seIdx, :) = tbBlerCurve; cbBlerMatrix(seIdx, :) = cbBlerCurve;
        save("blerMat"+theMod+"_PRB"+nPrb, "tbBlerMatrix", "cbBlerMatrix", "snrdB_List", "nPrb");
        toc
    end
end


function [blerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx)
    thT = 0.05; nSymbol = 12;
    blerCurve = zeros(size(snrdB_List)); cbBlerCurve = zeros(size(snrdB_List));

    tmpIdx = midIdx;
    while true
        [aveTbBler, aveCbBler] = CalBlerPoint(seIdx, nPrb, nSymbol, snrdB_List(tmpIdx));
        blerCurve(tmpIdx) = aveTbBler; cbBlerCurve(tmpIdx) = aveCbBler; tmpIdx = tmpIdx + 1;
        if (aveCbBler < thT)
            break;
        end
    end

    tmpIdx = midIdx - 1;
    while true
        [aveTbBler, aveCbBler] = CalBlerPoint(seIdx, nPrb, nSymbol, snrdB_List(tmpIdx));
        blerCurve(tmpIdx) = aveTbBler; cbBlerCurve(tmpIdx) = aveCbBler; tmpIdx = tmpIdx - 1;
        if (1 - aveCbBler) < thT
            break;
        end
    end
    blerCurve(1:tmpIdx) = 1; cbBlerCurve(1:tmpIdx) = 1;
end

function [aveTbBler, aveCbBler] = CalBlerPoint(seIdx, nPrb, nSymbol, snrdB)   
    nSample = 1000; nIterMax = 30; muList = tinv(0.99, 1:nIterMax);
    tbBlerSamples = zeros(1,nIterMax); cbBlerSamples = zeros(1,nIterMax);
    
    nIter = 0;
    while true
        [theTbBler, theCbBler] = calBler(seIdx, nPrb, nSymbol, snrdB, nSample);
        nIter = nIter + 1; tbBlerSamples(nIter) = theTbBler; cbBlerSamples(nIter) = theCbBler;
        if (nIter < 10)
            continue;
        end

        varTbBler = var(tbBlerSamples(1:nIter)); varCbBler = var(cbBlerSamples(1:nIter));
        sigmaTb = muList(nIter) * sqrt(varTbBler / nIter); sigmaCb = muList(nIter) * sqrt(varCbBler / nIter);
        if (nIter >= nIterMax) || (max(sigmaTb, sigmaCb) < 0.01)
            break;
        end
    end
    aveTbBler = mean(tbBlerSamples(1:nIter)); aveCbBler = mean(cbBlerSamples(1:nIter));
    fprintf('cfg: [ %d %d %d ] SINR: %.2f TBBLER: %.4f [ %.4f %.4f %.4f ] CBBLER: %.4f [ %.4f %.4f %.4f ] N: %d\n',...
            seIdx, nPrb, nSymbol, snrdB, aveTbBler, aveTbBler-sigmaTb, aveTbBler+sigmaTb, sigmaTb,...
            aveCbBler, aveCbBler-sigmaCb, aveCbBler+sigmaCb, sigmaCb, nIter);

end
