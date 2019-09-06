%%
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

snrList = -20:0.5:20;
sigmaResult = zeros(1, size(snrList,2));
for idx = 1:size(snrList,2)
    sigmaResult(idx) = calPhaseNoise(snrList(idx));
end
plot(snrList, sigmaResult / pi, '*--'); grid on;

%%
function sigmaPhase = calPhaseNoise(rawSNR_dB)
    SampleNum = 500000;
    tmpSig = ones(SampleNum, 1);
    tmpNoise = (randn(SampleNum, 1) + 1i*randn(SampleNum, 1));
    tmpNoise = tmpNoise .* db2mag(-(rawSNR_dB+3));
    rcvSig = tmpSig + tmpNoise;
    sigmaPhase = sqrt(mean(angle(rcvSig) .^ 2));
end

%%
% normSig = rcvSig ./ abs(rcvSig);
% tmpR = abs(mean(normSig)) .^ 2;
% kkk = 1/(log(1/((SampleNum / (SampleNum - 1))*(tmpR - 1/SampleNum))));
% tmpX = -pi:0.01:pi;
% tmpY = exp(cos(tmpX)*kkk) ./ (2*pi*besseli(0,kkk));
% figure(); grid on; hold on;
% plot(tmpX, tmpY, '*--');
% histogram(angle(rcvSig), -pi:0.01:pi, 'Normalization','pdf');
% 
% %%
% estSigma = sqrt(log(1/((SampleNum / (SampleNum - 1))*(tmpR - 1/SampleNum))));
% tmpXMat = ones(81, 1) * (-pi:0.01:pi);
% tmpAng = ((-40:40)*2*pi)' * ones(1, 629);
% tmpY = sum(exp(-((tmpAng+tmpX) .^ 2) / (2*estSigma*estSigma)));
% tmpY = tmpY ./ (sqrt(estSigma*estSigma*2*pi));
% plot(tmpX, tmpY, 'o--');


%%
% SampleNum = 10000000;
% sigmaP = 3;
% zList = exp(1i * randn(SampleNum, 1) * sigmaP);
% 
% tmpR = abs(mean(zList)) .^ 2;
% kkk = 1/(log(1/((SampleNum / (SampleNum - 1))*(tmpR - 1/SampleNum))));
% tmpX = -pi:0.01:pi;
% tmpY = exp(cos(tmpX)*kkk) ./ (2*pi*besseli(0,kkk));
% figure(); grid on; hold on;
% plot(tmpX, tmpY, '*--');
% histogram(angle(zList), -pi:0.01:pi, 'Normalization','pdf');
% estSigma = sqrt(log(1/((SampleNum / (SampleNum - 1))*(tmpR - 1/SampleNum))));
% tmpXMat = ones(81, 1) * (-pi:0.01:pi);
% tmpAng = ((-40:40)*2*pi)' * ones(1, 629);
% tmpY = sum(exp(-((tmpAng+tmpX) .^ 2) / (2*estSigma*estSigma)));
% tmpY = tmpY ./ (sqrt(estSigma*estSigma*2*pi));
% plot(tmpX, tmpY, 'o--');
