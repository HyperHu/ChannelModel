%%
clear all;

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
theRay = genRandomRay(1, 0, (4/sampleRate)*1e9, 1, 0);
%theRay = [0, (10/sampleRate)*1e9, 500, 0];
theChannel0 = calChannelH(theRay, 0, mu, nData, simulationTimeMs);

%%
figure(1); mesh(mag2db(abs(fftshift(theChannel0, 1))));
figure(2); mesh(angle(fftshift(theChannel0, 1)));