%%
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

rawSNR_dB = -10;
SampleNum = 10000000;

%%
tmpSig = ones(SampleNum, 1);
tmpNoise = (randn(SampleNum, 1) + 1i*randn(SampleNum, 1));
tmpNoise = tmpNoise .* db2mag(-(rawSNR_dB+3));
rcvSig = tmpSig + tmpNoise;

%%
normSig = rcvSig ./ abs(rcvSig);
tmpR = abs(mean(normSig)) .^ 2;
kkk = 1/(log(1/((SampleNum / (SampleNum - 1))*(tmpR - 1/SampleNum))));
tmpX = -pi:0.01:pi;
tmpY = exp(cos(tmpX)*kkk) ./ (2*pi*besseli(0,kkk));
figure(); grid on; hold on;
plot(tmpX, tmpY, '*--');
histogram(angle(rcvSig), -pi:0.01:pi, 'Normalization','pdf');

%%
estSigma = sqrt(log(1/((SampleNum / (SampleNum - 1))*(tmpR - 1/SampleNum))));
tmpXMat = ones(81, 1) * (-pi:0.01:pi);
tmpAng = ((-40:40)*2*pi)' * ones(1, 629);
tmpY = sum(exp(-((tmpAng+tmpX) .^ 2) / (2*estSigma*estSigma)));
tmpY = tmpY ./ (sqrt(estSigma*estSigma*2*pi));
plot(tmpX, tmpY, 'o--');
