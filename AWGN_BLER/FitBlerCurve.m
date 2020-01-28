%%
clear all;
load("TablesIn3GPP.mat");

%% Fit One Curve
load("blerMat256QAM_PRB1.mat");
theTbCurve = FitOneBlerCurve(tbBlerMatrix(36,:), snrdB_List);
% figure(1); hold on; grid on;
% plot(snrdB_List, log10(tbBlerMatrix(37,:)), '.');
% plot(snrdB_List, log10(theTbCurve), '--');


function [estBlerCurve, A, B, C] = FitOneBlerCurve(theBlerCurve, snrdB_List)
    diffVal = [1 theBlerCurve(1:end-1)] - theBlerCurve;
    diffVal = diffVal ./ sum(diffVal);
    idxL = max(1, find(diffVal > 0, 1, 'first') - 2);
    idxR = min(size(theBlerCurve, 2), find(diffVal > 0, 1, 'last') + 2);
    
    gaussEqn = 'a*exp(-((x-b)/c)^2)';
    startPoints = [0.1 (snrdB_List(idxL) + snrdB_List(idxR))/2 0.25];
    fff_gauss = fit(snrdB_List(idxL:idxR)',diffVal(idxL:idxR)',gaussEqn, 'Start', startPoints);
    
    estDiff_gauss = fff_gauss(snrdB_List);
    estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
    
    estBlerCurve = zeros(1, size(theBlerCurve,2));
    estBlerCurve(1) = 1;
    for idx = 2:size(estBlerCurve,2)
        estBlerCurve(idx) = estBlerCurve(idx-1) - estDiff_gauss(idx);
    end
    A = fff_gauss.a;
    B = fff_gauss.b;
    C = fff_gauss.c;
    
    figure(2); hold on; grid on;
    plot(snrdB_List(idxL+2:idxR-5), log10(theBlerCurve(idxL+2:idxR-5)), '.');
    plot(snrdB_List(idxL+2:idxR-5), log10(estBlerCurve(idxL+2:idxR-5)), '--');
    
%     figure(5); hold on; grid on;
%     plot(snrdB_List(idxL:idxR), diffVal(idxL:idxR), '*');
%     plot(snrdB_List(idxL:idxR), estDiff_gauss(idxL:idxR), '--');
%     
%     figure(6); hold on; grid on;
%     plot(snrdB_List(idxL:idxR), estBlerCurve(idxL:idxR) - theBlerCurve(idxL:idxR));
end



% %% Fit Multi Curve
% % All
% %startIdx = 1; endSeIdx = 43;
% % QPSK
% %startIdx = 1; endSeIdx = 16;
% % 16QAM
% startIdx = 20; endSeIdx = 20;
% % 64QAM
% %startIdx = 24; endSeIdx = 35;
% % 256QAM
% %startIdx = 36; endSeIdx = 43;
% 
% err_poly2 = zeros(1, endSeIdx);
% err_gauss = zeros(1, endSeIdx);
% a_gauss = zeros(1, endSeIdx);
% b_gauss = zeros(1, endSeIdx);
% c_gauss = zeros(1, endSeIdx);
% 
% for tmpIdx = startIdx:endSeIdx
%     seIdx = tmpIdx;
%     diffVal = [0 blerMatrix(seIdx,1:end-1)] - [0 blerMatrix(seIdx,2:end)];
%     diffVal = diffVal ./ sum(diffVal);
%     %idxL = round(1 + (ep_list(seIdx,1) - snrdB_List(1)) / (snrdB_List(2) - snrdB_List(1)));
%     %idxR = round(1 + (ep_list(seIdx,2) - snrdB_List(1)) / (snrdB_List(2) - snrdB_List(1)));
%     idxL = max(1, find(diffVal > 0, 1, 'first') - 2);
%     idxR = min(size(blerMatrix, 2), find(diffVal > 0, 1, 'last') + 2);
% 
%     %%
%     gaussEqn = 'a*exp(-((x-b)/c)^2)';
%     startPoints = [0.1 (snrdB_List(idxL) + snrdB_List(idxR))/2 0.25];
%     fff_gauss = fit(snrdB_List(idxL:idxR)',diffVal(idxL:idxR)',gaussEqn, 'Start', startPoints);
%     estDiff_gauss = fff_gauss(snrdB_List);
%     estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
% 
% %     gaussEqn = 'a*exp(-((x-b)/c)^2)';
% %     startPoints = [abs(fff_gauss.a) fff_gauss.b abs(fff_gauss.c)];
% %     fff_gauss = fit(snrdB_List(idxL:idxR)',estDiff_gauss(idxL:idxR),gaussEqn, 'Start', startPoints);
% %     estDiff_gauss = fff_gauss(snrdB_List);
% %     estDiff_gauss = estDiff_gauss ./ sum(estDiff_gauss);
%     
%     %%
%     estBler_gauss = zeros(1, size(blerMatrix,2));
%     estBler_gauss(1) = 1;
%     for idx = 2:size(estBler_gauss,2)
%         estBler_gauss(idx) = estBler_gauss(idx-1) - estDiff_gauss(idx);
%     end
%     
%     %%
%     err_gauss(tmpIdx) = std(blerMatrix(seIdx, idxL:idxR) - estBler_gauss(idxL:idxR));
%     a_gauss(tmpIdx) = fff_gauss.a;
%     b_gauss(tmpIdx) = fff_gauss.b;
%     c_gauss(tmpIdx) = fff_gauss.c;
%     
% %     %%
%     figure(4); hold on; grid on;
%     %plot(estBler_gauss(idxL:idxR) - (blerMatrix(seIdx, idxL:idxR)));
%     plot(snrdB_List(idxL:idxR), blerMatrix(seIdx, idxL:idxR), '.');
%     plot(snrdB_List(idxL:idxR), estBler_gauss(idxL:idxR), '--');
% % % 
%     figure(5); hold on; grid on;
%     plot(snrdB_List(idxL:idxR), diffVal(idxL:idxR), '*');
%     plot(snrdB_List(idxL:idxR), estDiff_gauss(idxL:idxR), '--');
% end
% 
% 
% %%
% % figure(1); hold on; grid on;
% % plot(SpectralEfficiency_Table(startIdx:endSeIdx), err_gauss(startIdx:endSeIdx), '--');
% % 
% % figure(2); hold on; grid on;
% % plot(SpectralEfficiency_Table(startIdx:endSeIdx), b_gauss(startIdx:endSeIdx));
% % 
% % figure(3); hold on; grid on;
% % plot(SpectralEfficiency_Table(startIdx:endSeIdx), c_gauss(startIdx:endSeIdx));
% % plot(SpectralEfficiency_Table(startIdx:endSeIdx), a_gauss(startIdx:endSeIdx));
% % plot(SpectralEfficiency_Table(startIdx:endSeIdx), a_gauss(startIdx:endSeIdx) .* c_gauss(startIdx:endSeIdx));
% 
% figure(1); hold on; grid on;
% plot((startIdx:endSeIdx), err_gauss(startIdx:endSeIdx), '--');
% 
% figure(2); hold on; grid on;
% plot((startIdx:endSeIdx), b_gauss(startIdx:endSeIdx));
% 
% figure(3); hold on; grid on;
% %plot((startIdx:endSeIdx), a_gauss(startIdx:endSeIdx));
% plot((startIdx:endSeIdx), c_gauss(startIdx:endSeIdx));
% plot((startIdx:endSeIdx), a_gauss(startIdx:endSeIdx) .* c_gauss(startIdx:endSeIdx), '--');
