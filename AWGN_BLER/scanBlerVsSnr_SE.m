%%
clear all; addpath(pwd + "\Utility");


testPRB_list = [5, 10, 20, 50, 100];
nSymbol = 12;
for nPrbIdx = 1:size(testPRB_list,2)
    load("SINRMidPoint.mat"); assert(size(SINRMidPoint, 2) == 43);
    nPrb = testPRB_list(nPrbIdx); tmpIII = find(nPrb >= nPRB_list, 1, 'last');

    %%%% QPSK:1-16, 16QAM:17-23, 64QAM:24-35, 256QAM:36-43 %%%%
    theMod = "QPSK"; seStart = 1; seEnd = 16; ddd = 0.01; snrdB_List = -15:ddd:30;
    GenDataSet(theMod, seStart, seEnd, nPrb, nSymbol, snrdB_List, SINRMidPoint(tmpIII, :));
    
    theMod = "16QAM"; seStart = 17; seEnd = 23; ddd = 0.01; snrdB_List = -15:ddd:30;
    GenDataSet(theMod, seStart, seEnd, nPrb, nSymbol, snrdB_List, SINRMidPoint(tmpIII, :));
           
    theMod = "64QAM"; seStart = 24; seEnd = 35; ddd = 0.01; snrdB_List = -15:ddd:30;
    GenDataSet(theMod, seStart, seEnd, nPrb, nSymbol, snrdB_List, SINRMidPoint(tmpIII, :));
           
    theMod = "256QAM"; seStart = 36; seEnd = 43; ddd = 0.01; snrdB_List = -15:ddd:30;
    GenDataSet(theMod, seStart, seEnd, nPrb, nSymbol, snrdB_List, SINRMidPoint(tmpIII, :));

end

function GenDataSet(theMod, seStart, seEnd, nPrb, nSymbol, snrdB_List, SINRMidPoint)
    tbBlerMatrix = zeros(43, size(snrdB_List,2)); cbBlerMatrix = zeros(43, size(snrdB_List,2));
    for seIdx = seStart:seEnd
        tic
        midIdx = find(snrdB_List > SINRMidPoint(seIdx), 1);
        [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, nSymbol, snrdB_List, midIdx);
        tbBlerMatrix(seIdx, :) = tbBlerCurve; cbBlerMatrix(seIdx, :) = cbBlerCurve;
        save("blerMat"+theMod+"_PRB"+nPrb+"_SYM"+nSymbol, "tbBlerMatrix", "cbBlerMatrix", "snrdB_List", "nPrb", "nSymbol");
        toc
    end
end

