% %
clear all;
clearvars;

modMethod = "QPSK"; targetRc = double(0.75);
numLay = int32(1); numPrb = int32(16); numRe = double(12*12);
nid = int32(1); rnti = int32(1);
nSamples = 1000;

snrValList1 = 4.0:0.1:6.0; blerList1 = zeros(size(snrValList1));
for idx = 1:size(snrValList1,2)
    snrVal = snrValList1(idx);
    theBler = testBler(nid, rnti, modMethod, targetRc, numLay, numPrb, numRe, ...
                       snrVal, nSamples, 1);
    disp("SNR: " + snrVal + ", BLER: " + theBler);
    blerList1(idx) = theBler;
end

snrValList2 = 0.0:0.1:2.0; blerList2 = zeros(size(snrValList2));
for idx = 1:size(snrValList2,2)
    snrVal = snrValList2(idx);
    theBler = testBler(nid, rnti, modMethod, targetRc, numLay, numPrb, numRe, ...
                       snrVal, nSamples, 2);
    disp("SNR: " + snrVal + ", BLER: " + theBler);
    blerList2(idx) = theBler;
end

snrValList3 = -1.0:0.1:1.0; blerList3 = zeros(size(snrValList3));
for idx = 1:size(snrValList3,2)
    snrVal = snrValList3(idx);
    theBler = testBler(nid, rnti, modMethod, targetRc, numLay, numPrb, numRe, ...
                       snrVal, nSamples, 3);
    disp("SNR: " + snrVal + ", BLER: " + theBler);
    blerList3(idx) = theBler;
end

snrValList4 = -2.0:0.1:0.0; blerList4 = zeros(size(snrValList4));
for idx = 1:size(snrValList4,2)
    snrVal = snrValList4(idx);
    theBler = testBler(nid, rnti, modMethod, targetRc, numLay, numPrb, numRe, ...
                       snrVal, nSamples, 4);
    disp("SNR: " + snrVal + ", BLER: " + theBler);
    blerList4(idx) = theBler;
end

figure(1); hold on; grid on;
plot(snrValList1, blerList1, '-*');
plot(snrValList2, blerList2, '-x');
plot(snrValList3, blerList3, '-<');
plot(snrValList4, blerList4, '->');
