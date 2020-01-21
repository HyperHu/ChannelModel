%%
clear all;
load("TablesIn3GPP.mat");

nSymbol = 12;
nPRB_list = 1:256;

SpectralEfficiency_Table_size = size(TargetCodeRate_Table, 2);
PRB_List_size = size(nPRB_list, 2);
tbSizeMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
bgnMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
numCbMat = zeros(SpectralEfficiency_Table_size, PRB_List_size);
realCodeRate = zeros(SpectralEfficiency_Table_size, PRB_List_size);
diffCodeRate = zeros(SpectralEfficiency_Table_size, PRB_List_size);

for idxI = 1:SpectralEfficiency_Table_size
    for idxJ = 1:PRB_List_size
        pdsch = struct();
        pdsch.NLayers = 1;
        pdsch.TargetCodeRate = TargetCodeRate_Table(idxI) / 1024;
        pdsch.PRBSet = 0:nPRB_list(idxJ) - 1;
        pdsch.Modulation = ModulationOrder_Table{idxI};
        pdsch.BitsPerSymbol = BitsPerSymbol_Table(idxI);
        pdsch.nPrb = nPRB_list(idxJ);
        pdsch.nSymbol = nSymbol;
        tbSizeMat(idxI, idxJ) = hPDSCHTBS(pdsch, 12*pdsch.nSymbol);
        
        tmpInfo = nrDLSCHInfo(tbSizeMat(idxI, idxJ), pdsch.TargetCodeRate);
        bgnMat(idxI, idxJ) = tmpInfo.BGN;
        numCbMat(idxI, idxJ) = tmpInfo.C;
        realCodeRate(idxI, idxJ) =...
            (tbSizeMat(idxI, idxJ) + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb))...
            / (12 * pdsch.nSymbol * pdsch.nPrb * pdsch.BitsPerSymbol * pdsch.NLayers);
        diffCodeRate(idxI, idxJ) = (realCodeRate(idxI, idxJ) - pdsch.TargetCodeRate) / pdsch.TargetCodeRate;
    end
end

figure(); mesh(nPRB_list, SpectralEfficiency_Table, tbSizeMat);
figure(); mesh(nPRB_list, SpectralEfficiency_Table, bgnMat);
figure(); mesh(nPRB_list, SpectralEfficiency_Table, numCbMat);
figure(); mesh(nPRB_list, SpectralEfficiency_Table, realCodeRate);
figure(); mesh(nPRB_list, SpectralEfficiency_Table, diffCodeRate);