%%
clear all;
SpectralEfficiency_Table_size = 43;

nPRB_list = [2, 4, 5, 10, 20, 50, 100, 200];
for nPrbIdx = 1:size(nPRB_list,2)
    %load("SINRMidPoint.mat");
    %assert(size(SINRMidPoint, 2) == SpectralEfficiency_Table_size);
    SINRMidPoint = 1.015 * (1:SpectralEfficiency_Table_size) - 12.5;
    nPrb = nPRB_list(nPrbIdx);
    
    theMod = "QPSK"; seStart = 1; seEnd = 16; ddd = 0.025;
    %theMod = "16QAM"; seStart = 17; seEnd = 23; ddd = 0.02;
    %theMod = "64QAM"; seStart = 24; seEnd = 35; ddd = 0.02;
    %theMod = "256QAM"; seStart = 36; seEnd = 43; ddd = 0.01;
    
    snrdB_List = -15:ddd:30;
    blerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
    for seIdx = seStart:seEnd
        tic
        midIdx = find(snrdB_List > SINRMidPoint(seIdx), 1);
        [blerCurve, ~] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx);
        blerMatrix(seIdx, :) = blerCurve;
        toc
    end
    save("blerMat"+theMod+"_PRB"+nPRB_list(nPrbIdx), "blerMatrix", "snrdB_List", "nPrb");
end

% theMod = "QPSK";ddd = 0.025; seIdx = 1; nPrb = 2; snrdB_List = -15:ddd:30;
% SINRMidPoint = 1.015 * (1:SpectralEfficiency_Table_size) - 12.5 + 1.25;
% midIdx = find(snrdB_List > SINRMidPoint(seIdx), 1);
% [blerCurve, ~] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx);
% save("blerCur"+theMod+"_PRB"+nPrb+"_SeId"+seIdx, "blerCurve");

function [blerCurve, sigCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx)
nSample = 1000;
nIterMax = 25;
thT = 0.01;

blerCurve = zeros(size(snrdB_List));
sigCurve = ones(size(snrdB_List));
tmpIdx = midIdx;
while true
    nIter = 0;
    aveBler = 0;
    while true
        aveBler = (aveBler * nIter + calBler(seIdx, snrdB_List(tmpIdx), nPrb, nSample)) / (nIter + 1);
        nIter = nIter + 1;
        tmpT = min(aveBler, 1-aveBler); assert(tmpT >= 0);
        tmpSigma = sqrt(aveBler * (1 - aveBler) / (nSample*nIter - 1));
        if (nIter >= nIterMax) || ((tmpT > 0) && (2*tmpSigma/tmpT < 0.1))
            break;
        end
    end
    fprintf('seIdx %d SINR %.4f BLER %.4f [ %.4f %.4f ] [%.4f %d]\n',...
        seIdx, snrdB_List(tmpIdx), aveBler,...
        aveBler-2*tmpSigma, aveBler+2*tmpSigma,...
        tmpSigma, nIter);
    blerCurve(tmpIdx) = aveBler;
    sigCurve(tmpIdx) = tmpSigma;
    tmpIdx = tmpIdx + 1;
    if tmpT < thT
        break;
    end
end

tmpIdx = midIdx - 1;
while true
    nIter = 0;
    aveBler = 0;
    while true
        aveBler = (aveBler * nIter + calBler(seIdx, snrdB_List(tmpIdx), nPrb, nSample)) / (nIter + 1);
        nIter = nIter + 1;
        tmpT = min(aveBler, 1-aveBler); assert(tmpT >= 0);
        tmpSigma = sqrt(aveBler * (1 - aveBler) / (nSample*nIter - 1));
        if (nIter >= nIterMax) || ((tmpT > 0) && (2*tmpSigma/tmpT < 0.1))
            break;
        end
    end
    fprintf('seIdx %d SINR %.4f BLER %.4f [ %.4f %.4f ] [%.4f %d]\n',...
        seIdx, snrdB_List(tmpIdx), aveBler,...
        aveBler-2*tmpSigma, aveBler+2*tmpSigma,...
        tmpSigma, nIter);
    blerCurve(tmpIdx) = aveBler;
    sigCurve(tmpIdx) = tmpSigma;
    tmpIdx = tmpIdx - 1;
    if tmpT < thT
        break;
    end
end
blerCurve(1:tmpIdx) = 1;
end

% %%
% % figure(1); hold on; grid on;
% % mesh(snrdB_List, sqrt(SpectralEfficiency_Table), blerMatrix);
% 
% %%
% % figure(2);
% % for idx = 1:size(blerMatrix,1)
% %     plot(snrdB_List, blerMatrix(idx,:), '*--'); hold on; grid on;
% % end




