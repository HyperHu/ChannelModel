%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

%%
N = 2;
diffPhase = pi*(-1:0.0005:1);
tmpSum = sum(exp(1i*((0:N-1)') * diffPhase), 1) / N;

% figure(1); hold on; grid on;
% plot(diffPhase, max((real(tmpSum)), -30), 'r--');
% plot(diffPhase, max((imag(tmpSum)), -30), 'g--');

%%
factorList = calFactorFunc(diffPhase/(2*pi/N), N);
figure(1); hold on; grid on;
% plot(diffPhase, max((real(factorList)), -30), 'r.-');
% plot(diffPhase, max((imag(factorList)), -30), 'g.-');
plot(diffPhase, max(mag2db(abs(factorList)), -20), 'r.-');
plot(ones(1,21)*pi/N, -20:0, '.');
plot(-ones(1,21)*pi/N, -20:0, '.');

%% main beam / kth side lobe
k = 1;
theRatio = mag2db(N / (1 / sin(pi*(2*k+1)/(2*N))));


%tmpN = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];
tmpN = 2:64;
tmpRatio = mag2db(tmpN ./ (1 ./ sin(pi*(2*k+1)./(2.*tmpN))));
figure(3); hold on; grid on;
plot(tmpN, tmpRatio, '*--');
