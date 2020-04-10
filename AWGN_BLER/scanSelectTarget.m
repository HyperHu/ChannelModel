clear all; addpath(pwd + "\Utility");
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
        [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, 12, snrdB_List, initIdx);
        cntItem = cntItem + 1;
        nPrbSet{cntItem} = nPrb; seIdxSet{cntItem} = seIdx;
        cbBlerListSet{cntItem} = cbBlerCurve; tbBlerListSet{cntItem} = tbBlerCurve;
        save("BGN1_NCB1.mat", "seIdxSet", "nPrbSet", "snrdB_List", "cbBlerListSet", "tbBlerListSet");
    end
end
