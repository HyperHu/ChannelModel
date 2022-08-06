function dlschLLRs = doLlrDecoding(nid, rnti, modMethod, estLaySym, noisePwr)
%#codegen

assert(size(estLaySym,1) <= 4);
newSym = estLaySym.';   % newSym is nRE, NLayer.
if numel(noisePwr) == 1
    tmpVal = nrPDSCHDecode(newSym, modMethod, double(nid), double(rnti), noisePwr);
    dlschLLRs = tmpVal{1};
else
    assert(size(estLaySym,1) == size(noisePwr,1));
    nSymbol = floor(size(estLaySym,2) / 12 / size(noisePwr,2));
    
    if modMethod == "QPSK"
        theQm = 2;
    elseif modMethod == "16QAM"
        theQm = 4;
    elseif modMethod == "64QAM"
        theQm = 6;
    elseif modMethod == "256QAM"
        theQm = 8;
    end
    
    allLlr = zeros(size(newSym,1), theQm*size(newSym, 2));
    for prbIdx = 1:size(noisePwr,2)
        theREIdx = (prbIdx-1)*12 +12*size(noisePwr,2)*(0:nSymbol-1) + (1:12)';
        theREIdx = theREIdx(:);
        for layIdx = 1:size(noisePwr,1)
            tmpSym = newSym(theREIdx, layIdx);
            tmpLlr = nrSymbolDemodulate(tmpSym,modMethod, noisePwr(layIdx, prbIdx));
            allLlr(theREIdx, (layIdx-1)*theQm + (1:theQm)) = reshape(tmpLlr, theQm, []).';
        end
    end

    dlschLLRs = reshape(allLlr.', [], 1);

    opts.MappingType = 'signed'; opts.OutputDataType = 'double';
    c = nrPDSCHPRBS(nid,rnti,0,length(dlschLLRs),opts);
    dlschLLRs = dlschLLRs .* c;
end

end

