%%
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

%%
nRE = 12 * 50;
nSymbol = 14 * 100;
modulateOrder = 2;
[reMat,~] = genRandomREValue(nRE, nSymbol, modulateOrder);
timeSig = FreqToTime(reMat, 1);

figure(1); hold on; grid on;
histogram(reshape(abs(reMat), 1, []), (0:0.01:3));
figure(2); hold on; grid on;
histogram(reshape(abs(timeSig), 1, []), (0:0.01:3));

figure(3); hold on; grid on;
histfit(reshape(real(timeSig), 1, []), 100);
figure(4); hold on; grid on;
histfit(reshape(imag(timeSig), 1, []), 100);
figure(5); hold on; grid on;
histfit(reshape(abs(timeSig), 1, []), 100, 'rayleigh');
%pd = fitdist(reshape(abs(timeSig), [], 1), 'rayleigh')
