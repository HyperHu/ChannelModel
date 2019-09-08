function thePhaseFactor = calPhaseFactor(nFFT, n0, phi0, nTao, kds, distD)
    w = 2*pi/nFFT;
    w_k = (-w*nTao) .* ((distD : (distD+nFFT-1))' - nFFT/2);
    w_l = (w*kds) .* n0;
    thePhaseFactor = exp(1i .* (phi0 + (w_k * w_l)));
end

