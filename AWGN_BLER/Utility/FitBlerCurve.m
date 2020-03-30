3% %%
% clear all;
% allEffCodeRate_1 = []; allEffCodeRate_2 = [];
% allK_dot_1 = []; allK_dot_2 = [];
% allSF_1 = []; allSF_2 = [];
% allB_1 = []; allB_2 = []; allC_1 = []; allC_2 = [];
% 
% %%
% %%%% QPSK:1-16, 16QAM:17-23, 64QAM:24-35, 256QAM:36-43 %%%%
% startSeIdx = 1; endSeIdx = 16; bitsPerSymbol = 2;
% fileNameList = ["blerMatQPSK_PRB1.mat" "blerMatQPSK_PRB2.mat" "blerMatQPSK_PRB5.mat"...
%                 "blerMatQPSK_PRB10.mat" "blerMatQPSK_PRB20.mat" "blerMatQPSK_PRB50.mat"...
%                 "blerMatQPSK_PRB100.mat" ...
%                 "NewData\blerMatQPSK_PRB10.mat" "NewData\blerMatQPSK_PRB15.mat"...
%                 "NewData\blerMatQPSK_PRB20.mat" "NewData\blerMatQPSK_PRB25.mat"...
%                 "NewData\blerMatQPSK_PRB30.mat" "NewData\blerMatQPSK_PRB40.mat"...
%                 "NewData\blerMatQPSK_PRB50.mat" "NewData\blerMatQPSK_PRB70.mat"];
% 
% % startSeIdx = 17; endSeIdx = 23; bitsPerSymbol = 4;
% % fileNameList = ["blerMat16QAM_PRB5.mat" "blerMat16QAM_PRB10.mat"...
% %                 "blerMat16QAM_PRB20.mat" "blerMat16QAM_PRB50.mat" ...
% %                 "NewData\blerMat16QAM_PRB10.mat" "NewData\blerMat16QAM_PRB15.mat"...
% %                 "NewData\blerMat16QAM_PRB20.mat" "NewData\blerMat16QAM_PRB30.mat"...
% %                 "NewData\blerMat16QAM_PRB50.mat"];
% 
% % startSeIdx = 24; endSeIdx = 35; bitsPerSymbol = 6;
% % fileNameList = ["blerMat64QAM_PRB10.mat" ...
% %                 "NewData\blerMat64QAM_PRB5.mat" "NewData\blerMat64QAM_PRB10.mat"...
% %                 "NewData\blerMat64QAM_PRB15.mat" "NewData\blerMat64QAM_PRB20.mat"...
% %                 "NewData\blerMat64QAM_PRB30.mat" "NewData\blerMat64QAM_PRB50.mat"];
% 
% % startSeIdx = 36; endSeIdx = 43; bitsPerSymbol = 8;
% % fileNameList = ["blerMat256QAM_PRB1.mat" "blerMat256QAM_PRB2.mat"...
% %                 "blerMat256QAM_PRB4.mat" "blerMat256QAM_PRB5.mat"...
% %                 "blerMat256QAM_PRB8.mat" "blerMat256QAM_PRB10.mat"];
% 
% 
% for fileIdx = 1:size(fileNameList, 2)
%     theFileName = fileNameList(fileIdx);
%     load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix');
% 
%     for seIdx = startSeIdx:endSeIdx
%         [~, bgn, ~, effCodeRate, k_dot] = CalSchInfo(seIdx, nPrb, 12);
%         [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 0);
%         if bgn == 1
%             allEffCodeRate_1 = [allEffCodeRate_1 effCodeRate]; allK_dot_1 = [allK_dot_1 k_dot];
%             allSF_1 = [allSF_1 effCodeRate*bitsPerSymbol]; allB_1 = [allB_1 B]; allC_1 = [allC_1 C];
%         else
%             allEffCodeRate_2 = [allEffCodeRate_2 effCodeRate]; allK_dot_2 = [allK_dot_2 k_dot];
%             allSF_2 = [allSF_2 effCodeRate*bitsPerSymbol]; allB_2 = [allB_2 B]; allC_2 = [allC_2 C];
%         end
%     end
% end
% 
% %%
% load("TablesIn3GPP.mat", 'BitsPerSymbol_Table');
% fileNameList = ["NewData\BGN1_NCB1_old.mat" "NewData\BGN2_NCB1.mat" "NewData\BGN2_NCB2.mat"];
% % fileNameList = ["NewData\BGN2_NCB1.mat" "NewData\BGN2_NCB2.mat"];
% % fileNameList = ["NewData\BGN1_NCB1.mat"];
% for fileIdx = 1:size(fileNameList, 2)
%     theFileName = fileNameList(fileIdx);
%     load(theFileName);
%     for itemIdx = 1:size(seIdxSet, 2)
%         seIdx = seIdxSet{itemIdx}; nPrb = nPrbSet{itemIdx}; bitsPerSymbol = BitsPerSymbol_Table(seIdx);
%         if seIdx > 16
%             continue;
%         end
%         [~, bgn, ~, effCodeRate, k_dot] = CalSchInfo(seIdx, nPrb, 12);
%         [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerListSet{itemIdx}, snrdB_List, 0);
%         if bgn == 1
%             allEffCodeRate_1 = [allEffCodeRate_1 effCodeRate]; allK_dot_1 = [allK_dot_1 k_dot];
%             allSF_1 = [allSF_1 effCodeRate*bitsPerSymbol]; allB_1 = [allB_1 B]; allC_1 = [allC_1 C];
%         else
%             allEffCodeRate_2 = [allEffCodeRate_2 effCodeRate]; allK_dot_2 = [allK_dot_2 k_dot];
%             allSF_2 = [allSF_2 effCodeRate*bitsPerSymbol]; allB_2 = [allB_2 B]; allC_2 = [allC_2 C];
%         end
%         
% %         figure(1); hold on; grid on; plot(snrPoint, theCbCurve); plot(snrdB_List, cbBlerListSet{itemIdx}, 'x');
%         
%     end
% end
% 
% %%
% theFileName = "temp\testData_SE12_CB1.mat"; startPRBIdx = 1; endPRBIdx = 15; seIdx = 12; bitsPerSymbol = 2;
% % theFileName = "temp\testData_SE12.mat"; startPRBIdx = 1; endPRBIdx = 18; seIdx = 12; bitsPerSymbol = 2;
% load(theFileName, 'snrdB_List', 'testPRB_list', 'cbBlerMatrix', 'tbBlerMatrix');
% 
% for prbIdx = startPRBIdx:endPRBIdx
%     [~, bgn, ~, effCodeRate, k_dot] = CalSchInfo(seIdx, testPRB_list(prbIdx), 12);
%     [~, ~, A, B, C, theErr] = FitOneBlerCurve(cbBlerMatrix(prbIdx, :), snrdB_List, 0);
%     if bgn == 1
%         allEffCodeRate_1 = [allEffCodeRate_1 effCodeRate]; allK_dot_1 = [allK_dot_1 k_dot];
%         allSF_1 = [allSF_1 effCodeRate*bitsPerSymbol]; allB_1 = [allB_1 B]; allC_1 = [allC_1 C];
%     else
%         allEffCodeRate_2 = [allEffCodeRate_2 effCodeRate]; allK_dot_2 = [allK_dot_2 k_dot];
%         allSF_2 = [allSF_2 effCodeRate*bitsPerSymbol]; allB_2 = [allB_2 B]; allC_2 = [allC_2 C];
%     end
% end
% 
% %%
% xxx_QPSK = [allB_1 allB_2]; yyy_QPSK = log2([allEffCodeRate_1 allEffCodeRate_2]);
% estY_QPSK = -0.004837 * (xxx_QPSK .^ 2) + 0.2586 * (xxx_QPSK) - 1.381;
% 
% ttt_QPSK = [allK_dot_1 allK_dot_2];
% figure(1); hold on; grid on; plot(xxx_QPSK, estY_QPSK - yyy_QPSK, '*');
% figure(2); hold on; grid on; plot(ttt_QPSK, estY_QPSK - yyy_QPSK, '*');
% 
% %%
% effCodeRate = [allEffCodeRate_1 allEffCodeRate_2]; effSF = [allSF_1 allSF_2]; Kdot = [allK_dot_1 allK_dot_2];
% muSINR = [allB_1 allB_2]; sigmadB = [allC_1 allC_2];
% % cftool(effSF, Kdot, sigmadB);
% 
% tmpEffSF = log2(effSF); tmpKdot = log2(Kdot); tmpSigma = log2(sigmadB);
% % cftool(tmpEffSF, tmpKdot, tmpSigma);
% 
% %%
% % clear all;
% % load("TablesIn3GPP.mat");
% % 
% % % load("blerMatQPSK_PRB5.mat", 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
% % % [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(4, :), snrdB_List, 1);
% % % 
% % % load("blerMatQPSK_PRB5_new.mat", 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
% % % [theCbCurve, snrPoint, A, B, C] = FitOneBlerCurve(cbBlerMatrix(4, :), snrdB_List, 1);
% % 
% % %%
% % clear all;
% % allX = [];
% % allB = [];
% % allC = [];
% % %%
% % %%%% QPSK:1-16, 16QAM:17-23, 64QAM:24-35, 256QAM:36-43 %%%%
% % theFileName = "NewData\blerMatQPSK_PRB10.mat"; startSeIdx = 1; endSeIdx = 16;
% % % theFileName = "NewData\blerMat16QAM_PRB20.mat"; startSeIdx = 17; endSeIdx = 23;
% % % theFileName = "NewData\blerMat64QAM_PRB20.mat"; startSeIdx = 24; endSeIdx = 35;
% % 
% % % theFileName = "blerMatQPSK_PRB50.mat"; startSeIdx = 1; endSeIdx = 16;
% % % theFileName = "blerMat16QAM_PRB10.mat"; startSeIdx = 17; endSeIdx = 23;
% % % theFileName = "blerMat64QAM_PRB10.mat"; startSeIdx = 24; endSeIdx = 35;
% % % theFileName = "blerMat256QAM_PRB10.mat"; startSeIdx = 36; endSeIdx = 43;
% % 
% % load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
% % 
% % tmpX = zeros(1, endSeIdx-startSeIdx+1);
% % tmpB = zeros(1, endSeIdx-startSeIdx+1);
% % tmpC = zeros(1, endSeIdx-startSeIdx+1);
% % for seIdx = startSeIdx:endSeIdx
% %     [theTbSize, bgn, nCb, effCodeRate] = CalSchInfo(seIdx, nPrb, 12);
% %     [theCbCurve, snrPoint, A, B, C, theErr] = FitOneBlerCurve(cbBlerMatrix(seIdx, :), snrdB_List, 1);
% %     theTbCurve = 1 - (1 - theCbCurve) .^ nCb;
% %     
% %     tmpX(seIdx-startSeIdx+1) = effCodeRate;
% %     tmpB(seIdx-startSeIdx+1) = B;
% %     tmpC(seIdx-startSeIdx+1) = C;
% %     
% % %     figure(10); hold on; grid on;
% % %     if (bgn == 1)
% % %         plot(log(effCodeRate), B, '*');
% % %     else
% % %         plot(log(effCodeRate), B, 'x');
% % %     end
% % %     figure(11); hold on; grid on;
% % %     if (bgn == 1)
% % %         plot(log(effCodeRate), C, '*');
% % %     else
% % %         plot(log(effCodeRate), C, 'x');
% % %     end
% %     
% %     figure(30); hold on; grid on;
% %     if (nCb > 1)
% %         plot(snrdB_List, cbBlerMatrix(seIdx, :), '.'); plot(snrPoint, theCbCurve, '--');
% %     end
% %     plot(snrdB_List, tbBlerMatrix(seIdx, :), '.'); plot(snrPoint, theTbCurve);
% %     figure(31); hold on; grid on;
% %     plot(seIdx, theErr, 'x');
% % end
% % allX = [allX tmpX]; allB = [allB tmpB]; allC = [allC tmpC];
% 
% %%
% clear all;
% load("blerMatQPSK_PRB5.mat", 'snrdB_List', 'nPrb', 'cbBlerMatrix');
% FitOneBlerCurve_New(cbBlerMatrix(1,:), snrdB_List, 1);
% FitOneBlerCurve_New(cbBlerMatrix(3,:), snrdB_List, 1);
% FitOneBlerCurve_New(cbBlerMatrix(5,:), snrdB_List, 1);
% FitOneBlerCurve_New(cbBlerMatrix(7,:), snrdB_List, 1);
% 
% [theCbCurve, snrPoint] = FitOneBlerCurve(cbBlerMatrix(1,:), snrdB_List, 0);
% plot(snrPoint, theCbCurve, '-.');
% [theCbCurve, snrPoint] = FitOneBlerCurve(cbBlerMatrix(3,:), snrdB_List, 0);
% plot(snrPoint, theCbCurve, '-.');
% [theCbCurve, snrPoint] = FitOneBlerCurve(cbBlerMatrix(5,:), snrdB_List, 0);
% plot(snrPoint, theCbCurve, '-.');
% [theCbCurve, snrPoint] = FitOneBlerCurve(cbBlerMatrix(7,:), snrdB_List, 0);
% plot(snrPoint, theCbCurve, '-.');
% 
% %%% 1/bler - 1 = exp(-a*sinr_linear - b)
% function [A, B, stdErr] = FitOneBlerCurve_New(theBlerCurve, snrdB_List, showFigure)
%     tmpIdx_L = sum(theBlerCurve >=1); tmpIdx_R = sum(theBlerCurve > 0);
%     
% %     tmpY = (1 ./ theBlerCurve(tmpIdx_L:tmpIdx_R)) - 1; tmpX = db2pow(snrdB_List(tmpIdx_L:tmpIdx_R));
% %     newEqn = 'exp(-a*x - b)'; startPoints = [-90 7.4];
% %     newFunc = fit(tmpX', tmpY', newEqn, 'Start', startPoints);
% %     estY = newFunc(db2pow(snrdB_List)); estBler = 1 ./ (estY + 1);
% 
%     tmpY = theBlerCurve(tmpIdx_L:tmpIdx_R); tmpX = db2pow(snrdB_List(tmpIdx_L:tmpIdx_R));
%     newEqn = '1/(1 + exp(-a*x - b))'; startPoints = [-90 7.4];
%     newFunc = fit(tmpX', tmpY', newEqn, 'Start', startPoints);
%     estBler = newFunc(db2pow(snrdB_List));
%     
%     if showFigure > 0
%         figure(showFigure); hold on; grid on;
%         plot(snrdB_List, theBlerCurve, 'o');
%         plot(snrdB_List, estBler, '--');
%     end
% end
% 


%%
% function [estBlerCurve, snrPoint, A, B, C, stdErr] = FitOneBlerCurve(theBlerCurve, snrdB_List, showFigure)
%     snrPoint = -15:0.001:30; estBlerCurve = zeros(size(snrPoint)); estBlerCurve(1) = 1;
%     idxS = find(theBlerCurve < 1, 1, 'first'); idxE = find(theBlerCurve > 0, 1, 'last');
%     tmpX = snrdB_List(idxS+1:idxE); tmpY = theBlerCurve(idxS:idxE-1) - theBlerCurve(idxS+1:idxE);
%   
%     %%%%%%%%%%%%%%%%%%%%%%%%%% Fit based on Gauss %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [0.05 mean(tmpX) 0.25];
%     fff_gauss = fit(tmpX', tmpY', gaussEqn, 'Start', startPoints);
%     estY = fff_gauss(snrPoint); estY = estY ./ sum(estY);
%     tmpL = find(estY > 0.000001, 1, 'first'); tmpR = find(estY > 0.000001, 1, 'last');
%     startPoints = [fff_gauss.a fff_gauss.b fff_gauss.c];
%     fff_gauss = fit(snrPoint(tmpL:tmpR)', estY(tmpL:tmpR), gaussEqn, 'Start', startPoints);
%     estDiff = fff_gauss(snrPoint); A = fff_gauss.a; B = fff_gauss.b; C = fff_gauss.c;
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%% New Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     deltaXXX = min(max(tmpX) - fff_gauss.b, fff_gauss.b - min(tmpX)); x0 = fff_gauss.b; x1 = x0 + deltaXXX;
% %     y0 = fff_gauss(x0); y1 = fff_gauss(x1);
% %     yy0 = db2pow(-x0) * exp(-db2pow(fff_gauss.b - x0)); yy1 = db2pow(-x1) * exp(-db2pow(fff_gauss.b - x1));
% %     tmpC = log(y0 / y1) / log(yy0 / yy1); tmpB = fff_gauss.b;
% %     
% %     testNList = tmpC/2:1:tmpC*2; testBList = tmpB-0.5:0.001:tmpB+0.5; minErr = 1e10; ccc = 0; bbb = 0;
% %     for iii = 1:size(testNList,2)
% %         for jjj = 1:size(testBList,2)
% %             tmpYY = db2pow(-tmpX) .* exp(-db2pow(testBList(jjj)-tmpX)); tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ testNList(iii);
% %             tmpYY = tmpYY / sum(tmpYY); tmpYY = tmpYY * sum(tmpY);
% %             tmpV = std(tmpY - tmpYY);
% %             if tmpV < minErr
% %                 minErr = tmpV; ccc = testNList(iii); bbb = testBList(jjj);
% %             end
% %         end
% %     end
% %     assert(ccc > min(testNList)); assert(ccc < max(testNList));
% %     assert(bbb > min(testBList)); assert(bbb < max(testBList));
% %     
% %     tmpYY = db2pow(-snrPoint) .* exp(-db2pow(bbb-snrPoint)); tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ ccc;
% %     tmpYY = tmpYY / sum(tmpYY);
% %     estDiff = tmpYY'; A = 1; B = bbb; C = ccc;
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     for idx = 2:size(estBlerCurve,2)
%         estBlerCurve(idx) = estBlerCurve(idx-1) - estDiff(idx);
%     end
%     
%     tmpIdx = 1 + (idxS-1:idxE-1) * floor((snrdB_List(2)-snrdB_List(1)) / (snrPoint(2) - snrPoint(1)));
%     stdErr = std(theBlerCurve(idxS:idxE) - estBlerCurve(tmpIdx));
%     
%     if showFigure > 0
%         figure(showFigure); hold on; grid on;
%         plot((floor((idxS-idxE)/2):floor((idxS-idxE)/2)+(idxE-idxS)), theBlerCurve(idxS:idxE) - estBlerCurve(tmpIdx), '.-');
%         
%         figure(showFigure+1); hold on; grid on; plot(tmpX, tmpY, '.');
%         plot(tmpX, estBlerCurve(tmpIdx(1:end-1)) - estBlerCurve(tmpIdx(2:end)), '--');
%     end
% end
% 
% 
% function [theTbSize, bgn, nCb, effCodeRate, k_dot] = CalSchInfo(seIdx, nPrb, nSymbol)
%     load("TablesIn3GPP.mat", 'TargetCodeRate_Table', 'BitsPerSymbol_Table', 'ModulationOrder_Table');
%     pdsch = struct(); pdsch.NLayers = 1;
%     pdsch.PRBSet = 0:nPrb - 1; pdsch.nPrb = nPrb; pdsch.nSymbol = nSymbol;
%     pdsch.TargetCodeRate = TargetCodeRate_Table(seIdx) / 1024;
%     pdsch.Modulation = ModulationOrder_Table{seIdx};
%     pdsch.BitsPerSymbol = BitsPerSymbol_Table(seIdx);
%     
%     theTbSize = hPDSCHTBS(pdsch, 12*pdsch.nSymbol);
%     tmpInfo = nrDLSCHInfo(theTbSize, pdsch.TargetCodeRate);
%     bgn = tmpInfo.BGN; nCb = tmpInfo.C;
%     effCodeRate = theTbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb);
%     effCodeRate = effCodeRate / (12 * nSymbol * nPrb * pdsch.BitsPerSymbol * pdsch.NLayers);
%     k_dot = (theTbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb)) / nCb;
% end

