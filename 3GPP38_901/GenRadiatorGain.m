function radiatorGainCalculator = GenRadiatorGain(radiatorType)

    switch radiatorType
        case {'Ideal'}
            radiatorGainCalculator = @(theta_deg, phi_deg)(gCal_Ideal(theta_deg, phi_deg));
        case {'SectorUniform'}
            radiatorGainCalculator = @(theta_deg, phi_deg)(gCal_SectorUniform(theta_deg, phi_deg));
        case {'3GPP'}
            radiatorGainCalculator = @(theta_deg, phi_deg)(gCal_3GPP(theta_deg, phi_deg));
    end
end


function radGain_dB = gCal_Ideal(~, ~)
    radGain_dB = 0;
end

function radGain_dB = gCal_SectorUniform(~, phi_deg)
    if abs(phi_deg) <= 60.5
        radGain_dB = 0;
    else
        radGain_dB = -10000;
    end
end

function radGain_dB = gCal_3GPP(theta_deg, phi_deg)
    aVir = -min(12*(((theta_deg - 90)/65)^2), 30);
    aHor = -min(12*((phi_deg/65)^2), 30);
    radGain_dB = -min(-(aVir + aHor), 30);
end
