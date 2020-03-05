%%
clear all;
load("TablesIn3GPP.mat");

nSymbol = 12;
%nPRB_list = [5, 10, 20, 50, 100];
nPRB_list = 5:5:256;

SpectralEfficiency_Table_size = size(TargetCodeRate_Table, 2);
PRB_List_size = size(nPRB_list, 2);
tbSizeMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
bgnMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
numCbMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
realCodeRate = zeros(SpectralEfficiency_Table_size, PRB_List_size);
k_dotMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
ttt = zeros(SpectralEfficiency_Table_size, PRB_List_size);
for idxI = 1:SpectralEfficiency_Table_size
    for idxJ = 1:PRB_List_size
        [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(idxI, nPRB_list(idxJ), nSymbol);
        tbSizeMat(idxI, idxJ) = theTbSize;
        bgnMat(idxI, idxJ) = bgn;
        numCbMat(idxI, idxJ) = nCb;
        realCodeRate(idxI, idxJ) = effCodeRate;
        k_dotMat(idxI, idxJ) = k_dot;
        ttt(idxI, idxJ) = BitsPerSymbol_Table(idxI);
    end
end

xxx = reshape(realCodeRate, 1, []); yyy = reshape(k_dotMat, 1, []);
zzz1 = reshape((ttt == 2) .* (numCbMat == 1), 1, []);
cftool(xxx, yyy, zzz1);


%%
% figure(); mesh(nPRB_list, SpectralEfficiency_Table, tbSizeMat);
% figure(); mesh(nPRB_list, SpectralEfficiency_Table, bgnMat);
% figure(); mesh(nPRB_list, SpectralEfficiency_Table, numCbMat);
% figure(); mesh(nPRB_list, SpectralEfficiency_Table, realCodeRate);
% figure(); mesh(nPRB_list, SpectralEfficiency_Table, k_dotMat);

% %%
% nnnn = 12;
% figure(1); plot(nPRB_list, numCbMat(nnnn,:), '*-'); grid on; hold on;
% figure(2); plot(nPRB_list, nRE(nnnn, :) ./ numCbMat(nnnn,:), '*-'); grid on; hold on;
% 
% %%
% ppp = 10;
% figure(20); plot(SpectralEfficiency_Table, numCbMat(:, ppp), '*-'); grid on; hold on;
% figure(21); plot(SpectralEfficiency_Table, nRE(:, ppp) ./ numCbMat(:, ppp), '*-'); grid on; hold on;

function [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(seIdx, nPrb, nSymbol)
    load("TablesIn3GPP.mat", 'TargetCodeRate_Table', 'BitsPerSymbol_Table', 'ModulationOrder_Table');
    pdsch = struct(); pdsch.NLayers = 1;
    pdsch.PRBSet = 0:nPrb - 1; pdsch.nPrb = nPrb; pdsch.nSymbol = nSymbol;
    pdsch.TargetCodeRate = TargetCodeRate_Table(seIdx) / 1024;
    pdsch.Modulation = ModulationOrder_Table{seIdx};
    pdsch.BitsPerSymbol = BitsPerSymbol_Table(seIdx);
    
    theTbSize = hPDSCHTBS(pdsch, 12*pdsch.nSymbol);
    tmpInfo = nrDLSCHInfo(theTbSize, pdsch.TargetCodeRate);
    bgn = tmpInfo.BGN; nCb = tmpInfo.C;
    effCodeRate = theTbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb);
    effCodeRate = effCodeRate / (12 * nSymbol * nPrb * pdsch.BitsPerSymbol * pdsch.NLayers);
    k_dot = (theTbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb)) / nCb;
end
