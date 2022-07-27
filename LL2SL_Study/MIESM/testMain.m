%%
clearvars;

%%
% modMethod = "16QAM"; targetRc = 0.25; numLay = 1; numPrb = 16; numRe = 144;
% fadingMu = [0;]; fadingSig = [0;]; aveSnrList = 1.0:0.1:3.0;
% nSample = 10; nTest = 1000; skipRange = [1.8, 2.7];

modMethod = "256QAM"; targetRc = 0.8; numLay = 1; numPrb = 8; numRe = 144;
fadingMu = [0;]; fadingSig = [6;]; aveSnrList = 19:0.1:25;
nSample = 5; nTest = 20; skipRange = [20, 22];

[effSNRList, blerSampleList, diffList] = GenBlerSamples(modMethod, targetRc, numLay, numPrb, numRe, ...
                                                        fadingMu, fadingSig, aveSnrList, nSample, nTest, skipRange);

figure(1); hold on; grid on;
%plot(effSNRList, blerSampleList, 'r*');
plot3(effSNRList, diffList(:,1), blerSampleList, 'r*');

figure(2); hold on; grid on;
plot3(effSNRList, diffList(:,2), blerSampleList, 'r*');

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
