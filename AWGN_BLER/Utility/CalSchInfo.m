function [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(seIdx, nPrb, nSymbol)
    load("TablesIn3GPP.mat",...
         'TargetCodeRate_Table', 'BitsPerSymbol_Table', 'ModulationOrder_Table');
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
