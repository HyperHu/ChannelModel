function clusterZOD = GenClusterZOD(losZOD, clusterPower, ZSD, isLos, K_factor_dB, muOffset)
switch size(clusterPower,2)
    case 8
        compensateTheta = 0.889;
    case 10
        compensateTheta = 0.957;
    case 11
        compensateTheta = 1.031;
    case 12
        compensateTheta = 1.104;
    case 15
        compensateTheta = 1.1088;
    case 19
        compensateTheta = 1.184;
    case 20
        compensateTheta = 1.178;
    otherwise
        assert(0);
end
if isLos == true
    compensateTheta = compensateTheta * (1.3086 + 0.0339*K_factor_dB - 0.0077*(K_factor_dB^2) + 0.0002*(K_factor_dB^3));
end

theta_Pri = -ZSD*log(clusterPower / max(clusterPower)) / compensateTheta;
tmpX = 2*randi([0 1], size(theta_Pri)) - 1;
tmpY = randn(size(theta_Pri)) * (ZSD/7);
clusterZOD = (tmpX .* theta_Pri) + tmpY + losZOD + muOffset;

if isLos == true
    tmpDiff = clusterZOD(1) - losZOD;
    clusterZOD = clusterZOD - tmpDiff;
end
end

