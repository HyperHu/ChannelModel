%%
clear all;
load("SpectralEfficiency_Table.mat");
load("Done29_blerMatrix_2KSample_PRB20.mat");
load("ep_list_PRB20.mat", "ep_list", "nPrb");
ep_list(:,2) = ep_list(:,2) + 0.2;
%%
maxSeIdx = 29;
err_poly2 = zeros(1, maxSeIdx);
err_gauss = zeros(1, maxSeIdx);
a_gauss = zeros(1, maxSeIdx);
b_gauss = zeros(1, maxSeIdx);
c_gauss = zeros(1, maxSeIdx);

for tmpIdx = 1:maxSeIdx
    seIdx = tmpIdx;
    diffVal = [0 blerMatrix(seIdx,1:end-1)] - [0 blerMatrix(seIdx,2:end)];
    
%     %%
%     filLen = 2;
%     diffVal_Fil = filter(ones(1,2*filLen+1) / (2*filLen+1),1,diffVal);
%     diffVal_Fil = [diffVal_Fil((filLen+1):end) zeros(1, filLen)];
%     tmpY = (-2*(log(sqrt(2*pi)) + log(max(diffVal_Fil, 0.0000001))));
%     idxL = 0;
%     idxR = 0;
%     for idx = 1:size(tmpY,2)
%         if (tmpY(idx) < 20)
%             idxR = idx;
%         end
%         if (tmpY(idx) < 20 && idxL == 0)
%             idxL = idx;
%         end
%     end
%     
%     fff_poly2 = fit(snrdB_List(idxL:idxR)', tmpY(idxL:idxR)', 'poly2');
%     estDiff_poly2 = fff_poly2(snrdB_List);
%     estDiff_poly2 = exp((estDiff_poly2 ./ -2) - log(sqrt(2*pi)));
%     estDiff_poly2 = estDiff_poly2 ./ sum(estDiff_poly2);
%     [maxVal, maxIdx] = max(estDiff_poly2);
%     startPoints = [maxVal snrdB_List(maxIdx) (ep_list(seIdx,2) - ep_list(seIdx,1))/4];
%     estBler_poly2 = zeros(1, size(blerMatrix,2));
%     estBler_poly2(1) = 1;
%     for idx = 2:size(estBler_poly2,2)
%         estBler_poly2(idx) = estBler_poly2(idx-1) - estDiff_poly2(idx);
%     end

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
    %err_poly2(tmpIdx) = std(blerMatrix(seIdx, idxL:idxR) - estBler_poly2(idxL:idxR));
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
%     %plot(snrdB_List, diffVal_Fil, '*--');
%     %plot(snrdB_List, estDiff_poly2, ':');

end


%%
figure(1); hold on; grid on;
%plot(SpectralEfficiency_Table(1:maxSeIdx), err_poly2, ':');
plot(SpectralEfficiency_Table(1:maxSeIdx), err_gauss, '--');

figure(2); hold on; grid on;
plot(SpectralEfficiency_Table(1:maxSeIdx), a_gauss * 10);
plot(SpectralEfficiency_Table(1:maxSeIdx), b_gauss);
plot(SpectralEfficiency_Table(1:maxSeIdx), c_gauss);

