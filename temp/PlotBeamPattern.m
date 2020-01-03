clear all;

%%
% % Beam 1
% wN = sqrt(3.0715) * [-0.2724 - 0.0421i  -0.1676 - 0.6292i   0.5088 - 0.4064i   0.2441 + 0.1280i];  %H
% wM = sqrt(3.0715) * [-0.5000 + 0.0000i  -0.4088 - 0.2879i  -0.1684 - 0.4708i   0.1334 - 0.4819i];  %V

% % Beam 2
% wN = sqrt(3.0715) * [-0.2724 - 0.0421i  -0.6435 - 0.0995i  -0.6435 - 0.0995i  -0.2724 - 0.0421i];  %H
% wM = sqrt(3.0715) * [-0.5000 + 0.0000i  -0.4088 - 0.2879i  -0.1684 - 0.4708i   0.1334 - 0.4819i];  %V

% % Beam 3
wN = sqrt(3.0715) * [-0.2724 - 0.0421i  -0.3498 + 0.5492i   0.3622 + 0.5411i   0.2714 - 0.0483i];  %H
wM = sqrt(3.0715) * [-0.5000 + 0.0000i  -0.4088 - 0.2879i  -0.1684 - 0.4708i   0.1334 - 0.4819i];  %V

% % Beam 4
% wN = sqrt(3.5370) * [-0.0862 + 0.4157i   0.5655 - 0.0000i   0.5655 - 0.0000i  -0.0862 + 0.4157i];  %H
% wM = sqrt(3.5370) * [0.5000 + 0.0000i  -0.2645 + 0.4243i  -0.2203 - 0.4489i   0.4975 + 0.0504i];  %V

wAll = (kron(wN.', wM));
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freqzLen = 512;
figure(1); hold on; grid on;
[WN, ~] = freqz(wN, 1, 2*freqzLen, 'whole');
[WM, tmpw] = freqz(wM, 1, 2*freqzLen, 'whole');
plot(tmpw/pi - 1, 20*log10(fftshift(abs(WN))))
plot(tmpw/pi - 1, 20*log10(fftshift(abs(WM))))
ax = gca;
ax.YLim = [-50 20];
ax.XTick = -1:.25:1;
legend('H', 'V');
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
hold off;


%%
normalD_N = 0.5;
normalD_M = 0.5;
dd = 1;
thetaList = 0:dd:180;
phiList = -90:dd:90;
gMatrix = zeros(size(thetaList,2), size(phiList,2));
for idxT = 1:size(thetaList,2)
    for idxP = 1:size(phiList,2)
        alpha = 2 * normalD_N * sind(thetaList(idxT)) * sind(phiList(idxP));
        belta = 2 * normalD_M * cosd(thetaList(idxT));
        alpha = mod(alpha, 2);
        belta = mod(belta, 2);
        
        hN = WN(mod(floor(mod(alpha, 2) * freqzLen), 2 * freqzLen) + 1);
        hM = WM(mod(floor(mod(belta, 2) * freqzLen), 2 * freqzLen) + 1);
        
        gMatrix(idxT, idxP) = max(20*log10(abs(hN * hM)), -50);
    end
end
figure(2);
mesh(phiList, thetaList, gMatrix);

%%
fc = 3.5e9;
lamda = 3e8/fc;
plotAzRange = -90:1:90;
plotElRange = -90:1:90;
antTrx = phased.IsotropicAntennaElement();
antPannel = phased.URA(size(wAll), [0.5*lamda 0.5*lamda], 'Element',antTrx);
figure(3), pattern(antPannel, fc, plotAzRange, plotElRange, 'Type','powerdb', 'Weights', reshape(wAll.', [],1));


