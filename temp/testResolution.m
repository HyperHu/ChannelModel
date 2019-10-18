%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

nFFT = 1024;

%%
% diffT = 10;
% W_ori = 8.05;
% sig_ori = exp(1i * (2*pi/nFFT) * W_ori * (0:nFFT-1));
% oriFFT = fft(sig_ori);
% 
% 
% sig_extend = exp(1i * (2*pi/nFFT) * W_ori * (diffT * nFFT + (0:nFFT-1)));
% estFFT = oriFFT .* exp(-1i * (2*pi/nFFT) * (diffT * nFFT) * (0:nFFT-1));
% sig_est = ifft(estFFT);
% 
% figure(1); hold on; grid on;
% plot(real(sig_extend - sig_est), '*--');
% 

%%
dT_List = 1:20;
dW_List = -0.5:0.01:0.49;
tmpResult = zeros(size(dT_List, 2), size(dW_List, 2));
for idxT = 1:size(dT_List, 2)
    for idxW = 1:size(dW_List, 2)
        diffT = dT_List(idxT);
        W_ori = 8 + dW_List(idxW);
        sig_extend = exp(1i * (2*pi/nFFT) * W_ori * (diffT * nFFT + (0:nFFT-1)));
        oriFFT = fft(exp(1i * (2*pi/nFFT) * W_ori * (0:nFFT-1)));
        oriFFT = oriFFT .* [zeros(1, 6), ones(1, 4), zeros(1, nFFT-(6+4))];
        sig_est = ifft(oriFFT .* exp(-1i * (2*pi/nFFT) * (diffT * nFFT) * (0:nFFT-1)));
        tmpResult(idxT, idxW) = norm(sig_est - sig_extend);
    end
end
figure(2); mesh(dW_List, dT_List, tmpResult);
