function theTrxGain = getTrxGain(pMax_dBm, effTotal, theDirectivity_dB, polaType)

tmpV = effTotal * db2pow(theDirectivity_dB) * db2pow(pMax_dBm - 30);

% [theta_Hat phi_Hat] in 3GPP 38.901
switch (polaType)
    case 'V'
        theTrxGain = [1 0];
    case 'H'
        theTrxGain = [0 1];
    case 'L'
        theTrxGain = [1 -1i] .* sqrt(0.5);
    case 'R'
        theTrxGain = [1 1i] .* sqrt(0.5);
end

theTrxGain = sqrt(tmpV) .* theTrxGain;
end

