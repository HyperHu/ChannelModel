%%
%clear all;
%blerMatrixFile = "blerMatrix16QAM_5KSample_PRB50.mat";
%blerMatrixFile = "blerMatrixQPSK_5KSample_PRB50.mat";
blerMatrixFile = "blerMatrix_2KSample_PRB20.mat";
load(blerMatrixFile);
load("ep_list_PRB" + nPrb +".mat", "ep_list");
load("SpectralEfficiency_Table.mat");

%%
% All
% startIdx = 1; endSeIdx = 27;
% QPSK
%startIdx = 1; endSeIdx = 16;
% 16QAM
startIdx = 17; endSeIdx = 23;
% 64QAM
%startIdx = 24; endSeIdx = 35;
% 256QAM
%startIdx = 36; endSeIdx = 43;

err_poly2 = zeros(1, endSeIdx);
err_gauss = zeros(1, endSeIdx);
a_gauss = zeros(1, endSeIdx);
b_gauss = zeros(1, endSeIdx);
c_gauss = zeros(1, endSeIdx);

for tmpIdx = startIdx:endSeIdx
    seIdx = tmpIdx;
    diffVal = [0 blerMatrix(seIdx,1:end-1)] - [0 blerMatrix(seIdx,2:end)];
    diffVal = diffVal ./ sum(diffVal);
    idxL = round(1 + (ep_list(seIdx,1) - snrdB_List(1)) / (snrdB_List(2) - snrdB_List(1)));
    idxR = round(1 + (ep_list(seIdx,2) - snrdB_List(1)) / (snrdB_List(2) - snrdB_List(1)));

    %%
    gaussEqn = 'a*exp(-((x-b)/c)^2)';
    startPoints = [0.1 (ep_list(seIdx,2) + ep_list(seIdx,1))/2 0.25];
    fff_gauss = fit(snrdB_List',diffVal',gaussEqn, 'Start', startPoints);
    estDiff_gauss = fff_gauss(snrdB_List);
    estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);

    gaussEqn = 'a*exp(-((x-b)/c)^2)';
    startPoints = [abs(fff_gauss.a) fff_gauss.b abs(fff_gauss.c)];
    fff_gauss = fit(snrdB_List',estDiff_gauss,gaussEqn, 'Start', startPoints);
    estDiff_gauss = fff_gauss(snrdB_List);
    estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
    
    %%
    estBler_gauss = zeros(1, size(blerMatrix,2));
    estBler_gauss(1) = 1;
    for idx = 2:size(estBler_gauss,2)
        estBler_gauss(idx) = estBler_gauss(idx-1) - estDiff_gauss(idx);
    end
    
    %%
    err_gauss(tmpIdx) = std(blerMatrix(seIdx, idxL:idxR) - estBler_gauss(idxL:idxR));
    a_gauss(tmpIdx) = fff_gauss.a;
    b_gauss(tmpIdx) = fff_gauss.b;
    c_gauss(tmpIdx) = fff_gauss.c;
    
    %%
    figure(4); hold on; grid on;
%     plot(blerMatrix(seIdx, idxL:idxR) - estBler_gauss(idxL:idxR));
    plot(snrdB_List, blerMatrix(seIdx, :), '.');
    plot(snrdB_List, estBler_gauss, '--');
%     
    figure(5); hold on; grid on;
    plot(snrdB_List, diffVal, '*');
    plot(snrdB_List, estDiff_gauss, '--');
end


%%
% figure(1); hold on; grid on;
% plot(SpectralEfficiency_Table(startIdx:endSeIdx), err_gauss(startIdx:endSeIdx), '--');
% 
% figure(2); hold on; grid on;
% plot(SpectralEfficiency_Table(startIdx:endSeIdx), b_gauss(startIdx:endSeIdx));
% 
% figure(3); hold on; grid on;
% plot(SpectralEfficiency_Table(startIdx:endSeIdx), c_gauss(startIdx:endSeIdx));
% plot(SpectralEfficiency_Table(startIdx:endSeIdx), a_gauss(startIdx:endSeIdx));
% plot(SpectralEfficiency_Table(startIdx:endSeIdx), a_gauss(startIdx:endSeIdx) .* c_gauss(startIdx:endSeIdx));

figure(1); hold on; grid on;
plot((startIdx:endSeIdx), err_gauss(startIdx:endSeIdx), '--');

figure(2); hold on; grid on;
plot((startIdx:endSeIdx), b_gauss(startIdx:endSeIdx));

figure(3); hold on; grid on;
%plot((startIdx:endSeIdx), a_gauss(startIdx:endSeIdx));
plot((startIdx:endSeIdx), c_gauss(startIdx:endSeIdx));
plot((startIdx:endSeIdx), a_gauss(startIdx:endSeIdx) .* c_gauss(startIdx:endSeIdx), '--');
