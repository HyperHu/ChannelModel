function clusterPowerLos = CompensatePower_LOS(clusterPower, K_factor_dB)
p_LosRay = db2mag(K_factor_dB) / (db2mag(K_factor_dB) + 1);
clusterPowerLos = clusterPower / (db2mag(K_factor_dB) + 1);
clusterPowerLos(1) = clusterPowerLos(1) + p_LosRay;
end

