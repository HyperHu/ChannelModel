%%
clear all;
SpectralEfficiency_Table_size = 43;

% %nPRB_list = [1, 2, 4, 5, 8, 10, 16, 20, 32, 50, 64, 100, 128, 200, 256];
% testPRB_list = [1, 2, 5, 20, 50, 100, 200];
% for nPrbIdx = 1:size(testPRB_list,2)
%     load("SINRMidPoint.mat");
%     assert(size(SINRMidPoint, 2) == SpectralEfficiency_Table_size);
%     nPrb = testPRB_list(nPrbIdx);
%     tmpIII = find(nPrb >= nPRB_list, 1, 'last');
%     
%     theMod = "QPSK"; seStart = 1; seEnd = 16; ddd = 0.025;
%     %theMod = "16QAM"; seStart = 17; seEnd = 23; ddd = 0.02;
%     %theMod = "64QAM"; seStart = 24; seEnd = 35; ddd = 0.02;
%     %theMod = "256QAM"; seStart = 36; seEnd = 43; ddd = 0.01;
%     
%     snrdB_List = -15:ddd:30;
%     blerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
%     for seIdx = seStart:seEnd
%         tic
%         midIdx = find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1);
%         [blerCurve, ~] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx);
%         blerMatrix(seIdx, :) = blerCurve;
%         toc
%     end
%     save("blerMat"+theMod+"_PRB"+nPrb, "blerMatrix", "snrdB_List", "nPrb");
% end

theMod = "16QAM";ddd = 0.02; seIdx = 20; nPrb = 50; snrdB_List = -15:ddd:30;
%SINRMidPoint = 1.015 * (1:SpectralEfficiency_Table_size) - 12.5 + 1.25;
load("SINRMidPoint.mat");
tmpIII = find(nPrb >= nPRB_list, 1, 'last');
midIdx = find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1);
[blerCurve, ~, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx);
save("blerCur"+theMod+"_PRB"+nPrb+"_SeId"+seIdx, "blerCurve", "cbBlerCurve", "snrdB_List");

theMod = "16QAM";ddd = 0.02; seIdx = 20; nPrb = 100; snrdB_List = -15:ddd:30;
%SINRMidPoint = 1.015 * (1:SpectralEfficiency_Table_size) - 12.5 + 1.25;
load("SINRMidPoint.mat");
tmpIII = find(nPrb >= nPRB_list, 1, 'last');
midIdx = find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1);
[blerCurve, ~, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx);
save("blerCur"+theMod+"_PRB"+nPrb+"_SeId"+seIdx, "blerCurve", "cbBlerCurve", "snrdB_List");

function [blerCurve, sigCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx)
nSample = 1000;
nIterMax = 25;
thT = 0.01;

blerCurve = zeros(size(snrdB_List));
sigCurve = ones(size(snrdB_List));
cbBlerCurve = ones(size(snrdB_List));

tmpIdx = midIdx;
while true
    nIter = 0;
    aveTbBler = 0;
    aveCbBler = 0;
    while true
        [theTbBler, theCbBler] = calBler(seIdx, snrdB_List(tmpIdx), nPrb, nSample);
        aveTbBler = (aveTbBler * nIter + theTbBler) / (nIter + 1);
        aveCbBler = (aveCbBler * nIter + theCbBler) / (nIter + 1);
        nIter = nIter + 1;
        tmpT = min(aveTbBler, 1-aveTbBler); assert(tmpT >= 0);
        tmpSigma = sqrt(aveTbBler * (1 - aveTbBler) / (nSample*nIter - 1));
        if (nIter >= nIterMax) || ((tmpT > 0) && (2*tmpSigma/tmpT < 0.1))
            break;
        end
    end
    fprintf('seIdx %d SINR %.4f BLER %.4f [ %.4f %.4f ] [%.4f %d]\n',...
        seIdx, snrdB_List(tmpIdx), aveTbBler,...
        aveTbBler-2*tmpSigma, aveTbBler+2*tmpSigma,...
        tmpSigma, nIter);
    blerCurve(tmpIdx) = aveTbBler;
    sigCurve(tmpIdx) = tmpSigma;
    cbBlerCurve(tmpIdx) = aveCbBler;
    tmpIdx = tmpIdx + 1;
    if tmpT < thT
        break;
    end
end

tmpIdx = midIdx;
while true
    nIter = 0;
    aveTbBler = 0;
    aveCbBler = 0;
    while true
        [theTbBler, theCbBler] = calBler(seIdx, snrdB_List(tmpIdx), nPrb, nSample);
        aveTbBler = (aveTbBler * nIter + theTbBler) / (nIter + 1);
        aveCbBler = (aveCbBler * nIter + theCbBler) / (nIter + 1);
        nIter = nIter + 1;
        tmpT = min(aveTbBler, 1-aveTbBler); assert(tmpT >= 0);
        tmpSigma = sqrt(aveTbBler * (1 - aveTbBler) / (nSample*nIter - 1));
        if (nIter >= nIterMax) || ((tmpT > 0) && (2*tmpSigma/tmpT < 0.1))
            break;
        end
    end
    fprintf('seIdx %d SINR %.4f BLER %.4f [ %.4f %.4f ] [%.4f %d]\n',...
        seIdx, snrdB_List(tmpIdx), aveTbBler,...
        aveTbBler-2*tmpSigma, aveTbBler+2*tmpSigma,...
        tmpSigma, nIter);
    blerCurve(tmpIdx) = aveTbBler;
    sigCurve(tmpIdx) = tmpSigma;
    cbBlerCurve(tmpIdx) = aveCbBler;
    tmpIdx = tmpIdx - 1;
    if tmpT < thT
        break;
    end
end
blerCurve(1:tmpIdx) = 1;
cbBlerCurve(1:tmpIdx) = 1;
end

