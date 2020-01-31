%%
clear all;
load("TablesIn3GPP.mat");

%% Fit One Curve
theFileName = "blerMat256QAM_PRB8.mat";
load(theFileName);
seIdx = 43;

theTbCurve = FitOneBlerCurve(tbBlerMatrix(seIdx, :), snrdB_List, 1);
theCbCurve = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 1);
calTbCurve = 1 - (1 - theCbCurve) .^ 2;
figure(); hold on; grid on;
plot(snrdB_List, tbBlerMatrix(seIdx, :), '.');
plot(snrdB_List, theTbCurve);
plot(snrdB_List, calTbCurve);

%% Fit Multiple Curve

% All
%startSeIdx = 1; endSeIdx = 43;
% QPSK
startSeIdx = 1; endSeIdx = 16;
% 16QAM
%startSeIdx = 20; endSeIdx = 20;
% 64QAM
%startSeIdx = 24; endSeIdx = 35;
% 256QAM
%startSeIdx = 36; endSeIdx = 43;

theFileName = "blerMatQPSK_PRB10.mat";
load(theFileName);

for seIdx = startSeIdx:endSeIdx
    theCbCurve = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 1);

end


%%
function [estBlerCurve, A, B, C] = FitOneBlerCurve(theBlerCurve, snrdB_List, showFigure)
    theL = 1;
    nPoint = floor(size(theBlerCurve,2) / theL) * theL;
    filterCurve = mean(reshape(theBlerCurve(1:nPoint), theL, []), 1);
    filterSnr = mean(reshape(snrdB_List(1:nPoint), theL, []), 1);
    diffVal = [1 filterCurve(1:end-1)] - filterCurve;
    diffVal = diffVal ./ sum(diffVal);
    idxL = max(1, find(diffVal > 0, 1, 'first') - 2);
    idxR = min(size(filterCurve, 2), find(diffVal > 0, 1, 'last') + 2);
    
    gaussEqn = 'a*exp(-((x-b)/c)^2)';
    startPoints = [0.1 (filterSnr(idxL) + filterSnr(idxR))/2 0.25];
    fff_gauss = fit(filterSnr(idxL:idxR)',diffVal(idxL:idxR)',gaussEqn, 'Start', startPoints);
    estDiff_gauss = fff_gauss(filterSnr);
    estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
    gaussEqn = 'a*exp(-((x-b)/c)^2)';
    startPoints = [fff_gauss.a fff_gauss.b fff_gauss.c];
    fff_gauss = fit(filterSnr(idxL:idxR)',estDiff_gauss(idxL:idxR),gaussEqn, 'Start', startPoints);
    estDiff_gauss = fff_gauss(filterSnr);
    
    estBlerCurve = zeros(1, size(filterCurve,2));
    estBlerCurve(1) = 1;
    for idx = 2:size(filterCurve,2)
        estBlerCurve(idx) = estBlerCurve(idx-1) - estDiff_gauss(idx);
    end
    A = fff_gauss.a;
    B = fff_gauss.b;
    C = fff_gauss.c;
    
    if showFigure > 0
        figure(showFigure); hold on; grid on;
        plot(filterSnr(idxL:idxR), filterCurve(idxL:idxR), '.');
        plot(filterSnr(idxL:idxR), estBlerCurve(idxL:idxR), '--');

        figure(showFigure+1); hold on; grid on;
        plot(filterSnr(idxL:idxR), diffVal(idxL:idxR), '*');
        plot(filterSnr(idxL:idxR), estDiff_gauss(idxL:idxR), '--');   
    end
end

