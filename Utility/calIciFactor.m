 function theIciFactor = calIciFactor(d, kds, nFFT)
    kTotal = d + kds;
    if abs(kTotal) > 0.000001
        theIciFactor = (exp(1i * pi * kTotal * (1-1/nFFT)) / nFFT);
        theIciFactor = theIciFactor * sin(pi * kTotal) / sin(pi * kTotal / nFFT);
    else
        theIciFactor = 1;
    end
end