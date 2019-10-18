%% parameter set
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

nFFT = 2048;
kds = 0.2;
win_l = 5;
nSample = 12 * 50;

%%
tmpW = zeros(1, 2*win_l+1);
for idx = -win_l : win_l
    tmpW(idx+win_l+1) = calIciFactor(idx, kds, nFFT);
end

factorMatrix = zeros(nSample);
for idx = 1:nSample
    tmpL = min([2*win_l+1, idx+win_l, (nSample-idx)+win_l+1]);
    tmpS = max(1, win_l+1-(idx-1));
    tmpI = max(1, idx-win_l);
    factorMatrix(idx, tmpI:tmpI+tmpL-1) = tmpW(tmpS:tmpS+tmpL-1);
end
%factorMatrix_inv = inv(factorMatrix);
factorMatrix_inv = factorMatrix';

ttt = mag2db(abs(factorMatrix_inv * factorMatrix));
figure(1);hold on; grid on;
mesh(ttt);

eee = factorMatrix_inv * factorMatrix;
nnn = eee .* (ones(nSample) - eye(nSample));
tmpNoise = sum(abs(factorMatrix_inv) .^ 2);
tmpICI = sum(abs(nnn) .^ 2);
tmpSig = sum(abs(eee .* eye(nSample)) .^ 2);
figure(2);hold on; grid on;
plot(pow2db(tmpSig ./ tmpICI), '*--');
plot(pow2db(tmpSig ./ tmpNoise), 'x--');
