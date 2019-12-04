%%
clear all;
load("temp23_RawData.mat");

%%
maxSeIdx = 22;
err_poly2 = zeros(1, maxSeIdx);
err_gauss = zeros(1, maxSeIdx);
a_gauss = zeros(1, maxSeIdx);
b_gauss = zeros(1, maxSeIdx);
c_gauss = zeros(1, maxSeIdx);

for tmpIdx = 1:maxSeIdx
seIdx = tmpIdx;
diffVal = [0 blerMatrix(seIdx,1:end-1)] - [0 blerMatrix(seIdx,2:end)];

filLen = 2;
diffVal_Fil = filter(ones(1,2*filLen+1) / (2*filLen+1),1,diffVal);
diffVal_Fil = [diffVal_Fil((filLen+1):end) zeros(1, filLen)];

%%
tmpY = (-2*(log(sqrt(2*pi)) + log(max(diffVal_Fil, 0.0000001))));
idxL = 0;
idxR = 0;
for idx = 1:size(tmpY,2)
    if (tmpY(idx) < 20)
        idxR = idx;
    end
    if (tmpY(idx) < 20 && idxL == 0)
        idxL = idx;
    end
end

fff_poly2 = fit(snrdB_List(idxL:idxR)', tmpY(idxL:idxR)', 'poly2');
estDiff_poly2 = fff_poly2(snrdB_List);
estDiff_poly2 = exp((estDiff_poly2 ./ -2) - log(sqrt(2*pi)));
estDiff_poly2 = estDiff_poly2 ./ sum(estDiff_poly2);

%%
gaussEqn = 'a*exp(-((x-b)/c)^2)';
[maxVal, maxIdx] = max(estDiff_poly2);
startPoints = [maxVal snrdB_List(maxIdx) (cp_list(seIdx,2) - cp_list(seIdx,1))/4];
fff_gauss = fit(snrdB_List',diffVal',gaussEqn, 'Start', startPoints);
estDiff_gauss = fff_gauss(snrdB_List);
estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);

%%
estBler_poly2 = zeros(1, size(blerMatrix,2));
estBler_poly2(1) = 1;
for idx = 2:size(estBler_poly2,2)
    estBler_poly2(idx) = estBler_poly2(idx-1) - estDiff_poly2(idx);
end

estBler_gauss = zeros(1, size(blerMatrix,2));
estBler_gauss(1) = 1;
for idx = 2:size(estBler_gauss,2)
    estBler_gauss(idx) = estBler_gauss(idx-1) - estDiff_gauss(idx);
end

%%
err_poly2(tmpIdx) = std(blerMatrix(seIdx, idxL:idxR) - estBler_poly2(idxL:idxR));
err_gauss(tmpIdx) = std(blerMatrix(seIdx, idxL:idxR) - estBler_gauss(idxL:idxR));
a_gauss(tmpIdx) = fff_gauss.a;
b_gauss(tmpIdx) = fff_gauss.b;
c_gauss(tmpIdx) = fff_gauss.c;

figure(3); hold on; grid on;
plot(snrdB_List, blerMatrix(seIdx, :), '.');
plot(snrdB_List, estBler_gauss, '--');
end
%%
% figure(1); hold on; grid on;
% plot(snrdB_List, diffVal, '*');
% plot(snrdB_List, diffVal_Fil, '*--');
% plot(snrdB_List, estDiff_poly2, ':');
% plot(snrdB_List, estDiff_gauss, '--');
% 
% figure(2); hold on; grid on;
% plot(snrdB_List, blerMatrix(seIdx, :), '.');
% plot(snrdB_List, estBler_poly2, ':');
% plot(snrdB_List, estBler_gauss, '--');

%%
figure(1); hold on; grid on;
plot(SpectralEfficiency_Table(1:maxSeIdx), err_poly2, ':');
plot(SpectralEfficiency_Table(1:maxSeIdx), err_gauss, '--');

figure(2); hold on; grid on;
plot(SpectralEfficiency_Table(1:maxSeIdx), a_gauss * 10);
plot(SpectralEfficiency_Table(1:maxSeIdx), b_gauss);
plot(SpectralEfficiency_Table(1:maxSeIdx), c_gauss);



%%
%estDiff = exp(((4.613*(tmpX .^ 2) + 107.1*tmpX + 629.2) / -2) - log(sqrt(2*pi)));   %seIdx = 1
%estDiff = exp(((3.234*(tmpX .^ 2) + 74.74*tmpX + 439.8) / -2) - log(sqrt(2*pi)));   %seIdx = 1

%estDiff = exp(((5.662*(tmpX .^ 2) + 94.32*tmpX + 400.4) / -2) - log(sqrt(2*pi)));   %seIdx = 4

%estDiff = exp(((18.2*(tmpX .^ 2) + 84.05*tmpX + 103.3) / -2) - log(sqrt(2*pi)));   %seIdx = 10

%estDiff = exp(((41.73*(tmpX .^ 2) - 530.2*tmpX + 1689) / -2) - log(sqrt(2*pi)));   %seIdx = 20
%estDiff = exp(((39.23*(tmpX .^ 2) - 497.9*tmpX + 1585) / -2) - log(sqrt(2*pi)));   %seIdx = 20

