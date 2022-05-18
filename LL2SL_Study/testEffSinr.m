clearvars;
load('MyCalculation_New.mat');



selectTable = miTable_64QAM;
%figure(); hold on; grid on; plot(snrTable, selectTable, '*');

diffMib = selectTable(2:end) - selectTable(1:end-1);
tmpTale = selectTable(1:end-1) + ((diffMib/20) .* (0:19)');
selectTable = reshape(tmpTale, 1, []);
diffSnr = snrTable(2:end) - snrTable(1:end-1);
tmpTale = snrTable(1:end-1) + ((diffSnr/20) .* (0:19)');
snrTable = reshape(tmpTale, 1, []);
%plot(snrTable, selectTable, '.');

%%

snrPoint = 20;
%for snrPoint = 20:-4:0
gapList = 0:2:20;
effSnr = zeros(size(gapList));
aveSnrLin = zeros(size(gapList));
for idx = 1:size(gapList,2)
    snr1 = snrPoint + gapList(idx)/2;
    mib1 = selectTable(find(snrTable > snr1, 1));
    snr2 = snrPoint - gapList(idx)/2;
    mib2 = selectTable(find(snrTable > snr2, 1));
    aveMib = (mib1 + mib2)/2;
    effSnr(idx) = snrTable(find(selectTable >= aveMib, 1));
    aveSnrLin(idx) = pow2db(db2pow(snr1) + db2pow(snr2)) - pow2db(2);
end

figure(2); hold on; grid on;
plot(gapList, effSnr, '-*');
plot(gapList, aveSnrLin, '--');

%end
