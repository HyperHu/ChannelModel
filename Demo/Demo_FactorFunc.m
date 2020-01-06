%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

%%
xList = -5.5:0.01:5.49;
%nList = [2, 4, 8, 16, 32, 64];
%nList = [256, 512, 1024, 2048, 4096];
nList = [4];

figure(); hold on; grid on;
for idx = 1:size(nList,2)
    factorList = calFactorFunc(xList, nList(idx));
    plot(xList, mag2db(abs(factorList)), '--')
end

for idx = 1:size(nList,2)
    tmpKList = -5:5;
    factorList = calFactorFunc(tmpKList, nList(idx));
    plot(tmpKList, mag2db(abs(factorList)), '*')
end
for idx = 1:size(nList,2)
    tmpKList = -5:5;
    factorList = calFactorFunc(tmpKList + 0.25, nList(idx));
    plot(tmpKList, mag2db(abs(factorList)), 'x')
end
for idx = 1:size(nList,2)
    tmpKList = -5:5;
    factorList = calFactorFunc(tmpKList + 0.5, nList(idx));
    plot(tmpKList, mag2db(abs(factorList)), 'o')
end