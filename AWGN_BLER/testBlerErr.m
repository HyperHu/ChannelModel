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
% clear all;
% 
% theBler = 0.001;
% nSample = 500;
% nTest = 100000;
% tmpV = rand(nSample, nTest);
% estBler = sum(tmpV < theBler, 1) ./ nSample;
% mean(estBler)
% histogram(estBler);

%%
% clear all;
% 
% snrdB_List = -15:0.01:30;
% 
% M = 4;
% baseOffset = -pow2db(sum(pow2(2:2:M)));
% itemOffset = 3 * 2 * (1:(M/2))';
% itemSinr = snrdB_List + baseOffset + itemOffset;
% itemNoisePower = db2pow(-(itemSinr));
% totalNoisePow = mean(itemNoisePower, 1);
% effSnrdB_List = -pow2db(totalNoisePow);
% figure(1); hold on; grid on;
% plot(snrdB_List, effSnrdB_List);

%%
clear all;
BB = -1/(2*(8.63^2)); C = 4;
snrdB_List = -20:0.01:30; snrLin = db2mag(snrdB_List);
tmpY = exp(C*(BB*(snrLin .^ 2) + log(snrLin)));
%tmpY = tmpY ./ sum(tmpY);
figure(1); hold on; grid on; plot(snrLin, (0.9821/max(tmpY))*tmpY);
