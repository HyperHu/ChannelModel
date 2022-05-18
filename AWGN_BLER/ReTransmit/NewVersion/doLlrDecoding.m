function dlschLLRs = doLlrDecoding(nid, rnti, modMethod, estLaySym)
%#codegen

assert(size(estLaySym,1) <= 4);
newSym = estLaySym.';
tmpVal = nrPDSCHDecode(newSym, modMethod, double(nid), double(rnti));
dlschLLRs = tmpVal{1};
end

