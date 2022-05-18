function pdschSym = genLayersSymbol(nid, rnti, modMethod, numLay, codeword)
%#codegen
assert(numLay <= 4);
tmp = nrPDSCH(codeword, modMethod, double(numLay), double(nid), double(rnti));
pdschSym = tmp.';
end

