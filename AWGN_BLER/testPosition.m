%%
clear all;
load("TablesIn3GPP.mat", "TargetCodeRate_Table", "ModulationOrder_Table", "BitsPerSymbol_Table");
nPrb = 1; nSymbol = 8; mcsIdx = 10;

pdsch = struct();
pdsch.PRBSet = 0:(nPrb-1); pdsch.nPrb = nPrb; pdsch.nSymbol = nSymbol; pdsch.NLayers = 1;
pdsch.TargetCodeRate = TargetCodeRate_Table(mcsIdx) / 1024;
pdsch.Modulation = ModulationOrder_Table{mcsIdx};
pdsch.BitsPerSymbol = BitsPerSymbol_Table(mcsIdx);

trBlkLen = hPDSCHTBS(pdsch, 12*pdsch.nSymbol);
outlen = 12 * pdsch.nSymbol * pdsch.nPrb * pdsch.BitsPerSymbol * pdsch.NLayers;
    
encDL = nrDLSCH('TargetCodeRate', pdsch.TargetCodeRate);
decDL = nrDLSCHDecoder('TargetCodeRate', pdsch.TargetCodeRate, 'TransportBlockLength', trBlkLen);

dataInput = randi([0 1],trBlkLen,1,'int8');
setTransportBlock(encDL,dataInput);
codedTrBlock = encDL(pdsch.Modulation, pdsch.NLayers, outlen, 0);