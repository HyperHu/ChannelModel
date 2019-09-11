% This script simulate the scenario of SISO with one Ray channel.
% We exam the channel in frequency domain (i.e. sub carriar).
% Y[k,l] = H[k,l] * X[k,l] + ICI[k,l] + Noise[k,l]. 
% k is index of sub-carriar, l is index of symbol.

%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

simulationTimeMs = 100; %ms;
mu = 1;
numPRB = 100;
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

%theRay = genRandomRay(1, 0, (4/sampleRate)*1e9, 1, 0);
theRay = [0, (10/sampleRate)*1e9, 1500, 0];

%% calculate H[k,l], it is ideal, means no noise, no ICI.
theChannel_ideal = calChannelH(theRay, 0, mu, nFFT, simulationTimeMs);
%figure(1); mesh(abs(theChannel_ideal));
%figure(2); mesh(angle(theChannel_ideal));

%% calculate ICI[k,l]
nSym = size(theChannel_ideal,2);
[theICI, v, sig] = genRicianIci(nFFT, nSym, theRay(1,1), theRay(1,3)/subCarriarSpace);
%figure(1); mesh(abs(theICI));
%figure(2); mesh(angle(theICI));
figure(3); grid on; histfit(reshape(abs(theICI), 1, []), 100, 'rician');
%%
%pdICI = fitdist(reshape(abs(theICI), [], 1), 'rician')


%%
%pdH = fitdist(reshape(real(theChannel_ideal), [], 1), 'normal');
%histfit(reshape(real(theChannel_ideal), 1, []), 100);
%histogram(reshape(angle(theChannel_ideal), 1, []), 100);

%%
