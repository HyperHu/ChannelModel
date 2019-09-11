function [iciMat, v, sig] = genRicianIci(nFFT, nSym, powerLoss_dB, kds)
theIciFactor_1 = abs(calIciFactor(-1, abs(kds), nFFT));
theIciFactor_0 = abs(calIciFactor(0, abs(kds), nFFT));
scaler = db2mag(0 - powerLoss_dB);
v = scaler * theIciFactor_1;
sig = scaler * sqrt(1 - theIciFactor_0^2 - theIciFactor_1^2);
iciMat = random('rician', v, sig/sqrt(2), [nFFT, nSym]);
end

