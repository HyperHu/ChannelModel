%%
clearvars; addpath(pwd + "\Utility");

seIdx = 33; nSymbol = 10;
testPRB_list = [4];

snrdB_List = -15:0.01:30;
tbBlerMatrix = zeros(size(testPRB_list,2), size(snrdB_List,2));
cbBlerMatrix = zeros(size(testPRB_list,2), size(snrdB_List,2));
for nPrbIdx = 1:size(testPRB_list,2)
    load("SINRMidPoint.mat");
    assert(size(SINRMidPoint, 2) == 43);
    nPrb = testPRB_list(nPrbIdx);
    tmpIII = find(nPrb >= nPRB_list, 1, 'last');
    midIdx = find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1);    

    tic
    [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, nSymbol, snrdB_List, midIdx);
    tbBlerMatrix(nPrbIdx, :) = tbBlerCurve;
    cbBlerMatrix(nPrbIdx, :) = cbBlerCurve;
    toc
    save("testData_SE"+seIdx+"_SYM"+nSymbol, "tbBlerMatrix", "cbBlerMatrix", "snrdB_List", "testPRB_list");
end

