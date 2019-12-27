%%
clear all;

N = 8;
freqzLen = 512;
main_phi_deg = 2;
%%
k = 1;
alpha = 2 * (0.5*k) * sind(main_phi_deg);
wN = exp(1i * pi * alpha * (0 : N - 1));
wN = wN / norm(wN);

% [WN, tmpw] = freqz(wN, 1, 2*freqzLen, 'whole');
% figure(1);
% hold on; grid on;
% plot(tmpw/pi - 1, mag2db(fftshift(abs(WN))))
% ax = gca;
% ax.YLim = [-50 20];
% ax.XTick = -1:.25:1;
% legend('N');
% xlabel('Normalized Frequency (\times\pi rad/sample)')
% ylabel('Magnitude (dB)')

%%
mWeight = wN';
tmpPhi = 2 * (0.5*k) * sind(-90:0.1:90)';
sVector = exp(1i * pi * tmpPhi * (0 : N - 1));
mGain = max(mag2db(abs(sVector * mWeight)), -30);
figure(1); hold on; grid on;
plot(-90:0.1:90, mGain, '--');

k = 2;
alpha = 2 * (0.5*k) * sind(main_phi_deg);
wN = exp(1i * pi * alpha * (0 : N - 1));
wN = wN / norm(wN);
mWeight = wN';
tmpPhi = 2 * (0.5*k) * sind(-90:0.1:90)';
sVector = exp(1i * pi * tmpPhi * (0 : N - 1));
mGain = max(mag2db(abs(sVector * mWeight)), -30);
plot(-90:0.1:90, mGain);


beamDirct_deg = 0;
alpha = 2 * (0.5) * sind(beamDirct_deg);
wB = exp(1i * pi * alpha * (0 : k - 1));
wB = wB / norm(wB);

bWeight = wB';
tmpPhi = 2 * (0.5) * sind(-90:0.1:90)';
sVector = exp(1i * pi * tmpPhi * (0 : k - 1));
bGain = max(mag2db(abs(sVector * bWeight)), -30);
plot(-90:0.1:90, mGain+bGain);

legend('1', string(k), 'all');
phiMin = asind(-1/k);
phiMax = asind(1/k);
plot(ones(1,40)*phiMin, -29:10, 'r.-');
plot(ones(1,40)*phiMax, -29:10, 'r.-');
ax = gca;
ax.YLim = [-30 20];
