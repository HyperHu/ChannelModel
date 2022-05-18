function raterecovered = doRateRecoverLDPC(tbSize, targetRc, modMethod, numLay, rv, softBits)
%#codegen
info = nrDLSCHInfo(double(tbSize),targetRc);
raterecovered = double(nrRateRecoverLDPC(softBits, double(tbSize), targetRc, rv, modMethod, double(numLay), info.C));
end

