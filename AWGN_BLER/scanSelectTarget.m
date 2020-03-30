clear all;
load("SelectTarget.mat");
load("SINRMidPoint.mat");

nPrbSet = {}; seIdxSet = {};
cbBlerListSet = {}; tbBlerListSet = {};

selectTarget = selectSet_bgn1_ncb1; ddd = 0.01; snrdB_List = -15:ddd:30;
cntItem = 0;
for seIdx = 1:size(selectTarget, 2)
    for nPrbIdx = 1:size(selectTarget{seIdx}, 2)
        if mod(nPrbIdx, 5) ~= 1
            continue;
        end
        nPrb = selectTarget{seIdx}(nPrbIdx);
        tmpIII = find(nPrb >= nPRB_list, 1, 'last');
        initSinr = 0; initIdx = find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1);
        [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, initIdx);
        cntItem = cntItem + 1;
        nPrbSet{cntItem} = nPrb; seIdxSet{cntItem} = seIdx;
        cbBlerListSet{cntItem} = cbBlerCurve; tbBlerListSet{cntItem} = tbBlerCurve;
        save("BGN1_NCB1.mat", "seIdxSet", "nPrbSet", "snrdB_List", "cbBlerListSet", "tbBlerListSet");
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