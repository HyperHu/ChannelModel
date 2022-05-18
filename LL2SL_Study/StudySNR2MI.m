%%
clear all;

% tic
% modOrder = 1; %2:QPSK, 4:16QAM, 6:64QAM, 8:256QAM
% [miTable_BPSK, snrTable] = calMutualInformation(modOrder, -50, -30, 0.1);
% toc
% tic
% modOrder = 2; %2:QPSK, 4:16QAM, 6:64QAM, 8:256QAM
% [miTable_QPSK, snrTable] = calMutualInformation(modOrder, -50, 50, 0.2);
% toc
% tic
% modOrder = 4; %2:QPSK, 4:16QAM, 6:64QAM, 8:256QAM
% [miTable_16QAM, snrTable] = calMutualInformation(modOrder, -50, 50, 0.2);
% toc
% tic
% modOrder = 6; %2:QPSK, 4:16QAM, 6:64QAM, 8:256QAM
% [miTable_64QAM, snrTable] = calMutualInformation(modOrder, -50, 50, 0.2);
% toc
% tic
% modOrder = 8; %2:QPSK, 4:16QAM, 6:64QAM, 8:256QAM
% [miTable_256QAM, snrTable] = calMutualInformation(modOrder, -50, 50, 0.2);
% toc

%%
% figure(1); hold on; grid on;
% plot(snrTable, miTable_BPSK, '-*');
% plot(snrTable, miTable_QPSK, '-*');
% plot(snrTable, miTable_16QAM, '-*');
% plot(snrTable, miTable_64QAM, '-*');
% plot(snrTable, miTable_256QAM, '-*');

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
