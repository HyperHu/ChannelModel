function clusterPower = GenClusterPowers(clusterDelays_Sec, delaySpread_Sec, propFactor, stdShadowing_dB)
Zeta = randn(size(clusterDelays_Sec)) * stdShadowing_dB;
p_Pri = exp(-clusterDelays_Sec .* ((propFactor-1)/(propFactor*delaySpread_Sec))) .* db2pow(-Zeta);
p_linear = p_Pri ./ sum(p_Pri);
clusterPower = p_linear;
end

