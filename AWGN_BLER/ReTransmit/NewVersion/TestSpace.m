% %
%clear all;
clearvars;

snrValList = 28:0.1:32;
blerList1 = doTesting(snrValList, 1, "Belief propagation");
blerList2 = doTesting(snrValList, 2, "Belief propagation");
blerList3 = doTesting(snrValList, 3, "Belief propagation");
blerList4 = doTesting(snrValList, 4, "Belief propagation");

figure(1); hold on; grid on;
plot(snrValList, blerList1, '-*');
plot(snrValList, blerList2, '-x');
plot(snrValList, blerList3, '-<');
plot(snrValList, blerList4, '->');


function blerList = doTesting(snrValList, numDec, algo)
    modMethod = "256QAM"; targetRc = double(0.85);
    numLay = int32(1); numPrb = int32(32); numRe = double(12*12);
    nid = int32(1); rnti = int32(1); nSamples = 2000;

    blerList = zeros(size(snrValList));
    for idx = 1:size(snrValList,2)
        snrVal = snrValList(idx);
        theBler = testBler(nid, rnti, modMethod, targetRc, numLay, numPrb, numRe, ...
                           snrVal, nSamples, numDec, 15, algo);
        disp("SNR: " + snrVal + ", BLER: " + theBler);
        blerList(idx) = theBler;
    end
end
