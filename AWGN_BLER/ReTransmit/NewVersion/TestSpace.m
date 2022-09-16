% %
% %clear all;
% clearvars;
% 
% snrValList = 28:0.1:32;
% blerList1 = doTesting(snrValList, 1, "Belief propagation");
% blerList2 = doTesting(snrValList, 2, "Belief propagation");
% blerList3 = doTesting(snrValList, 3, "Belief propagation");
% blerList4 = doTesting(snrValList, 4, "Belief propagation");
% 
% figure(1); hold on; grid on;
% plot(snrValList, blerList1, '-*');
% plot(snrValList, blerList2, '-x');
% plot(snrValList, blerList3, '-<');
% plot(snrValList, blerList4, '->');
% 
% 
% function blerList = doTesting(snrValList, numDec, algo)
%     modMethod = "256QAM"; targetRc = double(0.85);
%     numLay = int32(1); numPrb = int32(32); numRe = double(12*12);
%     nid = int32(1); rnti = int32(1); nSamples = 2000;
% 
%     blerList = zeros(size(snrValList));
%     for idx = 1:size(snrValList,2)
%         snrVal = snrValList(idx);
%         theBler = testBler(nid, rnti, modMethod, targetRc, numLay, numPrb, numRe, ...
%                            snrVal, nSamples, numDec, 15, algo);
%         disp("SNR: " + snrVal + ", BLER: " + theBler);
%         blerList(idx) = theBler;
%     end
% end

%%
clearvars;

testCodeRate = [0.30078125	0.423828125	0.6015625	0.504882813	0.650390625	0.802734375	0.736328125	0.864257813	0.92578125];
testModMethod = ["QPSK", "16QAM", "16QAM", "64QAM", "64QAM", "64QAM", "256QAM", "256QAM", "256QAM"];
testMinSnr = [-5, 2, 6, 9, 12, 15, 19, 22, 24];

blerResult = zeros(9, 21);
for itemIdx = 1:9
    snrValList = testMinSnr(itemIdx) : 0.25 : (testMinSnr(itemIdx)+5);
    for idx = 1:size(snrValList,2)
        snrVal = snrValList(idx);
        theBler = testBler(1, 1, testModMethod(itemIdx), testCodeRate(itemIdx), 1, 64, 120, ...
                           snrVal, 100, 1, 50, "Belief propagation");
        disp("SNR: " + snrVal + ", BLER: " + theBler);
        blerResult(itemIdx, idx) = theBler;
    end
end
