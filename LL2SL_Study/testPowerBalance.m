%%
clear all;

% 
sinrList = 1:100;
resultMap = zeros(size(sinrList,2), size(sinrList,2));
powerShiftMap = zeros(size(sinrList,2), size(sinrList,2));
for idx1 = 1:size(sinrList,2)
    for idx2 = idx1:size(sinrList,2)
        [diffMib, powerShift] = findBestPowerShift(sinrList(idx2), sinrList(idx1));
        resultMap(idx1, idx2) = diffMib;
        powerShiftMap(idx1, idx2) = powerShift;
    end
end

figure(1); mesh(sinrList, sinrList, resultMap);
figure(2); mesh(sinrList, sinrList, powerShiftMap);

% findBestPowerShift(5, 1);

%%
function [diffMib, powerShift] = findBestPowerShift(sinr1, sinr2)
load('MyCalculation_New.mat');
theMiTable = miTable_256QAM;
aveMib = 0.0;
if sinr1 >= 50.0
    aveMib = aveMib + 8;
else
    aveMib = aveMib + theMiTable(find(snrTable > sinr1, 1));
end
if sinr2 >= 50.0
    aveMib = aveMib + 8;
else
    aveMib = aveMib + theMiTable(find(snrTable > sinr2, 1));
end
aveMib = aveMib / 2;

noise1 = db2pow(-sinr1); noise2 = db2pow(-sinr2);
powerShiftList = 0.05:0.01:0.95;
newAveMib = zeros(size(powerShiftList));
for idx = 1:size(powerShiftList,2)
    power1 = 1 - powerShiftList(idx);
    power2 = 1 + powerShiftList(idx);
    sinr1_new = pow2db(power1 / noise1);
    sinr2_new = pow2db(power2 / noise2);

    tmpMib = 0.0;
    if sinr1_new >= 50.0
        tmpMib = tmpMib + 8;
    else
        tmpMib = tmpMib + theMiTable(find(snrTable > sinr1_new, 1));
    end
    if sinr2_new >= 50.0
        tmpMib = tmpMib + 8;
    else
        tmpMib = tmpMib + theMiTable(find(snrTable > sinr2_new, 1));
    end
    newAveMib(idx) = (tmpMib/2) - aveMib;
end
[diffMib, tmpIdx] = max(newAveMib);
diffMib = diffMib / aveMib;
powerShift = powerShiftList(tmpIdx);
%figure(); plot(powerShiftList, newAveMib, '-*');
end
