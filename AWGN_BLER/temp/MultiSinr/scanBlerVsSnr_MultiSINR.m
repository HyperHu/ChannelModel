%%
clear all; addpath(pwd + "/../../Utility");

seIdx = 12; nPrb = 8; nSymbol = 9;
effSinrList = [-0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4]' + (-0.14);
tmpSinr1 = effSinrList + (0:-0.05:-pow2db(2));
tmpSinr2 = -pow2db(db2pow(-effSinrList) * 2 - db2pow(-tmpSinr1));
tmpResult = zeros(size(tmpSinr2));
for idxJ = 1:size(tmpResult,2)
    for idxI = 1:size(tmpResult,1)
        [~, aveCbBler] = CalBlerPoint(seIdx, nPrb, nSymbol, tmpSinr1(idxI,idxJ), tmpSinr2(idxI,idxJ));
        tmpResult(idxI,idxJ) = aveCbBler;
    end
    save("MoreResult_SE12.mat", "tmpResult", "seIdx", "nPrb", "nSymbol", "tmpSinr1", "tmpSinr2");
end

%%
seIdx = 16; nPrb = 8; nSymbol = 9;
effSinrList = [-0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4]' + (3.58);
tmpSinr1 = effSinrList + (0:-0.05:-pow2db(2));
tmpSinr2 = -pow2db(db2pow(-effSinrList) * 2 - db2pow(-tmpSinr1));
tmpResult = zeros(size(tmpSinr2));
for idxJ = 1:size(tmpResult,2)
    for idxI = 1:size(tmpResult,1)
        [~, aveCbBler] = CalBlerPoint(seIdx, nPrb, nSymbol, tmpSinr1(idxI,idxJ), tmpSinr2(idxI,idxJ));
        tmpResult(idxI,idxJ) = aveCbBler;
    end
    save("MoreResult_SE16.mat", "tmpResult", "seIdx", "nPrb", "nSymbol", "tmpSinr1", "tmpSinr2");
end

