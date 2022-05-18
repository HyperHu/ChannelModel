%%
clear all;

tic
modOrder = 1; %1: BPSK
[miTable_BPSK, snrTable_BPSK] = calMutualInformation(modOrder, -25, 15, 0.1);
plot(snrTable_BPSK, miTable_BPSK, '-*'); grid on;
toc

tic
modOrder = 2; %2:QPSK
[miTable_QPSK, snrTable_QPSK] = calMutualInformation(modOrder, -25, 20, 0.1);
plot(snrTable_QPSK, miTable_QPSK, '-*'); grid on;
toc

tic
modOrder = 4; %4:16QAM
[miTable_16QAM, snrTable_16QAM] = calMutualInformation(modOrder, -25, 25, 0.1);
plot(snrTable_16QAM, miTable_16QAM, '-*'); grid on;
toc

tic
modOrder = 6; %6:64QAM
[miTable_64QAM, snrTable_64QAM] = calMutualInformation(modOrder, -25, 30, 0.1);
plot(snrTable_64QAM, miTable_64QAM, '-*'); grid on;
toc

tic
modOrder = 8; %8:256QAM
[miTable_256QAM, snrTable_256QAM] = calMutualInformation(modOrder, -25, 35, 0.1);
plot(snrTable_256QAM, miTable_256QAM, '-*'); grid on;
toc

%%
function [miTable, snrTable] = calMutualInformation(modOrder, minSNR, maxSNR, stepSNR)
    numTestSamples = 1000 * 1000 * 1000;
    snrTable = minSNR : stepSNR : maxSNR;
    miTable = zeros(size(snrTable));

    numConstellation = 2 ^ modOrder;
    symbolSet = qammod(0:numConstellation-1, numConstellation, 'UnitAveragePower', true);

    for i = 1:modOrder
        for b = 0:1
            tempZSum = zeros(size(snrTable));
            
            subSymbolSet = zeros(1, 2^(modOrder-1)); tmpIdx = 1;
            for zIdx = 1:size(symbolSet,2)
                if bitand(zIdx-1, 2^(i-1)) == b*(2^(i-1))
                    subSymbolSet(tmpIdx) = symbolSet(zIdx);
                    tmpIdx = tmpIdx + 1;
                end
            end
            assert(tmpIdx == 2^(modOrder-1)+1);

            for zIdx = 1:size(subSymbolSet,2)
                zSymbol = subSymbolSet(1,zIdx);
                for snrIdx = 1:size(snrTable,2)
                    theY = (randn([numTestSamples, 1]) + 1j*randn([numTestSamples, 1])) / sqrt(2);
                    ttt = db2mag(snrTable(snrIdx));
                    tmpA = sum(exp(-(abs(theY - ttt*(symbolSet - zSymbol)) .^ 2)), 2);
                    tmpB = sum(exp(-(abs(theY - ttt*(subSymbolSet - zSymbol)) .^ 2)), 2);
                    tempZSum(snrIdx) = tempZSum(snrIdx) + mean(log2(tmpA ./ tmpB));
                end
            end
            
            miTable = miTable + tempZSum;
        end
    end

    miTable = modOrder - miTable / (numConstellation);
end
