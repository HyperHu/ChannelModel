%%
% clear all;
% N = 20000;
% 
% blerEst = (0.1 ^ (1/100)) .^ (200:399);
% 
% estErr = sqrt(blerEst .* (1- blerEst) / (N - 1));
% 
% figure(1); hold on; grid on;
% plot(blerEst, estErr);
% 
% figure(2); hold on; grid on;
% plot(blerEst, 3*estErr ./ blerEst);

%%
clear all;

theBler = 0.001;
nSample = 500;
nTest = 100000;
tmpV = rand(nSample, nTest);
estBler = sum(tmpV < theBler, 1) ./ nSample;
mean(estBler)
histogram(estBler);