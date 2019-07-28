%%
clear all;

mu = 1;
numPRB = 273;
simulationTimeMs = 50; %ms;
subFrameDuration = 1 * 1e-3;    % 1ms
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
nFFT = 2 ^ ceil(log2(numPRB * 12));
nData = numPRB * 12;
sampleRate = nFFT * subCarriarSpace;

oriData = genRandomQPSKData(nData, numSymbolPerSubFrame * simulationTimeMs);
timeSigTx = FreqToTime(oriData, mu);

%%
diffPRB = 20;
diffSlot = 5;
corrDataTimeTotal = zeros(diffPRB, diffSlot);
corrDataHTotal = zeros(diffPRB, diffSlot);
testNum = 20;
for loop = 1:testNum
loop
rayList = genRandomRay(10, 0, (100/sampleRate)*1e9, 1*1000, 2*pi);
% sumTimeSig = zeros(1, sampleRate * subFrameDuration * simulationTimeMs);
% for rayIdx = 1 : size(rayList, 1)
%     sumTimeSig = sumTimeSig + throughChannel_OneRay_TimeSig(timeSigTx, ...
%                      sampleRate, rayList(rayIdx, 1), rayList(rayIdx, 2),...
%                      rayList(rayIdx, 3), rayList(rayIdx, 4));
% end
% rcvDataViaTime = TimeToFreq(sumTimeSig, mu, nData);
% tmpData_Time = rcvDataViaTime ./ oriData;
% corrDataTime = CalCorrMat(tmpData_Time, diffSubCarrier, diffSymbol);
% corrDataTimeTotal = corrDataTimeTotal + corrDataTime;

tmpData_H = calChannelH(rayList, 0, mu, nData, simulationTimeMs);
corrDataH = CalCorrMat(tmpData_H, diffPRB, diffSlot, 6, 7);
corrDataHTotal = corrDataHTotal + corrDataH;

end

% figure(1); hold on; grid on;
% mesh(abs(corrDataTimeTotal ./ testNum));

figure(2); hold on; grid on;
mesh(abs(corrDataHTotal ./ testNum));
