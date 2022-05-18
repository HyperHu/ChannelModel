function codeword = genCodeWordData(modMethod, numLay, encodedBits, rv, outCWLen)
%#codegen

assert(numLay <= 4);
codeword = nrRateMatchLDPC(encodedBits, double(outCWLen), rv, modMethod, double(numLay));
end

