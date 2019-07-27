%%
clear all;

mu = 1;
numPRB = 273;
simulationTimeMs = 5; %ms;
subFrameDuration = 1 * 1e-3;    % 1ms
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
nFFT = 2 ^ ceil(log2(numPRB * 12));
nData = numPRB * 12;
sampleRate = nFFT * subCarriarSpace;

%%
oriData = genRandomQPSKData(nData, numSymbolPerSubFrame*simulationTimeMs);
timeSigTx = FreqToTime(oriData, mu);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% One Ray %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
rcvDataViaTime = TimeToFreq(throughChannel_OneRay_TimeSig(timeSigTx, ...
                 sampleRate, 0, (100/sampleRate)*1e9, 1000, pi), mu, nData);
[rcvDataViaFreq, noICIDataViaFreq] = throughChannel_OneRay_FreqSym(...
                 oriData, mu, 0, (100/sampleRate)*1e9, 1000, pi);
rcvDataViaCh0 = calChannelH([0, (100/sampleRate)*1e9, 1000, pi],...
                 0, mu, nData, simulationTimeMs) .* oriData;

%%
figure(11); hold on; grid on;
histogram(reshape(abs(rcvDataViaTime - rcvDataViaFreq), 1, []), 100); 
mean(mean(abs(rcvDataViaTime - rcvDataViaFreq)))
histogram(reshape(abs(rcvDataViaTime - noICIDataViaFreq), 1, []), 100);
mean(mean(abs(rcvDataViaTime - noICIDataViaFreq)))
%histogram(reshape(abs(noICIDataViaFreq - rcvDataViaCh0), 1, []), 100);
mean(mean(abs(noICIDataViaFreq - rcvDataViaCh0)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Multi Ray %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
rayList = genRandomRay(20, 0, (100/sampleRate)*1e9, 5*1000, 2*pi);

sumTimeSig = zeros(1, sampleRate * subFrameDuration*simulationTimeMs);
rcvDataViaFreq = zeros(nData, numSymbolPerSubFrame*simulationTimeMs);
noICIDataViaFreq = zeros(nData, numSymbolPerSubFrame*simulationTimeMs);
for rayIdx = 1 : size(rayList, 1)
    sumTimeSig = sumTimeSig + throughChannel_OneRay_TimeSig(timeSigTx, ...
                     sampleRate, rayList(rayIdx, 1), rayList(rayIdx, 2),...
                     rayList(rayIdx, 3), rayList(rayIdx, 4));
    [tmpDate, tmpNoICI, ~] = throughChannel_OneRay_FreqSym(...
                     oriData, mu, rayList(rayIdx, 1), rayList(rayIdx, 2),...
                     rayList(rayIdx, 3), rayList(rayIdx, 4));
    rcvDataViaFreq = rcvDataViaFreq + tmpDate;
    noICIDataViaFreq = noICIDataViaFreq + tmpNoICI;
end
rcvDataViaTime = TimeToFreq(sumTimeSig, mu, nData);

theChannel_0 = calChannelH(rayList, 0, mu, nData, simulationTimeMs);
rcvDataViaCh0 = theChannel_0 .* oriData;

figure(21); hold on; grid on;
histogram(reshape(abs(rcvDataViaTime - rcvDataViaFreq), 1, []), 100);
mean(mean(abs(rcvDataViaTime - rcvDataViaFreq)))
histogram(reshape(abs(rcvDataViaTime - noICIDataViaFreq), 1, []), 100);
mean(mean(abs(rcvDataViaTime - noICIDataViaFreq)))
figure(22); hold on; grid on;
histogram(reshape(abs(noICIDataViaFreq - rcvDataViaCh0), 1, []), 100);
mean(mean(abs(noICIDataViaFreq - rcvDataViaCh0)))

%%
tmpData_Time = rcvDataViaTime ./ oriData;
tmpData_Freq = rcvDataViaFreq ./ oriData;
tmpData_H = theChannel_0;

figure(31); hold on; grid on;
corrDataTime = CalCorrMat(tmpData_Time, 200, 30);
mesh(abs(corrDataTime));

figure(32); hold on; grid on;
corrDataH = CalCorrMat(tmpData_H, 200, 30);
mesh(abs(corrDataH));

figure(33); hold on; grid on;
corrDataIci = CalCorrMat(tmpData_Freq-tmpData_H, 200, 30);
mesh(abs(corrDataIci));
