function [theFilter, halfWin] = freqShift_FilterFuntion(k_ds, nFFT)
%%
% theFilter1 = zeros(1, nFFT);
% for deltaK = -nFFT/2 : nFFT/2 -1
%     tmp = exp(-1i * (2*pi/nFFT * (deltaK - k_ds)) * (0 : nFFT-1));
%     theFilter1(deltaK + nFFT/2 + 1) = sum(tmp) / nFFT;
% end

%%
kTotal = (-nFFT/2 : (nFFT/2 -1)) - k_ds;
theFilter = exp(-1i*pi*kTotal*(1-1/nFFT)) .* sin(pi * kTotal)...
            ./ sin(pi * kTotal / nFFT) / nFFT;
maxV = max(abs(theFilter));
v40dB = maxV / 100;
halfWin = find(abs(theFilter) > v40dB, 1, 'last') - nFFT/2;

%%
% figure();
% deltaK = -nFFT/2 : (nFFT/2 -1);
% ll = nFFT/2 - max(halfWin, 10) + 1;
% rr = ll + 2*max(halfWin, 10) - 1;
% subplot(2,1,1); plot(deltaK(ll:rr), mag2db(abs(theFilter(ll:rr))), '*--'); grid on;
% subplot(2,1,2); plot(deltaK(ll:rr), angle(theFilter(ll:rr)), 'o--'); grid on;
end
