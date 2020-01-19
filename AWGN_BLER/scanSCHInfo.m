%%
clear all;

nSymbol = 12;
ModulationOrder_Table = {'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' 'QPSK' ...
                         '16QAM' '16QAM' '16QAM' '16QAM' '16QAM' '16QAM' '16QAM' ...
                         '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' '64QAM' ...
                         '256QAM' '256QAM' '256QAM' '256QAM' '256QAM' '256QAM' '256QAM' '256QAM'};
TargetCodeRate_Table = [30 40 50 64 78 99 120 157 193 251 308 379 449 526 602 679 ...
                        340 378 434 490 553 616 658 ...
                        438 466 517 567 616 666 719 772 822 873 910 948 ...
                        682.5 711 754 797 841 885 916.5 948];
BitsPerSymbol_Table = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, ...
                       4, 4, 4, 4, 4, 4, 4, ...
                       6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, ...
                       8, 8, 8, 8, 8, 8, 8, 8];
nPRB_list = [1, 2, 4, 5, 8, 10, 16, 20, 32, 50, 64, 100, 128, 200, 256];

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
        diffCodeRate(idxI, idxJ) = pdsch.TargetCodeRate - realCodeRate(idxI, idxJ);
    end
end
