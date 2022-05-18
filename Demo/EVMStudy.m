%%
clear all;
snr_dB = 0;
sampleNum = 1000*500;
randomNoise = randn(1,sampleNum) + 1j*randn(1,sampleNum);
randomNoise = (randomNoise / sqrt(2)) / db2mag(snr_dB);

figure(1); hold on; grid on; axis equal;
plot(1 + real(randomNoise), imag(randomNoise), '.');
plot([0, 1], [0, 0], 'r'); plot(1, 0, 'r*');

magniErr = abs(1+randomNoise) - 1;
% magniErr = mag2db(abs(1+randomNoise) / 1);
phaseErr = angle(1+randomNoise);
figure(2);
subplot(2,1,1); histfit(reshape(magniErr, 1, []), 100); hold on; grid on;
subplot(2,1,2); histfit(reshape(phaseErr, 1, []), 100); hold on; grid on;