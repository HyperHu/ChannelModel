%%
clear all;

load("blerMatrix_2KSample_PRB20.mat");
load("ep_list_PRB20.mat", "ep_list", "nPrb");

% load("Done8_blerMatrix_2KSample_PRB1.mat");
% load("ep_list_PRB1.mat", "ep_list", "nPrb");
% snrdB_List = -15:0.05:30;

load("SpectralEfficiency_Table.mat");
%%
maxSeIdx = 43;
err_poly2 = zeros(1, maxSeIdx);
err_gauss = zeros(1, maxSeIdx);
a_gauss = zeros(1, maxSeIdx);
b_gauss = zeros(1, maxSeIdx);
c_gauss = zeros(1, maxSeIdx);

for tmpIdx = 1:maxSeIdx
    seIdx = tmpIdx;
    diffVal = [0 blerMatrix(seIdx,1:end-1)] - [0 blerMatrix(seIdx,2:end)];

    %%
    gaussEqn = 'a*exp(-((x-b)/c)^2)';
    startPoints = [0.1 (ep_list(seIdx,2) + ep_list(seIdx,1))/2 0.25];
    fff_gauss = fit(snrdB_List',diffVal',gaussEqn, 'Start', startPoints);
    estDiff_gauss = fff_gauss(snrdB_List);
    estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
    
    %%
    estBler_gauss = zeros(1, size(blerMatrix,2));
    estBler_gauss(1) = 1;
    for idx = 2:size(estBler_gauss,2)
        estBler_gauss(idx) = estBler_gauss(idx-1) - estDiff_gauss(idx);
    end
    
    %%
    idxL = round(1 + (ep_list(seIdx,1) - snrdB_List(1)) / (snrdB_List(2) - snrdB_List(1)));
    idxR = round(1 + (ep_list(seIdx,2) - snrdB_List(1)) / (snrdB_List(2) - snrdB_List(1)));
    err_gauss(tmpIdx) = std(blerMatrix(seIdx, idxL:idxR) - estBler_gauss(idxL:idxR));
    a_gauss(tmpIdx) = fff_gauss.a;
    b_gauss(tmpIdx) = fff_gauss.b;
    c_gauss(tmpIdx) = fff_gauss.c;
    
    %%
    figure(3); hold on; grid on;
    plot(snrdB_List, blerMatrix(seIdx, :), '.');
    plot(snrdB_List, estBler_gauss, '--');
    
    figure(4); hold on; grid on;
    plot(snrdB_List, diffVal, '*');
    plot(snrdB_List, estDiff_gauss, '--');
end


%%
figure(1); hold on; grid on;
plot(SpectralEfficiency_Table(1:maxSeIdx), err_gauss, '--');

figure(2); hold on; grid on;
plot(SpectralEfficiency_Table(1:maxSeIdx), a_gauss * 10);
plot(SpectralEfficiency_Table(1:maxSeIdx), b_gauss);
plot(SpectralEfficiency_Table(1:maxSeIdx), c_gauss);

