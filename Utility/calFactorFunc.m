function factorList = calFactorFunc(xList, nFFT)
%CALFACTORFUNC Summary of this function goes here
%   Detailed explanation goes here

for idx = 1:size(xList,2)
    if xList(idx) == 0
        xList(idx) = 0.00001;
    end
end
tmpP = exp(1i * pi * xList * ((nFFT - 1) / nFFT));
tmpA = sin(pi * xList) ./ sin(pi * xList / nFFT) ./ nFFT;
factorList = tmpP .* tmpA;

end

