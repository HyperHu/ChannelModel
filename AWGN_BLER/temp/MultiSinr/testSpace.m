%%
clear all;
load("SINR2I.mat");
tmpX = SINR2I(2:300,1); tmpXX = db2mag(tmpX);
tmpY = SINR2I(2:300,2) - SINR2I(1:300-1,2);
%cftool(tmpXX, tmpY);
tmpXXX = db2mag(min(tmpX):0.01:max(tmpX));
estY = 0.02623*(tmpXXX.*exp(tmpXXX.^2 ./ -3.149)) .^ 1.803;
estY = estY / sum(estY) *sum(tmpY);
%plot(tmpXXX,estY); grid on;
tmpXXXX = mag2db(tmpXXX);
% figure(1); hold on; grid on; plot(tmpXXXX,estY*(max(tmpY) / max(estY))); plot(tmpX, tmpY, '*-');

lookTable_X = tmpXXXX; lookTable_Y = zeros(size(lookTable_X));
lookTable_Y(1) = SINR2I(2,2);
for idx = 2:size(lookTable_Y,2)
    lookTable_Y(idx) = lookTable_Y(idx-1) + estY(idx-1);
end
lookTable_X = [lookTable_X 30]; lookTable_Y = [lookTable_Y 2];
% figure(2); hold on; grid on; plot(lookTable_X, lookTable_Y); plot(SINR2I(:,1),SINR2I(:,2));

%%
load("blerMatQPSK_PRB8_SYM9.mat");
dataSet_X = snrdB_List(497:571); dataSet_Y = snrdB_List(497:571);
dataSet_Z = cbBlerMatrix(8,497:571);

dataSet_X = [dataSet_X snrdB_List(718:773)]; dataSet_Y = [dataSet_Y snrdB_List(718:773)];
dataSet_Z = [dataSet_Z cbBlerMatrix(12,718:773)];

dataSet_X = [dataSet_X snrdB_List(908:953)]; dataSet_Y = [dataSet_Y snrdB_List(908:953)];
dataSet_Z = [dataSet_Z cbBlerMatrix(16,908:953)];

load("TTTResult.mat"); endIdx = 132;
dataSet_X = [dataSet_X reshape((tmpSinr1(1:endIdx) + zeros(5,1)), 1, []) reshape(tmpSinr2(:, 2:endIdx), 1, [])];
dataSet_Y = [dataSet_Y reshape(tmpSinr2(:, 1:endIdx), 1, []) reshape((tmpSinr1(2:endIdx) + zeros(5,1)), 1, [])];
dataSet_Z = [dataSet_Z reshape(tmpResult(:, 1:endIdx), 1, []) reshape(tmpResult(:, 2:endIdx), 1, [])];

load("MoreResult.mat"); endIdx = 61;
dataSet_X = [dataSet_X reshape(tmpSinr1(:, 1:endIdx), 1, []) reshape(tmpSinr2(:, 2:endIdx), 1, [])];
dataSet_Y = [dataSet_Y reshape(tmpSinr2(:, 1:endIdx), 1, []) reshape(tmpSinr1(:, 2:endIdx), 1, [])];
dataSet_Z = [dataSet_Z reshape(tmpResult(:, 1:endIdx), 1, []) reshape(tmpResult(:, 2:endIdx), 1, [])];

load("MoreResult_SE12.mat"); endIdx = 61;
dataSet_X = [dataSet_X reshape(tmpSinr1(:, 1:endIdx), 1, []) reshape(tmpSinr2(:, 2:endIdx), 1, [])];
dataSet_Y = [dataSet_Y reshape(tmpSinr2(:, 1:endIdx), 1, []) reshape(tmpSinr1(:, 2:endIdx), 1, [])];
dataSet_Z = [dataSet_Z reshape(tmpResult(:, 1:endIdx), 1, []) reshape(tmpResult(:, 2:endIdx), 1, [])];

load("MoreResult_SE16.mat"); endIdx = 61;
dataSet_X = [dataSet_X reshape(tmpSinr1(:, 1:endIdx), 1, []) reshape(tmpSinr2(:, 2:endIdx), 1, [])];
dataSet_Y = [dataSet_Y reshape(tmpSinr2(:, 1:endIdx), 1, []) reshape(tmpSinr1(:, 2:endIdx), 1, [])];
dataSet_Z = [dataSet_Z reshape(tmpResult(:, 1:endIdx), 1, []) reshape(tmpResult(:, 2:endIdx), 1, [])];

load("tmpTest.mat");
dataSet_X = [dataSet_X tmpSinr1 tmpSinr2];
dataSet_Y = [dataSet_Y tmpSinr2 tmpSinr1];
dataSet_Z = [dataSet_Z tmpResult tmpResult];

%cftool(dataSet_X, dataSet_Y, dataSet_Z);

%%
% Linear Average
effX_Lin = pow2db((db2pow(dataSet_X) + db2pow(dataSet_Y)) / 2);

% dB Average
effX_dB = (dataSet_X + dataSet_Y) / 2;

% MIB Average
effX_MIB = zeros(size(dataSet_X));
for idx = 1:size(dataSet_X, 2)
    tmpI_1 = lookTable_Y(find(lookTable_X >= dataSet_X(idx), 1));
    tmpI_2 = lookTable_Y(find(lookTable_X >= dataSet_Y(idx), 1));
    tmpI_ave = (tmpI_1 + tmpI_2) / 2;
    effX_MIB(idx) = lookTable_X(find(lookTable_Y >= tmpI_ave, 1));
end

figure(); hold on; grid on;
plot(effX_Lin, dataSet_Z, '*'); plot(effX_dB, dataSet_Z, 'x'); plot(effX_MIB, dataSet_Z, 'o');

%%
% effI_X = zeros(1, size(dataSet_X,2)-75); effI_Y = zeros(1, size(dataSet_Y,2)-75);
% effI_Z = zeros(1, size(dataSet_Z,2)-75);
% for idx = 76:size(dataSet_X, 2)
%     effI_X(idx-75) = lookTable_Y(find(lookTable_X >= dataSet_X(idx), 1));
%     effI_Y(idx-75) = lookTable_Y(find(lookTable_X >= dataSet_Y(idx), 1));
%     tmpSinr = dataSet_X(find(dataSet_Z(1:75) <= dataSet_Z(idx), 1));
%     if size(tmpSinr,2) > 0
%         effI_Z(idx-75) = lookTable_Y(find(lookTable_X >= tmpSinr, 1));
%     else
%         effI_Z(idx-75) = nan;
%     end
% end
% 
% cftool(effI_X, effI_Y, effI_Z);
% 
nrTimingEstimate