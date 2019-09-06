
%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

pList = 0:0.005:0.5;
nList = 1:20;
resultGain = zeros(size(pList,2), size(nList,2));
for idxP = 1:size(pList,2)
    for idxN = 1:size(nList,2)
        resultGain(idxP, idxN) = calCombineGain(nList(idxN), pList(idxP)*pi);
    end
end

figure(); mesh(nList, pList, resultGain)

%%
function gain = calCombineGain(N, phiDiff)
    rawSNR_dB = 0;
    SampleNum = 50000;
    tmpSig = ones(SampleNum, 1) * exp(1i * phiDiff * (1:N));
    tmpNoise = (randn(SampleNum, N) + 1i*randn(SampleNum, N));
    tmpNoise = tmpNoise .* db2mag(-(rawSNR_dB+3));
    realSig = mean(tmpSig, 2);
    rcvSig = mean(tmpSig + tmpNoise, 2);
    rcvNoisePow = mean(abs(rcvSig - realSig) .^ 2);
    realSigPow = mean(abs(realSig) .^ 2);
    gain = max(pow2db(realSigPow / rcvNoisePow) - rawSNR_dB, -20);
end
