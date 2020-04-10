%%
clear all;

seIdx = 12; nSymbol = 12;
testPRB_list = [38, 41, 47, 53, 59, 65, 71, 77, ...
                80, 92, 104, 116, 128, 140, 152, ...
                192, 222, ...
                251];

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

