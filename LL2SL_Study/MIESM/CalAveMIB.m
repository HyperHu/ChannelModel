function aveMIB = CalAveMIB(modMethod, blockSnr)
    if modMethod == "QPSK"
        theQm = 2;
        alpha = [2.0111, 1.5976, 0.4796, 0.4100];
    elseif modMethod == "16QAM"
        theQm = 4;
        alpha = [4.1412, 2.4108, 0.3070, 0.6242];
    elseif modMethod == "64QAM"
        theQm = 6;
        alpha = [6.4501, 2.3305, 0.2093, 0.8524];
    elseif modMethod == "256QAM"
        theQm = 8;
        alpha = [9.4002, 1.4042, 0.1283, 1.5024];
    end

    aveMIB = mean(min(theQm, alpha(1) ./ ((1 + exp(alpha(2) - alpha(3) * blockSnr)) .^ alpha(4))), 'all');
end
