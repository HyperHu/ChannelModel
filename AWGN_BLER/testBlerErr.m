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

theBler = 0.5;
nSample = 1000*5;
nTest = 10000;
tmpV = rand(nSample, nTest);
estBler = sum(tmpV < theBler, 1) ./ nSample;
(max(estBler) - min(estBler))
histfit(estBler);

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
% clear all;
% BB = -1/1; C = 1;
% snrdB_List = -20:0.01:30; snrLin = db2mag(snrdB_List);
% tmpY = exp(C*(BB*(snrLin .^ 2) + log(snrLin)));
% %tmpY = tmpY ./ sum(tmpY);
% figure(1); hold on; grid on; plot(snrdB_List, tmpY);


%%
% clear all;
% snrdB_List = -15:0.01:-5;
% c_dot = -db2pow(-10.92 + pow2db(10/log(10)));
% tmpY = exp(c_dot ./ (10 .^ (snrdB_List / 10)) - snrdB_List); x0 = -10*log10(-10/(log(10)*c_dot));
% b = 4.5; tmpY = tmpY / max(tmpY); tmpY = tmpY .^ b; tmpY = 0.087 * tmpY;
% tmpC = -db2pow(x0 + pow2db(10/log(10)));
% figure(3); hold on; grid on;
% plot(snrdB_List, tmpY); plot(x0*ones(1,22), max(tmpY)*(0:21)/20, '--');
