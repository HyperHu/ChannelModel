
%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

pList = 0:0.001:0.2;
nList = 1:32;

%%
% resultGain = zeros(size(pList,2), size(nList,2));
% for idxP = 1:size(pList,2)
%     for idxN = 1:size(nList,2)
%         resultGain(idxP, idxN) = simulateCombineGain(nList(idxN), pList(idxP)*pi);
%     end
% end
% figure(); mesh(nList, pList, max(-3, resultGain));

%%
resultGain_1 = zeros(size(pList,2), size(nList,2));
for idxN = 1:size(nList,2)
    resultGain_1(:, idxN) = calCombineGain(nList(idxN), pList*nList(idxN)/2)';
end
figure(); mesh(nList, pList, max(-3, resultGain_1));

%%
function gain = simulateCombineGain(N, phaseDiff)
    rawSNR_dB = 0;
    SampleNum = 10000;
    tmpSig = ones(SampleNum, 1) * exp(1i * phaseDiff * (1:N));
    tmpNoise = (randn(SampleNum, N) + 1i*randn(SampleNum, N));
    tmpNoise = tmpNoise .* db2mag(-(rawSNR_dB+3));
    realSig = mean(tmpSig, 2);
    rcvSig = mean(tmpSig + tmpNoise, 2);
    rcvNoisePow = mean(abs(rcvSig - realSig) .^ 2);
    realSigPow = mean(abs(realSig) .^ 2);
    gain = pow2db(realSigPow / rcvNoisePow) - rawSNR_dB;
end

function gain = calCombineGain(N, phaseDiff)
    sigLos = mag2db(abs(calFactorFunc(phaseDiff, N)));
    gain = pow2db(N) + sigLos;
    
    %gain = sigLos;
    %gain = pow2db(N);
end
