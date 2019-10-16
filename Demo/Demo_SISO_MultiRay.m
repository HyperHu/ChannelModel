% This script simulate the scenario of SISO with Multi Ray channel.
% We exam the channel in frequency domain (i.e. sub carriar).
% Y[k,l] = H[k,l] * X[k,l] + ICI[k,l] + Noise[k,l]. 
% k is index of sub-carriar, l is index of symbol.

%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

simulationTimeMs = 100; %ms;
mu = 1;
numPRB = 50;
nFFT = 2 ^ ceil(log2(numPRB * 12));
nData = numPRB * 12;
[subFrameDuration, subCarriarSpace, numSymbolPerSubFrame, ...
    sampleRate, nCP_List_subFrame] = calCommonPar(mu, nFFT);

%% set parameter of ray
% An ray can be character by
% powerLoss_dB: 
% delay_ns:
% freqShift_Hz:
% initPhase_Rad:
% aod_deg\zod_deg:
% aoa_deg\zoa_deg:

rayList = genRandomRay(2, 0, (5/sampleRate)*1e9, 5*10, 2*pi);
%LosRayList = [-10, 4, 50, 0; rayList];


%% calculate H[k,l], it is ideal, means no noise, no ICI.
theChannel_ideal = calChannelH(rayList, 0, mu, nFFT, simulationTimeMs);
figure(1); mesh(mag2db(abs(theChannel_ideal)));
figure(2); mesh(angle(theChannel_ideal));

figure(3); hold on; grid on;
plot((-nFFT/2 : nFFT/2-1), mag2db(abs(theChannel_ideal(:,1))), '*');
figure(4); hold on; grid on;
plot((-nFFT/2 : nFFT/2-1), angle(theChannel_ideal(:,1)), 'o');

figure(5); hold on; grid on;
plot(mag2db(abs(theChannel_ideal(1,:))), '*');
figure(6); hold on; grid on;
plot(angle(theChannel_ideal(1,:)), 'o');

%%
% figure(); hold on; grid on;
% tttH = fft(theChannel_ideal(10,:));
% plot(abs(fftshift(tttH)),'*--');
% tttH = fft(theChannel_ideal(100,:));
% plot(abs(fftshift(tttH)),'o--');


%% calculate ICI[k,l]
% nSym = size(theChannel_ideal,2);
% [theICI, v, sig] = genRicianIci(nFFT, nSym, theRay(1,1), theRay(1,3)/subCarriarSpace);
% figure(1); mesh(abs(theICI));
% figure(2); mesh(angle(theICI));
% figure(3); grid on; histfit(reshape(abs(theICI), 1, []), 100, 'rician');
%%
%pdICI = fitdist(reshape(abs(theICI), [], 1), 'rician')
%tttH = fft2(theChannel_ideal(:,1:256) + theICI(:,1:256));
%mesh(abs(fftshift(tttH)));

% figure(); hold on; grid on;
% tttH = fft(theChannel_ideal(10,1:256) + theICI(10,1:256));
% plot(abs(fftshift(tttH)),'*--');
% tttH = fft(theChannel_ideal(100,1:256) + theICI(100,1:256));
% plot(abs(fftshift(tttH)),'o--');

%%
%pdH = fitdist(reshape(real(theChannel_ideal), [], 1), 'normal');
% figure(1); hold on; grid on;
% histfit(reshape(real(theChannel_ideal), 1, []), 100, 'normal');
% figure(2); hold on; grid on;
% histfit(reshape(abs(theChannel_ideal), 1, []), 100, 'rayleigh');
%histfit(reshape(real(theChannel_ideal), 1, []), 100);
%histogram(reshape(angle(theChannel_ideal), 1, []), 100);

%%
