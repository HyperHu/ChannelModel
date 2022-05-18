function theTransBlock = genTransBlockData(modMethod, targetRc, numLay, numPrb, numRe)
%#codegen

assert(numLay <= 4);
tbSize = nrTBS(modMethod, double(numLay), double(numPrb), double(numRe), targetRc);
theTransBlock = int8(zeros(tbSize(1), 1));
end

