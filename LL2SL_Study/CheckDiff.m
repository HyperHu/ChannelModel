%%
clear all;

morseRawData = load('InMoRSE.txt');
morseSinr = morseRawData(:,1);
morseMi_QPSK = morseRawData(:,2);
morseMi_16QAM = morseRawData(:,3);
morseMi_64QAM = morseRawData(:,4);
morseMi_256QAM = morseRawData(:,5);

load("MyCalculation.mat");

figure(1); hold on; grid on;
plot(snrTable, miTable_QPSK); plot(morseSinr, morseMi_QPSK, '--');
plot(snrTable, miTable_16QAM); plot(morseSinr, morseMi_16QAM, '--');
plot(snrTable, miTable_64QAM); plot(morseSinr, morseMi_64QAM, '--');
plot(snrTable, miTable_256QAM); plot(morseSinr, morseMi_256QAM, '--');

figure(2); hold on; grid on;
plot(snrTable, log10(miTable_QPSK)); plot(morseSinr, log10(morseMi_QPSK), '--');
plot(snrTable, log10(miTable_16QAM)); plot(morseSinr, log10(morseMi_16QAM), '--');
plot(snrTable, log10(miTable_64QAM)); plot(morseSinr, log10(morseMi_64QAM), '--');
plot(snrTable, log10(miTable_256QAM)); plot(morseSinr, log10(morseMi_256QAM), '--');

%%
clear all;
load("MyCalculation_New.mat");

fitVal = zeros(size(snrTable));
for idx = 1:size(snrTable,2)
    snrVal = db2pow(snrTable(idx));
    if snrVal < 1.47
        fitVal(idx) = -0.229*(snrVal^2) + 1.14*snrVal;
    elseif snrVal < 3.3
        fitVal(idx) = -0.112*(snrVal^2) + 0.963*snrVal;
    elseif snrVal < 5.2
        fitVal(idx) = 4 - exp(-0.152*snrVal + 1.21);
    else
        fitVal(idx) = 4 - exp(-0.12*snrVal + 1.04);
    end
end

figure(3); hold on; grid on;
plot(snrTable, miTable_16QAM);
plot(snrTable, fitVal);

figure(4); hold on; grid on;
plot(snrTable, pow2db(miTable_16QAM));
plot(snrTable, pow2db(fitVal));

figure(5); hold on; grid on;
plot(snrTable, miTable_16QAM - fitVal);
figure(6); hold on; grid on;
plot(snrTable, pow2db(miTable_16QAM) - pow2db(fitVal));

%%
clear all;
load("MyCalculation_New.mat");
figure(7); hold on; grid on;
plot(snrTable, miTable_16QAM);
plot(snrTable(1:270), -0.229*(db2pow(snrTable(1:270)) .^ 2) + 1.14 * db2pow(snrTable(1:270)), '*');
plot(snrTable(260:280), -0.112*(db2pow(snrTable(260:280)) .^ 2) + 0.963 * db2pow(snrTable(260:280)), 'o');
plot(snrTable(275:295), 4 - exp(-0.152*db2pow(snrTable(275:295)) + 1.21), '*');
plot(snrTable(280:end), 4 - exp(-0.12*db2pow(snrTable(280:end)) + 1.04), 'o');

%%
clear all;
plotRange = 1:40;
load("n30_p40_10m.mat");
figure(5); hold on; grid on; plot(snrTable(plotRange), pow2db(log2(1+db2pow(snrTable(plotRange)))), '--');
figure(5); hold on; grid on; plot(snrTable(plotRange), pow2db(abs(miTable_BPSK(plotRange))));
figure(5); hold on; grid on; plot(snrTable(plotRange), pow2db(abs(miTable_QPSK(plotRange))));
figure(5); hold on; grid on; plot(snrTable(plotRange), pow2db(abs(miTable_16QAM(plotRange))));
figure(5); hold on; grid on; plot(snrTable(plotRange), pow2db(abs(miTable_64QAM(plotRange))));
load("n30_p40_1m.mat");
figure(5); hold on; grid on; plot(snrTable(plotRange), pow2db(abs(miTable_256QAM(plotRange))));


%%
clear all;
load("MyCalculation_New.mat");
figure(4); hold on; grid on; plot(snrTable, (abs(miTable_BPSK)));
figure(4); hold on; grid on; plot(snrTable, (abs(miTable_QPSK)));
figure(4); hold on; grid on; plot(snrTable, (abs(miTable_16QAM)));
figure(4); hold on; grid on; plot(snrTable, (abs(miTable_64QAM)));
figure(4); hold on; grid on; plot(snrTable, (abs(miTable_256QAM)));

