%%
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

nFFT = 2048;
k_dsList = -0.5:0.01:0.49;
dList = -36:36;
ans1 = zeros(73,100);
ans2 = zeros(73,100);
for idx = 1:73
    for idxi = 1:100
        ans1(idx,idxi) = quick_freqShift(dList(idx), k_dsList(idxi), nFFT);
        ans2(idx,idxi) = normal_freqShift(dList(idx), k_dsList(idxi), nFFT);
    end
end

figure();
mesh(k_dsList, dList, abs(ans1));
figure();
mesh(k_dsList, dList, abs(ans2));


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
