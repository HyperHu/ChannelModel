% This script show the distribution of time domain complex value (sample).
% The Standard Deviation per RE is sigmaRe, with modulateOrder modulation.
% Then, the sample followed a complex gaussion distribution.
% Further, magnitude of sample followed rayleigh distribution. 
% And, power of sample followed Chi-squared distribution with k=2 freedom.

%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

modulateOrder = 2;
sigmaRe = 1;
nSymbol = 14 * 1000;
nRE = 12 * 100;
nFFT = 2 ^ ceil(log2(nRE));

%% random data and do statistic
[reMat,~] = genRandomREValue(nRE, nSymbol, modulateOrder, sigmaRe);
timeSig = FreqToTime(reMat, 1);
figure(20); hold on; grid on;
plot(reshape(real(reMat), 1, []), reshape(imag(reMat), 1, []), '*')

%%
muReRealEst = mean(real(reMat), 'all');
muReImagEst = mean(imag(reMat), 'all');
muReEst = mean(reMat, 'all');
sigmaReRealEst = std(real(reMat), 0, 'all');
sigmaReImagEst = std(imag(reMat), 0, 'all');
sigmaReEst = std(reMat, 0, 'all'); % use 0 since based on samples

muSampleRealEst = mean(real(timeSig), 'all');
muSampleImagEst = mean(imag(timeSig), 'all');
muSampleEst = mean(timeSig, 'all');
sigmaSampleRealEst = std(real(timeSig), 0, 'all');
sigmaSampleImagEst = std(imag(timeSig), 0, 'all');
sigmaSampleEst = std(timeSig, 0, 'all');

% Chi-squared distribution is a special case of gamma distribution.
pdSamplePow = fitdist(reshape(abs(timeSig) .^ 2, [], 1), 'gamma');
meanPower = mean(pdSamplePow);
maxPower_9997 = icdf(pdSamplePow, 0.9997); % 99.97%
maxPower_Cal = icdf(pdSamplePow, 1 - 1/size(timeSig,2)); % 99.97%
maxPower_sample = max(reshape(abs(timeSig) .^ 2, [], 1));

%%% display and plot
disp("=================== RE info ===================================");
fprintf('The statistics of RE is [%.4f; %.4f]\n', muReEst, sigmaReEst);
fprintf('RE real part is [%.4f; %.4f]\n', muReRealEst, sigmaReRealEst);
fprintf('RE imag part is [%.4f; %.4f]\n', muReImagEst, sigmaReImagEst);

disp("=================== Sample info ===================================");
fprintf('The statistics of sample is [%.4f; %.4f]\n', muSampleEst, sigmaSampleEst);
fprintf('RE real part is [%.4f; %.4f]\n', muSampleRealEst, sigmaSampleRealEst);
fprintf('RE imag part is [%.4f; %.4f]\n', muSampleImagEst, sigmaSampleImagEst);
fprintf('[%.4f, (%.4f, %.4f)] = %.4f\n', sigmaSampleEst/sigmaReEst,...
        sigmaSampleRealEst/sigmaReRealEst, sigmaSampleImagEst/sigmaReImagEst,...
        sqrt(nRE/nFFT));
fprintf('The mean Power is %.4f, the max power is %.4f, %.4f\n',...
        meanPower, maxPower_sample, maxPower_Cal);
fprintf('The PAPR is %.4f dB, 99.97%% will not exceed %.4f\n',...
        pow2db(maxPower_sample/meanPower), maxPower_9997);
%%
figure(1); hold on; grid on;
histogram(reshape(real(reMat), 1, []), 100);
histogram(reshape(imag(reMat), 1, []), 100);
figure(2); hold on; grid on;
histogram(reshape(abs(reMat), 1, []), 100);

figure(3); hold on; grid on;
histfit(reshape(real(timeSig), 1, []), 100);
histfit(reshape(imag(timeSig), 1, []), 100);
figure(4); hold on; grid on;
timeSig(1) = 12;
histfit(reshape(abs(timeSig), 1, []), 500, 'rayleigh');
%histogram(reshape(abs(timeSig), 1, []), (0:0.05:5));

%figure(5); hold on; grid on;
%histfit(reshape(abs(timeSig) .^ 2, 1, []), 100, 'gamma');


