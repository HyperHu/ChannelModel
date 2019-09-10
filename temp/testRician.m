%%
clear all;

nSample = 10000 * 100;
rawSNR_dB = -10;

%%
tmpNoise = (randn(nSample, 1) + 1i*randn(nSample, 1));
tmpNoise = tmpNoise .* db2mag(-(rawSNR_dB+3));
tmpMain = exp(1i * rand(nSample, 1) * 2*pi);
tmpAll = tmpMain + tmpNoise;
figure(); hold on; grid on;
histfit(reshape(abs(tmpAll), 1, []), 100, 'rician');