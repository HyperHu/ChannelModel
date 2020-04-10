%% parameter set
clear all;
addpath(pwd + "\Utility");
load("UniformedFormulaFunction.mat");

%% Load Samples
% load('SampleData\ConstErr\blerMatQPSK_PRB50.mat')
% load('SampleData\ConstErr\blerMat16QAM_PRB50.mat')
% load('SampleData\ConstErr\blerMat64QAM_PRB50.mat')

load('SampleData\DynErr\blerMatQPSK_PRB50.mat')
% load('SampleData\DynErr\blerMat16QAM_PRB50.mat')

%%
for idx = 1:size(cbBlerMatrix, 1)
    if cbBlerMatrix(idx,1) == 0
        continue;
    end
    [theB, theC, theErr, estBler, snrPoint] = FitOneBlerCurve(snrdB_List, cbBlerMatrix(idx,:), 3, 1);
    
    [~, ~, nCb, effCR, k_dot] = CalSchInfo(idx, 50, 12);
    tmpX = log2(effCR * 2); tmpY = log2(k_dot);
    estMu = muSinrFunc_4QAM([tmpX, tmpY]);
    estSigma = sigmaSinrFunc([tmpX, tmpY]);
    estBler_Uniformed = erfc((snrPoint - estMu) / estSigma)/2;
    figure(1); hold on; grid on; plot(snrPoint, estBler_Uniformed);
    figure(5); hold on; grid on; plot(snrPoint, estBler - estBler_Uniformed, ':');
    
%     [~, ~, nCb, ~, ~] = CalSchInfo(idx, nPrb, 12);
%     if nCb > 1
%         figure(5); hold on; grid on;
%         plot(snrdB_List, tbBlerMatrix(idx,:), 'x');
%         plot(snrPoint, 1 - ((1 - estBler) .^ nCb));
%     end
end

