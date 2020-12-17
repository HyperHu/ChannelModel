%% parameter set
clear all;
addpath(pwd + "\Utility");
load("UniformedFormulaFunction.mat");

%% Load Samples
% load('SampleData\ConstErr\blerMatQPSK_PRB50.mat')
% load('SampleData\ConstErr\blerMat16QAM_PRB50.mat')
% load('SampleData\ConstErr\blerMat64QAM_PRB50.mat')

% load('SampleData\DynErr\blerMatQPSK_PRB10.mat')
% load('SampleData\DynErr\blerMat16QAM_PRB50.mat')
load('SampleData\DynErr\blerMat256QAM_PRB10.mat')

% load('result_backup\blerMat16QAM_PRB50.mat'); cbBlerMatrix = blerMatrix;


%%
clear all;
addpath(pwd + "\Utility");
load('SampleData\FineCurve_100K.mat');
[theB, theC, theErr2, estBler, snrPoint] = FitOneBlerCurve(snrdB_List, cbBlerCurve, 1, 1);
[theB, theC, theErr2, estBler, snrPoint] = FitOneBlerCurve(snrdB_List, cbBlerCurve, 2, 1);
[theB, theC, theErr3, estBler, snrPoint] = FitOneBlerCurve(snrdB_List, cbBlerCurve, 3, 1);
[theB, theC, theErr4, estBler, snrPoint] = FitOneBlerCurve(snrdB_List, cbBlerCurve, 4, 1);

%%
for idx = 1:2:size(cbBlerMatrix, 1)
    if cbBlerMatrix(idx,1) == 0
        continue;
    end
    [theB, theC, theErr, estBler, snrPoint] = FitOneBlerCurve(snrdB_List, cbBlerMatrix(idx,:), 4, 1);
%     [~, ~, nCb, effCR, ~] = CalSchInfo(idx, nPrb, 12);
%     ttt = pow2db(2.^(effCR*4) - 1);
%     figure(1); plot(ttt*ones(1,101), (0:100)/100);

%     if nCb > 1
%         figure(1); hold on; grid on;
%         plot(snrdB_List, tbBlerMatrix(idx,:), 'o');
%         plot(snrPoint, 1 - ((1 - estBler) .^ nCb));
%     end
    
%     tmpX = log2(effCR * 2); tmpY = log2(k_dot);
%     estMu = muSinrFunc_4QAM([tmpX, tmpY]);
%     estSigma = sigmaSinrFunc([tmpX, tmpY]);
%     estBler_Uniformed = erfc((snrPoint - estMu) / estSigma)/2;
%     figure(1); hold on; grid on; plot(snrPoint, estBler_Uniformed);
%     figure(5); hold on; grid on; plot(snrPoint, estBler - estBler_Uniformed, ':');
    
%     [~, ~, nCb, ~, ~] = CalSchInfo(idx, nPrb, 12);
%     if nCb > 1
%         figure(5); hold on; grid on;
%         plot(snrdB_List, tbBlerMatrix(idx,:), 'x');
%         plot(snrPoint, 1 - ((1 - estBler) .^ nCb));
%     end
end

