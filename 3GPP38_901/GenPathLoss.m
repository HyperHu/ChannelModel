function pathLossCalculator = GenPathLoss(scenario, isLOS, fc_hz, hUT, hBS)

switch scenario
    case {'RMa'}
        if (isLOS)
            pathLossCalculator = @(d_3D)(plCal_RMa_LOS(d_3D, fc_hz, hUT, hBS, 5));
        else
            pathLossCalculator = @(d_3D)(plCal_RMa_NLOS(d_3D, fc_hz, hUT, hBS, 5, 20));
        end
    case {'UMi'}
        if (isLOS)
            pathLossCalculator = @(d_3D)(plCal_UMi_LOS(d_3D, fc_hz, hUT, 10));
        else
            pathLossCalculator = @(d_3D)(plCal_UMi_NLOS(d_3D, fc_hz, hUT, 10));
        end
    case {'UMa'}
        if (isLOS)
            pathLossCalculator = @(d_3D, hE)(plCal_UMa_LOS(d_3D, fc_hz, hUT, 25, hE));
        else
            pathLossCalculator = @(d_3D, hE)(plCal_UMa_NLOS(d_3D, fc_hz, hUT, 25, hE));
        end
    case {'Indoor'}
        if (isLOS)
            pathLossCalculator = @(d_3D)(plCal_Indoor_LOS(d_3D, fc_hz));
        else
            pathLossCalculator = @(d_3D)(plCal_Indoor_NLOS(d_3D, fc_hz));
        end
end

end

function d_BP_dot = CalBreakPoint_dot(fc, hUT, hBS, hE)
    d_BP_dot = 4 * (hBS - hE) * (hUT - hE) * fc / (3.0e8);
end

function d_BP = CalBreakPoint(fc, hUT, hBS)
    d_BP = 2 * pi * hBS * hUT * fc / (3.0e8);
end

function pathLoss = plCal_RMa_LOS(d_3D, fc, hUT, hBS, h)
    assert(fc <= 7*1e9);
    d_3D = min(max(10, d_3D), 10000);
    d_2D = sqrt((d_3D .^  2) - ((hBS - hUT) ^2));
    d_2D = min(max(10, d_2D), 10000);
    d_BP = CalBreakPoint(fc, hUT, hBS);
    tmp1 = d_2D <= d_BP;
    tmp2 = d_2D > d_BP;
    PL1 = 20*log10(40*pi*fc/3e9 * d_3D) + min(0.03 * h^1.72, 10) * log10(d_3D) - min(0.044 * h^1.72, 14.77) + 0.002*log10(h)*d_3D;
    tmpV = 20*log10(40*pi*fc/3e9 * d_BP) + min(0.03 * h^1.72, 10) * log10(d_BP) - min(0.044 * h^1.72, 14.77) + 0.002*log10(h)*d_BP;
    PL2 = tmpV + 40*log10(d_3D ./ d_BP);
    pathLoss = PL1 .* tmp1 + PL2 .* tmp2;
end

function pathLoss = plCal_RMa_NLOS(d_3D, fc, hUT, hBS, h, W)
    d_3D = min(max(10, d_3D), 5000);
    plLos = plCal_RMa_LOS(d_3D, fc, hUT, hBS, h);
    plTmp = 161.04 - 7.1*log10(W) + 7.5*log10(h) - (24.37-3.7*((h/hBS)^2))*log10(hBS) + (43.42-3.1*log10(hBS)).*(log10(d_3D) - 3) + 20*log10(fc/1e9) - (3.2*(log10(11.75*hUT)^2)) + 4.97;
    pathLoss = max(plLos, plTmp);
end

function pathLoss = plCal_UMa_LOS(d_3D, fc, hUT, hBS, hE)
    d_3D = min(max(10, d_3D), 5000);
    d_2D = sqrt((d_3D .^  2) - ((hBS - hUT) ^2));
    d_2D = min(max(10, d_2D), 5000);
    d_BP_dot = CalBreakPoint_dot(fc, hUT, hBS, hE);
    tmp1 = d_2D <= d_BP_dot;
    tmp2 = d_2D > d_BP_dot;
    PL1 = 28.0 + 22*log10(d_3D) + 20*log10(fc/1e9);
    PL2 = 28.0 + 40*log10(d_3D) + 20*log10(fc/1e9) - 9*log10(d_BP_dot ^ 2 + (hBS - hUT) ^2);
    pathLoss = PL1 .* tmp1 + PL2 .* tmp2;
end

function pathLoss = plCal_UMa_NLOS(d_3D, fc, hUT, hBS, hE)
    d_3D = min(max(10, d_3D), 5000);
    plLos = plCal_UMa_LOS(d_3D, fc, hUT, hBS, hE);
    plTmp = 13.54 + 39.08*log10(d_3D) + 20*log(fc/1e9) - 0.6*(hUT - 1.5);
    pathLoss = max(plLos, plTmp);
end

function pathLoss = plCal_UMi_LOS(d_3D, fc, hUT, hBS)
    d_3D = min(max(10, d_3D), 5000);
    d_2D = sqrt((d_3D .^  2) - ((hBS - hUT) ^2));
    d_2D = min(max(10, d_2D), 5000);
    d_BP_dot = CalBreakPoint_dot(fc, hUT, hBS, 1);
    tmp1 = d_2D <= d_BP_dot;
    tmp2 = d_2D > d_BP_dot;
    PL1 = 32.4 + 21*log10(d_3D) + 20*log10(fc/1e9);
    PL2 = 32.4 + 40*log10(d_3D) + 20*log10(fc/1e9) - 9.5*log10(d_BP_dot ^ 2 + (hBS - hUT) ^2);
    pathLoss = PL1 .* tmp1 + PL2 .* tmp2;
end

function pathLoss = plCal_UMi_NLOS(d_3D, fc, hUT, hBS)
    d_3D = min(max(10, d_3D), 5000);
    plLos = plCal_UMi_LOS(d_3D, fc, hUT, hBS);
    plTmp = 22.4 + 35.3*log10(d_3D) + 21.3*log(fc/1e9) - 0.3*(hUT - 1.5);
    pathLoss = max(plLos, plTmp);
end

function pathLoss = plCal_Indoor_LOS(d_3D, fc)
    d_3D = min(max(1, d_3D), 150);
    pathLoss = 32.4 + 17.3*log10(d_3D) + 20*log10(fc/1e9);
end

function pathLoss = plCal_Indoor_NLOS(d_3D, fc)
    d_3D = min(max(1, d_3D), 150);
    plLos = plCal_Indoor_LOS(d_3D, fc);
    plTmp = 17.3 + 38.3*log10(d_3D) + 24.9*log10(fc/1e9);
    pathLoss = max(plLos, plTmp);
end
