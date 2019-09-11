
%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

modulateOrder = 8;
nFFT = 2048;
nSymbol = 14 * 100;

%%
kdsList = 0.01:0.05:0.5;
resultS = zeros(size(kdsList));
resultSigma = zeros(size(kdsList));
for idxI = 1:size(kdsList,2)
    idxI
    [tmpS, tmpSigma] = calRicianPara(nFFT, nSymbol, kdsList(idxI), modulateOrder);
    resultS(idxI) = tmpS;
    resultSigma(idxI) = tmpSigma * sqrt(2);
end

figure(1); hold on; grid on;
plot(kdsList, resultS, '*--');
plot(kdsList, resultSigma, 'o--');
%plot(kdsList, sqrt(resultS .^ 2 + 2*(resultSigma .^ 2)));


%% random data and do statistic
kds = 0.1;
sumIci = zeros(nFFT, nSymbol);
[reMatPilot,~] = genRandomREValue(nFFT, nSymbol, 2, 1);

for idxD = 1:24
    [reMatData,~] = genRandomREValue(nFFT, nSymbol, modulateOrder, 1);
    tmpI = reMatData ./ reMatPilot;
    tmpP = calPhaseFactor(nFFT, zeros(1,nSymbol), 0, 0, kds, idxD);
    tmpIci = calIciFactor(idxD, kds, nFFT);
    sumIci = sumIci + tmpI .* tmpP .* tmpIci;
    [reMatData,~] = genRandomREValue(nFFT, nSymbol, modulateOrder, 1);
    tmpI = reMatData ./ reMatPilot;
    tmpP = calPhaseFactor(nFFT, zeros(1,nSymbol), 0, 0, kds, -idxD);
    tmpIci = calIciFactor(-idxD, kds, nFFT);
    sumIci = sumIci + tmpI .* tmpP .* tmpIci;
end

figure(1); hold on; grid on;
histogram(reshape(real(sumIci), 1, []), 100);
histogram(reshape(imag(sumIci), 1, []), 100);
figure(2); hold on; grid on;
histfit(reshape(abs(sumIci), 1, []), 100, 'rician');

function [iciS, iciSig] = calRicianPara(nFFT, nSymbol, kds, modulateOrder)
sumIci = zeros(nFFT, nSymbol);
[reMatPilot,~] = genRandomREValue(nFFT, nSymbol, 2, 1);
for idxD = 1:36
    [reMatData,~] = genRandomREValue(nFFT, nSymbol, modulateOrder, 1);
    tmpI = reMatData ./ reMatPilot;
    tmpP = calPhaseFactor(nFFT, zeros(1,nSymbol), 0, 10, kds, idxD);
    tmpIci = calIciFactor(idxD, kds, nFFT);
    sumIci = sumIci + tmpI .* tmpP .* tmpIci;
    [reMatData,~] = genRandomREValue(nFFT, nSymbol, modulateOrder, 1);
    tmpI = reMatData ./ reMatPilot;
    tmpP = calPhaseFactor(nFFT, zeros(1,nSymbol), 0, 10, kds, -idxD);
    tmpIci = calIciFactor(-idxD, kds, nFFT);
    sumIci = sumIci + tmpI .* tmpP .* tmpIci;
end
%sumIci = sumIci ./ abs(calIciFactor(0, kds, nFFT));
pdICI = fitdist(reshape(abs(sumIci), [], 1), 'rician');
iciS = pdICI.s;
iciSig = pdICI.sigma;
end
