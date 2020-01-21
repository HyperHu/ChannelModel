function [theTbBler, theCbBler] = calBler(mcsIdx, snrdB, nPrb, nSymbol, nSample)
    load("TablesIn3GPP.mat", "TargetCodeRate_Table", "ModulationOrder_Table", "BitsPerSymbol_Table");

    pdsch = struct();
    pdsch.nPrb = nPrb;
    pdsch.nSymbol = nSymbol;
    pdsch.NLayers = 1;
    pdsch.TargetCodeRate = TargetCodeRate_Table(mcsIdx) / 1024;
    pdsch.PRBSet = 0:nPrb - 1;
    pdsch.Modulation = ModulationOrder_Table{mcsIdx};
    pdsch.BitsPerSymbol = BitsPerSymbol_Table(mcsIdx);

    trBlkLen = hPDSCHTBS(pdsch, 12*pdsch.nSymbol);
    outlen = 12 * pdsch.nSymbol * pdsch.nPrb * pdsch.BitsPerSymbol * pdsch.NLayers;
    rv = 0;
    encDL = nrDLSCH('TargetCodeRate', pdsch.TargetCodeRate);
    decDL = myNrDLSCHDec('TargetCodeRate', pdsch.TargetCodeRate, 'TransportBlockLength', trBlkLen);
    %decDL = nrDLSCHDecoder('TargetCodeRate', pdsch.TargetCodeRate, 'TransportBlockLength', trBlkLen);

    totalErr = 0;
    totalCb = 0;
    totalErrCb = 0;
    for iii = 1:nSample
        encDL.reset();
        decDL.reset();
        setTransportBlock(encDL,randi([0 1],trBlkLen,1,'int8'));
        codedTrBlock = encDL(pdsch.Modulation, pdsch.NLayers, outlen, rv);
        txSoftBits = nrSymbolModulate(codedTrBlock, pdsch.Modulation);
        
        noiseBits = randn(size(txSoftBits)) + 1i * randn(size(txSoftBits));
        noiseBits = noiseBits .* db2mag(-(snrdB+3));
            
        rxSoftBits = nrSymbolDemodulate(txSoftBits + noiseBits, pdsch.Modulation, db2pow(-snrdB));
        [~, nacked, cbNacked] = decDL(rxSoftBits, pdsch.Modulation, pdsch.NLayers, rv);
        
        if nacked == true
            totalErr = totalErr + 1;
        end
        totalCb = totalCb + size(cbNacked,2);
        if (size(cbNacked,1) == 0)
            totalErrCb = totalErr;
        else
            totalErrCb = totalErrCb + sum(cbNacked);
        end
    end
    theTbBler = totalErr / nSample;
    theCbBler = totalErrCb / totalCb;
end
