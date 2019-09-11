%%
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

%%
%nFFTList = [256, 512, 1024, 2048, 4096];
nFFTList = [2048];
kdsList = 0.005:0.001:0.5;
s = zeros(size(nFFTList,2), size(kdsList,2));
v = zeros(size(nFFTList,2), size(kdsList,2));
sig = zeros(size(nFFTList,2), size(kdsList,2));

for idxI = 1:size(nFFTList,2)
    for idxJ = 1:size(kdsList,2)
        dList = -36:36;
        tmpV = zeros(1,size(dList,2));
        for idxK = 1:size(tmpV,2)
            tmpV(idxK) = quick_freqShift(dList(idxK), kdsList(idxJ), nFFTList(idxI));
        end
        %norm(tmpV)
        s(idxI,idxJ) = abs(tmpV(36+1));
        v(idxI,idxJ) = abs(tmpV(36));
        sig(idxI,idxJ) = sqrt(sum(abs(tmpV) .^ 2) - abs(s(idxI,idxJ))^2 - abs(v(idxI,idxJ))^2);
    end
end
% figure(); mesh(kdsList, nFFTList, s);
% hold on; mesh(kdsList, nFFTList, v);
% figure(); mesh(kdsList, nFFTList, sig);

figure(1); hold on; grid on;
plot(kdsList, s, '*');
plot(kdsList, v, 'o');
plot(kdsList, sig, '.');
plot(kdsList, sqrt(s.^2 + v.^2 + sig.^2));
figure(); hold on; grid on;
sPow = s .^ 2;
iPow = v.^2 + sig.^2;
plot(kdsList, pow2db(sPow ./ iPow));

%%
nFFT = 2048;
k_dsList = -0.5:0.01:0.49;
dList = -36:36;
ans1 = zeros(73,100);
ans2 = zeros(73,100);
for idx = 1:73
    for idxi = 1:100
        ans1(idx,idxi) = quick_freqShift(dList(idx), k_dsList(idxi), nFFT);
        ans2(idx,idxi) = quick_freqShift(dList(idx), k_dsList(idxi), nFFT/8);
    end
end

figure();
mesh(k_dsList, dList, abs(ans1));
figure();
mesh(k_dsList, dList, abs(ans2));
figure();
mesh(k_dsList, dList, abs(ans1 - ans2));


function theFilterFactor = quick_freqShift(d, k_ds, nFFT)
    kTotal = d + k_ds;
    if abs(kTotal) > 0.0001
        theFilterFactor = (exp(1i * pi * kTotal * (1-1/nFFT)) / nFFT);
        theFilterFactor = theFilterFactor * sin(pi * kTotal) / sin(pi * kTotal / nFFT);
    else
        theFilterFactor = 1;
    end
end

function theFilterFactor = normal_freqShift(d, k_ds, nFFT)
    kTotal = d + k_ds;
    tmp = exp(1i*2*pi/nFFT * (kTotal) * (0:nFFT-1));
    theFilterFactor = sum(tmp)/nFFT;
end