load("n30_p40_10m.mat");
figure(5); hold on; grid on; plot(snrTable, (abs(miTable_BPSK)));
figure(5); hold on; grid on; plot(snrTable, (abs(miTable_QPSK)));
figure(5); hold on; grid on; plot(snrTable, (abs(miTable_16QAM)));
figure(5); hold on; grid on; plot(snrTable, (abs(miTable_64QAM)));

load("n50_n30_100m.mat");
figure(1); hold on; grid on; plot(snrTable, (abs(miTable_BPSK)));
figure(2); hold on; grid on; plot(snrTable, (abs(miTable_QPSK)));
figure(3); hold on; grid on; plot(snrTable, (abs(miTable_16QAM)));

% plot(snrTable(1:250), pow2db(miTable_QPSK(1:250)), '*'); hold on; grid on;
% plot(snrTable(1:270), miTable_16QAM(1:270), '*'); hold on; grid on;

% % BPSK
% cftool(snrTable(10:220), pow2db(miTable_BPSK(10:220)));

%%
miShannon_dB = 0.9925*SNR_dB + 1.396; % SNR_dB <= -10
miBPSK_dB = 0.9851*SNR_dB + 1.207; % SNR_dB <= -10
miQPSK_dB = 0.9927*SNR_dB + 1.401; % SNR_dB <= -10
mi16QAM_dB = 0.9964*SNR_dB + 0.5325; % SNR_dB <= -10
mi64QAM_dB = 0.9964*SNR_dB + 0.3163; % SNR_dB <= -10
mi256QAM_dB = 0.9963*SNR_dB + 0.2641; % SNR_dB <= -10

miShannon_dB = 0.9999*SNR_dB + 1.588; % SNR_dB <= -30
miBPSK_dB = 1.002*SNR_dB + 1.692; % SNR_dB <= -30
miQPSK_dB = 0.9979*SNR_dB + 1.509; % SNR_dB <= -30
mi16QAM_dB = 0.9991*SNR_dB + 0.5885; % SNR_dB <= -30

%%
clear all;
snrSamples = []; miBPSKSamples = []; miQPSKSamples = []; mi16QAMSamples = []; mi64QAMSamples = []; mi256QAMSamples = [];
load("n50_n30_100m.mat");
snrSamples = [snrSamples snrTable];
miBPSKSamples = [miBPSKSamples miTable_BPSK];
miQPSKSamples = [miQPSKSamples miTable_QPSK];
mi16QAMSamples = [mi16QAMSamples miTable_16QAM];

load("n30_p40_10m.mat");
snrSamples = [snrSamples snrTable];
miBPSKSamples = [miBPSKSamples miTable_BPSK];
miQPSKSamples = [miQPSKSamples miTable_QPSK];
mi16QAMSamples = [mi16QAMSamples miTable_16QAM];
mi64QAMSamples = [mi64QAMSamples miTable_64QAM];

load("n30_p40_1m.mat");
mi256QAMSamples = [mi256QAMSamples miTable_256QAM];
clear("miTable_*", "snrTable");

cftool(snrSamples(1:62), pow2db(miBPSKSamples(1:62)));  % y = 0.9938x + 1.368
cftool(snrSamples(1:62), pow2db(miQPSKSamples(1:62)));  % y = 0.9966x + 1.469
cftool(snrSamples(1:62), pow2db(mi16QAMSamples(1:62)));  % y = 0.9984x + 0.5671

%%
clear all;
load("MutualInformation.mat");
load("n30_p40_10m.mat");
%load("n30_p40_1m.mat");
%load("n50_n30_100m.mat");
%load("MyCalculation_New.mat");

figure(1); hold on; grid on;
plot(snrTable, log10(miTable_BPSK)); plot(MutualInformation(:,1), log10(MutualInformation(:,2)), '--');
figure(2); hold on; grid on;
plot(snrTable, log10(miTable_QPSK)); plot(MutualInformation(:,1), log10(MutualInformation(:,3)), '--');
figure(3); hold on; grid on;
plot(snrTable, log10(miTable_16QAM)); plot(MutualInformation(:,1), log10(MutualInformation(:,4)), '--');
figure(4); hold on; grid on;
plot(snrTable, log10(miTable_64QAM)); plot(MutualInformation(:,1), log10(MutualInformation(:,5)), '--');
figure(5); hold on; grid on;
plot(snrTable, log10(miTable_256QAM)); plot(MutualInformation(:,1), log10(MutualInformation(:,6)), '--');


