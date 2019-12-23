function clusterAOA = GenClusterAOA(losAOA, clusterPower, ASA, isLos, K_factor_dB)
switch size(clusterPower,2)
    case 4
        compensatePhi = 0.779;
    case 5
        compensatePhi = 0.860;
    case 8
        compensatePhi = 1.018;
    case 10
        compensatePhi = 1.090;
    case 11
        compensatePhi = 1.123;
    case 12
        compensatePhi = 1.146;
    case 14
        compensatePhi = 1.190;
    case 15
        compensatePhi = 1.211;
    case 16
        compensatePhi = 1.226;
    case 19
        compensatePhi = 1.273;
    case 20
        compensatePhi = 1.289;
    otherwise
        assert(0);
end
if isLos == true
    compensatePhi = compensatePhi * (1.1035 - 0.028*K_factor_dB - 0.002*(K_factor_dB^2) + 0.0001*(K_factor_dB^3));
end

phi_Pri = 2*(ASA/1.4)*sqrt(-log(clusterPower / max(clusterPower))) / compensatePhi;
tmpX = 2*randi([0 1], size(phi_Pri)) - 1;
tmpY = randn(size(phi_Pri)) * (ASA/7);
clusterAOA = (tmpX .* phi_Pri) + tmpY + losAOA;

if isLos == true
    tmpDiff = clusterAOA(1) - losAOA;
    clusterAOA = clusterAOA - tmpDiff;
end
end

