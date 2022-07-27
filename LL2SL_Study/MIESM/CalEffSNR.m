function effSNR = CalEffSNR(modMethod, aveMIB)
    if modMethod == "QPSK"
        alpha = [2.0111, 1.5976, 0.4796, 0.4100];
    elseif modMethod == "16QAM"
        alpha = [4.1412, 2.4108, 0.3070, 0.6242];
    elseif modMethod == "64QAM"
        alpha = [6.4501, 2.3305, 0.2093, 0.8524];
    elseif modMethod == "256QAM"
        alpha = [9.4002, 1.4042, 0.1283, 1.5024];
    end

    effSNR = (alpha(2) - log((alpha(1) / aveMIB) .^ (1 / alpha(4)) - 1)) / alpha(3);
end
