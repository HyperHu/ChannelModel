%%
clear all;
addpath(pwd + "\Utility");


% nSymbol = 12;
% nPRB_list = 1:256;

% selectSet_bgn1_ncb1 = {};
% for seIdx = 1:43
%     selectPRB = [];
%     for prbIdx = 1:size(nPRB_list, 2)
%         [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(seIdx, nPRB_list(prbIdx), nSymbol);
%         if bgn == 1 && nCb == 1
%             selectPRB = [selectPRB nPRB_list(prbIdx)];
%         end
%     end
%     selectSet_bgn1_ncb1{seIdx} = selectPRB;
% end
% 
% 
% selectSet_bgn1_ncb2 = {};
% for seIdx = 1:43
%     selectPRB = [];
%     for prbIdx = 1:size(nPRB_list, 2)
%         [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(seIdx, nPRB_list(prbIdx), nSymbol);
%         if bgn == 1 && nCb == 2
%             selectPRB = [selectPRB nPRB_list(prbIdx)];
%         end
%     end
%     selectSet_bgn1_ncb2{seIdx} = selectPRB;
% end
% 
% selectSet_bgn1_ncb3 = {};
% for seIdx = 1:43
%     selectPRB = [];
%     for prbIdx = 1:size(nPRB_list, 2)
%         [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(seIdx, nPRB_list(prbIdx), nSymbol);
%         if bgn == 1 && nCb == 3
%             selectPRB = [selectPRB nPRB_list(prbIdx)];
%         end
%     end
%     selectSet_bgn1_ncb3{seIdx} = selectPRB;
% end
% 
% selectSet_bgn2_ncb1 = {};
% for seIdx = 1:43
%     selectPRB = [];
%     for prbIdx = 1:size(nPRB_list, 2)
%         [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(seIdx, nPRB_list(prbIdx), nSymbol);
%         if bgn == 2 && nCb == 1
%             selectPRB = [selectPRB nPRB_list(prbIdx)];
%         end
%     end
%     selectSet_bgn2_ncb1{seIdx} = selectPRB;
% end
% 
% 
% selectSet_bgn2_ncb2 = {};
% for seIdx = 1:43
%     selectPRB = [];
%     for prbIdx = 1:size(nPRB_list, 2)
%         [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(seIdx, nPRB_list(prbIdx), nSymbol);
%         if bgn == 2 && nCb == 2
%             selectPRB = [selectPRB nPRB_list(prbIdx)];
%         end
%     end
%     selectSet_bgn2_ncb2{seIdx} = selectPRB;
% end


nSymbol = 12;
%nPRB_list = [5, 10, 20, 50, 100];
nPRB_list = 1:256;

SpectralEfficiency_Table_size = 43;
PRB_List_size = size(nPRB_list, 2);
tbSizeMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
bgnMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
numCbMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
realCodeRate = zeros(SpectralEfficiency_Table_size, PRB_List_size);
k_dotMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);

for idxI = 1:SpectralEfficiency_Table_size
    for idxJ = 1:PRB_List_size
        [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(idxI, nPRB_list(idxJ), nSymbol);
        tbSizeMat(idxI, idxJ) = theTbSize;
        bgnMat(idxI, idxJ) = bgn;
        numCbMat(idxI, idxJ) = nCb;
        realCodeRate(idxI, idxJ) = effCodeRate;
        k_dotMat(idxI, idxJ) = k_dot;
    end
end
% 
% xxx = reshape(realCodeRate, 1, []); yyy = reshape(k_dotMat, 1, []);
% zzz1 = reshape((ttt == 2) .* (numCbMat == 1), 1, []);
% cftool(xxx, yyy, zzz1);
% 
% 
% %%
% % figure(); mesh(nPRB_list, SpectralEfficiency_Table, tbSizeMat);
% % figure(); mesh(nPRB_list, SpectralEfficiency_Table, bgnMat);
% % figure(); mesh(nPRB_list, SpectralEfficiency_Table, numCbMat);
% % figure(); mesh(nPRB_list, SpectralEfficiency_Table, realCodeRate);
% % figure(); mesh(nPRB_list, SpectralEfficiency_Table, k_dotMat);
% 
% % %%
% % nnnn = 12;
% % figure(1); plot(nPRB_list, numCbMat(nnnn,:), '*-'); grid on; hold on;
% % figure(2); plot(nPRB_list, nRE(nnnn, :) ./ numCbMat(nnnn,:), '*-'); grid on; hold on;
% % 
% % %%
% % ppp = 10;
% % figure(20); plot(SpectralEfficiency_Table, numCbMat(:, ppp), '*-'); grid on; hold on;
% % figure(21); plot(SpectralEfficiency_Table, nRE(:, ppp) ./ numCbMat(:, ppp), '*-'); grid on; hold on;

