%%  
clear all;
load('..\MyCalculation_New.mat');

%testSamples = miTable_BPSK; theMaxV = 1; theLen = 350;
testSamples = miTable_QPSK; theMaxV = 2; theLen = 350;
%testSamples = miTable_16QAM; theMaxV = 4; theLen = 350;
%testSamples = miTable_64QAM; theMaxV = 6; theLen = 376;
%testSamples = miTable_256QAM; theMaxV = 8; theLen = 400;

%snrTable = snrTable - min(snrTable);

figure(1); hold on; grid on;
plot(snrTable, testSamples, '.');

plot(snrTable, min(theMaxV, log2(1+db2pow(snrTable))), '--'); % Shannon

x1 = snrTable(1:theLen); y1 = testSamples(1:theLen);

% % Logistic
% S_function=inline('alpha(1)./(1+exp(alpha(2) - (x1.*alpha(3))))','alpha','x1');
% alpha0=[theMaxV 4 0.5]; alpha = nlinfit(x1,y1,S_function,alpha0);
% figure(1); plot(snrTable, min(S_function(alpha, snrTable), theMaxV));
% figure(2); hold on; grid on; plot(snrTable, min(S_function(alpha, snrTable), theMaxV) - testSamples);

% % Gompertz
% S_function=inline('alpha(1) .* exp(-exp(alpha(2) - x1.*alpha(3)))','alpha','x1');
% alpha0=[7 1.0 0.1]; alpha = nlinfit(x1,y1,S_function,alpha0);
% plot(snrTable, S_function(alpha, snrTable));

% %Weibull
% S_function=inline('alpha(1) - (alpha(2) .* exp(-alpha(3) .* (x1 .^ alpha(4))))','alpha','x1');
% alpha0=[6 6.0 0 7]; alpha = nlinfit(x1,y1,S_function,alpha0);
% plot(snrTable, S_function(alpha, snrTable));

% Richards ***
S_function=inline('alpha(1) ./ ((1 + exp(alpha(2) - alpha(3) * x1)) .^ alpha(4))','alpha','x1');
alpha0=[theMaxV 4.0 0.1 0.5]; alpha = nlinfit(x1,y1,S_function,alpha0);
figure(1); plot(snrTable, min(S_function(alpha, snrTable), theMaxV));
figure(2); hold on; grid on; plot(snrTable, (min(S_function(alpha, snrTable), theMaxV) - testSamples) ./ testSamples);


% % Morgan-Mercer Flodin
% S_function=inline('(alpha(2)*alpha(3) + alpha(1) * (x1 .^ alpha(4))) ./ (alpha(3) + (x1 .^ alpha(4)))','alpha','x1');
% alpha0=[6 .0 100 3]; alpha = nlinfit(x1,y1,S_function,alpha0);
% plot(snrTable, S_function(alpha, snrTable));

% % Hill
% S_function=inline('alpha(1) + (alpha(2) * (x1 .^ alpha(4))) ./ (alpha(3) ^ alpha(4) + x1 .^ alpha(4))','alpha','x1');
% alpha0=[0 8.0 4 2]; alpha = nlinfit(x1,y1,S_function,alpha0);
% plot(snrTable, S_function(alpha, snrTable));


