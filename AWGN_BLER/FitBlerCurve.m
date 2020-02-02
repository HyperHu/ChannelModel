%%
clear all;
load("TablesIn3GPP.mat");

%% Fit One Curve
% theFileName = "blerMat256QAM_PRB8.mat";
% load(theFileName);
% seIdx = 43;
% 
% theTbCurve = FitOneBlerCurve(tbBlerMatrix(seIdx, :), snrdB_List, 1);
% theCbCurve = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 1);
% calTbCurve = 1 - (1 - theCbCurve) .^ 2;
% figure(); hold on; grid on;
% plot(snrdB_List, tbBlerMatrix(seIdx, :), '.');
% plot(snrdB_List, theTbCurve);
% plot(snrdB_List, calTbCurve);

%% Fit Multiple Curve

% All
%startSeIdx = 1; endSeIdx = 43;
% QPSK
startSeIdx = 1; endSeIdx = 16;
% 16QAM
%startSeIdx = 17; endSeIdx = 23;
% 64QAM
%startSeIdx = 24; endSeIdx = 35;
% 256QAM
%startSeIdx = 36; endSeIdx = 43;

%theFileName = "blerMat256QAM_PRB8.mat";
theFileName = "blerMatQPSK_PRB1.mat";
load(theFileName);

for seIdx = startSeIdx:endSeIdx
    theCbCurve = FitOneBlerCurve(tbBlerMatrix(seIdx, :), snrdB_List, 1);
end


%%
function [estBlerCurve, A, B, C] = FitOneBlerCurve(theBlerCurve, snrdB_List, showFigure)
    theL = 3; margin = 2;
    nPoint = floor(size(theBlerCurve,2) / theL) * theL;
    filterCurve = mean(reshape(theBlerCurve(1:nPoint), theL, []), 1);
    filterSnr = mean(reshape(snrdB_List(1:nPoint), theL, []), 1);
    diffVal = [1 filterCurve(1:end-1)] - filterCurve;
    diffVal = diffVal ./ sum(diffVal);
    idxL = max(1, find(diffVal > 0, 1, 'first') - margin);
    idxR = min(size(filterCurve, 2), find(diffVal > 0, 1, 'last') + margin);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     gaussEqn = 'a*exp(-((x-b)/c)^2)';
%     startPoints = [0.1 (filterSnr(idxL) + filterSnr(idxR))/2 0.25];
%     fff_gauss = fit(filterSnr(idxL:idxR)',diffVal(idxL:idxR)',gaussEqn, 'Start', startPoints);
%     snrLine = db2mag(filterSnr); tmpYYY = diffVal .^ (1/128);
%     %plot(snrLine(idxL:idxR), tmpYYY(idxL:idxR), '*');
%     newEqn = 'a*exp(b*(c*(x^2)+log(x)))'; startPoints = [0.0013 4.0 -1/(2*(8.65^2))];
%     fff_new = fit(snrLine(idxL:idxR)',tmpYYY(idxL:idxR)', newEqn, 'Start', startPoints);
%     estDiff_new = fff_new(snrLine) .^ 128; estDiff_new = estDiff_new ./ sum(estDiff_new);
%     estDiff = estDiff_new; fff = fff_new;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     gaussEqn = 'a*exp(-((x-b)/c)^2)';
%     startPoints = [0.1 (filterSnr(idxL) + filterSnr(idxR))/2 0.25];
%     fff_gauss = fit(filterSnr(idxL:idxR)',diffVal(idxL:idxR)',gaussEqn, 'Start', startPoints);
%     
%     x0 = db2mag(fff_gauss.b); y0 = fff_gauss(fff_gauss.b);
%     x1 = db2mag(fff_gauss.b + 1*fff_gauss.c); y1 = fff_gauss(fff_gauss.b + 1*fff_gauss.c);
%     snrLine = db2mag(filterSnr); tmpD = -0.5 / db2pow(fff_gauss.b);
%     tmpC = log(y1/y0) / (log(x1/x0) + 0.5 - 0.5*((x1/x0)^2)); tmpB = tmpD * tmpC;
%     tmpA = y0 / exp(tmpB*(x0^2) + tmpC*log(x0));
% 
%     newEqn = 'a*exp(b*(x^2)+c*log(x))'; startPoints = [tmpA tmpB tmpC];
%     fff_new = fit(snrLine(idxL:idxR)',diffVal(idxL:idxR)', newEqn, 'Start', startPoints);
%     estDiff_new = fff_new(snrLine); estDiff_new = estDiff_new ./ sum(estDiff_new);
%     newEqn = 'a*exp(b*(x^2)+c*log(x))'; startPoints = [fff_new.a fff_new.b fff_new.c];
%     fff_new = fit(snrLine(idxL:idxR)',estDiff_new(idxL:idxR), newEqn, 'Start', startPoints);
%     estDiff_new = fff_new(snrLine);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gaussEqn = 'a*exp(-((x-b)/c)^2)';
    startPoints = [0.1 (filterSnr(idxL) + filterSnr(idxR))/2 0.25];
    fff_gauss = fit(filterSnr(idxL:idxR)',diffVal(idxL:idxR)',gaussEqn, 'Start', startPoints);
    estDiff_gauss = fff_gauss(filterSnr);
    estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
    gaussEqn = 'a*exp(-((x-b)/c)^2)';
    startPoints = [fff_gauss.a fff_gauss.b fff_gauss.c];
    fff_gauss = fit(filterSnr(idxL:idxR)',estDiff_gauss(idxL:idxR),gaussEqn, 'Start', startPoints);
    estDiff_gauss = fff_gauss(filterSnr);
    estDiff = estDiff_gauss; fff = fff_gauss;
    
    estBlerCurve = zeros(1, size(filterCurve,2));
    estBlerCurve(1) = 1;
    for idx = 2:size(filterCurve,2)
        estBlerCurve(idx) = estBlerCurve(idx-1) - estDiff(idx);
    end
    A = fff.a;
    B = fff.b;
    C = fff.c;
    
    if showFigure > 0
        figure(showFigure); hold on; grid on;
        plot(filterSnr(idxL:idxR), filterCurve(idxL:idxR), '.');
        plot(filterSnr(idxL:idxR), estBlerCurve(idxL:idxR), '--');

        figure(showFigure+1); hold on; grid on;
        plot(filterSnr(idxL:idxR), estBlerCurve(idxL:idxR) - filterCurve(idxL:idxR), '--');
        
        figure(showFigure+2); hold on; grid on;
        plot(filterSnr(idxL:idxR), diffVal(idxL:idxR), '*');
        plot(filterSnr(idxL:idxR), estDiff(idxL:idxR), '--');   
    end
end

