% This script simulate the scenario of SISO with one Ray channel.
% We exam the channel in frequency domain (i.e. sub carriar).
% Y[k,l] = H[k,l] * X[k,l] + ICI[k,l] + Noise[k,l]. 
% k is index of sub-carriar, l is index of symbol.

%%
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

mu = 1;
numPRB = 100;
simulationTimeMs = 50; %ms;
subFrameDuration = 1 * 1e-3;    % 1ms
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
nFFT = 2 ^ ceil(log2(numPRB * 12));
nData = numPRB * 12;
sampleRate = nFFT * subCarriarSpace;

%%
%theRay = genRandomRay(1, 0, (4/sampleRate)*1e9, 1, 0);
theRay = [0, (11/sampleRate)*1e9, 12, 0];

theChannel_ideal = calChannelH(theRay, 0, mu, nData, simulationTimeMs);

%%
%pdH = fitdist(reshape(real(theChannel_ideal), [], 1), 'normal');
%histfit(reshape(real(theChannel_ideal), 1, []), 100);
histogram(reshape(angle(theChannel_ideal), 1, []), 100);
%%
%figure(1); mesh(mag2db(abs(fftshift(theChannel_ideal, 1))));
%figure(2); mesh(angle(fftshift(theChannel_ideal, 1)));