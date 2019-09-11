%%
clear all;

figure(); hold on; grid on;
nFFT = 64;
w0 = 2*pi*(0+0.125)/nFFT;
w1 = 2*pi*(0+1)/nFFT;
data_ori = fftshift(fft(exp(1i * w0 * (1:nFFT))));
%data_ori = data_ori + fftshift(fft(exp(1i * w1 * (1:nFFT))));
plot(-nFFT/2:nFFT/2-1, mag2db(abs(data_ori ./ nFFT)), '*--');

M = 8;

data_extand = fftshift(fft(exp(1i * w0 * (1:nFFT*M))));
%data_extand = data_extand + fftshift(fft(exp(1i * w1 * (1:nFFT*M))));
plot(-nFFT/2:1/M:nFFT/2-1/M, mag2db(abs(data_extand ./ (nFFT*M))), '.--');

M = 2;
data_padding = fftshift(fft([exp(1i * w0 * (1:nFFT)), zeros(1, nFFT*(M-1))]));
%data_padding = data_padding + fftshift(fft([exp(1i * w1 * (1:nFFT)), zeros(1, nFFT*(M-1))]));
plot(-nFFT/2:1/M:nFFT/2-1/M, mag2db(abs(data_padding ./ nFFT)), 'o--');

% theWin = blackman(nFFT)';
% %theWin = theWin ./ norm(theWin);
% data_padding_Window = fftshift(fft([exp(1i * w0 * (1:nFFT)) .* theWin, zeros(1, nFFT*(M-1))]));
% %data_padding_Window = data_padding_Window + fftshift(fft([exp(1i * w1 * (1:nFFT)) .* theWin, zeros(1, nFFT*(M-1))]));
% plot(-nFFT/2:1/M:nFFT/2-1/M, mag2db(abs(data_padding_Window ./ nFFT)), 'o--');

M = 32;
data_padding = fftshift(fft([exp(1i * w0 * (1:nFFT)), zeros(1, nFFT*(M-1))]));
%data_padding = data_padding + fftshift(fft([exp(1i * w1 * (1:nFFT)), zeros(1, nFFT*(M-1))]));
plot(-nFFT/2:1/M:nFFT/2-1/M, mag2db(abs(data_padding ./ nFFT)), 'x--');

% theWin = blackman(nFFT)';
% %theWin = theWin ./ norm(theWin);
% data_padding_Window = fftshift(fft([exp(1i * w0 * (1:nFFT)) .* theWin, zeros(1, nFFT*(M-1))]));
% %data_padding_Window = data_padding_Window + fftshift(fft([exp(1i * w1 * (1:nFFT)) .* theWin, zeros(1, nFFT*(M-1))]));
% plot(-nFFT/2:1/M:nFFT/2-1/M, mag2db(abs(data_padding_Window ./ nFFT)), 'o--');
