function estLaySym = throughBlockAwgnChannel(theLaySym, blockNoise)
%#codegen
assert(size(theLaySym,1) == size(blockNoise,1));
assert(mod(size(theLaySym,2), size(blockNoise,2)*12) == 0);

nSym = int32(size(theLaySym,2) / (size(blockNoise,2)*12));
theAmp = kron(ones(1, nSym), kron(sqrt(blockNoise ./ 2), ones(1,12)));
estLaySym = randn(size(theLaySym)) + 1i*randn(size(theLaySym));
estLaySym = estLaySym .* theAmp;
estLaySym = estLaySym + theLaySym;
%theAmpNorm = kron(ones(1, nSym), kron(sqrt(1 ./ (blockNoise + 1)), ones(1,12)));
%estLaySym = estLaySym .* theAmpNorm;
end

