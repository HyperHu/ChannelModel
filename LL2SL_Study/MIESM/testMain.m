%%
clearvars;

%%

% modMethod = "256QAM"; targetRc = 0.8; numLay = 1; numPrb = 8; numRe = 144;
% aveSnrList = 19:0.1:25; nSample = 20; nTest = 500; skipRange = [20, 23];

modMethod = "64QAM"; targetRc = 0.5; numLay = 2; numPrb = 16; numRe = 144;
%aveSnrList = 8.0:0.1:15.0; nSample = 1; nTest = 50; skipRange = [9.5, 11.5];
aveSnrList = 10.0:0.1:11.0; nSample = 1; nTest = 500; skipRange = [9.5, 11.5];

% modMethod = "16QAM"; targetRc = 0.25; numLay = 1; numPrb = 64; numRe = 144;
% aveSnrList = 1.0:0.1:6.0; nSample = 20; nTest = 500; skipRange = [1.7, 2.7];

allEffSNR = {}; allBlerSample = {}; allDiff = {};

testSig = [2, 4, 6, 8, 10, 15];
plotColor = ["b", "g", "r", "c", "m", "y"];
for sigIdx = 1:6
fadingMu = [0;]; fadingSig = [testSig(sigIdx);];
[effSNRList, blerSampleList, diffList] = GenBlerSamples(modMethod, targetRc, numLay, numPrb, numRe, ...
                                                        fadingMu, fadingSig, aveSnrList, nSample, nTest, skipRange);

figure(1); hold on; grid on; plot3(effSNRList, diffList(:,1), blerSampleList, plotColor(sigIdx)+"*");
figure(2); hold on; grid on; plot3(effSNRList, diffList(:,2), blerSampleList, plotColor(sigIdx)+"*");
allEffSNR{sigIdx} = effSNRList; allBlerSample{sigIdx} = blerSampleList; allDiff{sigIdx} = diffList;
end

%%
clear all;
%load("16QAM_p25.mat");
%load("16QAM_p25_NonScal.mat");
%load("16QAM_p25_CB4.mat");
%load("256QAM_p8.mat");
%load("256QAM_p8_DiffMu.mat");
load("256QAM_p68.mat");
%load("64QAM_p5_DiffMu.mat");
%load("64QAM_p5.mat");

totalX = []; totalY = []; totalZ = [];
for sigIdx = 1:6
figure(3); hold on; grid on;
plot3(allEffSNR{sigIdx}, allDiff{sigIdx}(:,1), allBlerSample{sigIdx}, plotColor(sigIdx)+"o");
figure(4); hold on; grid on;
plot3(allEffSNR{sigIdx}, allDiff{sigIdx}(:,2), allBlerSample{sigIdx}, plotColor(sigIdx)+"o");

totalX = [totalX; allEffSNR{sigIdx}]; totalY = [totalY; allDiff{sigIdx}(:,2)]; totalZ = [totalZ; allBlerSample{sigIdx}];
end

%% 
% x1 = effSNRList - 20; y1 = 1 - blerSampleList;
% %S_function=inline('alpha(1)./(1+exp(alpha(2) - (x1.*alpha(3))))','alpha','x1');
% %alpha0=[1 4 0.5]; alpha = nlinfit(x1,y1,S_function,alpha0);
% S_function=inline('alpha(1) ./ ((1 + exp(alpha(2) - alpha(3) * x1)) .^ alpha(4))','alpha','x1');
% alpha0=[1 4 0.1 0.5]; alpha = nlinfit(x1,y1,S_function,alpha0);
% figure(2); hold on; grid on;
% plot(x1, y1, '*');
% plot(x1, S_function(alpha, x1));




%%
% 
% colorList = ["r", "b", "y", "g"];
% diffList = [0, 2, 4, 6] * 3;
% for tttIdx = 1:4
% for theSnr = 2.5:-0.1:1.5
%     nSample = 1000;
%     modMethod = "16QAM"; targetRc = 0.25;
%     numLay = 1; numPrb = 16; numRe = 144;
%     channelSample = 50;
%     if diffList(tttIdx) == 0
%         channelSample = 1;
%     end
%         
%     for idx = 1:channelSample
%         blockSnr = diffList(tttIdx)*randn(numLay, numPrb) + theSnr;
%         [aveMIB, theBLER] = CalMIBvsBLER(modMethod, targetRc, numLay, numPrb, numRe, blockSnr, nSample);
%         figure(1); hold on; grid on; plot(aveMIB, theBLER, colorList(tttIdx)+"*");
%     end
% end
% end
% 
%%
% modMethod = "256QAM"; targetRc = 0.8;
% numLay = 2; numPrb = 8; numRe = 144;
% theTbSize = nrTBS(modMethod, double(numLay), double(numPrb), double(numRe), targetRc);
% info = nrDLSCHInfo(theTbSize, targetRc)
