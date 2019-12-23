function clusterDelaysLos_Sec = CompensateDelay_LOS(clusterDelays_Sec, K_factor_dB)
% 3GPP 38.901 Equation 7.5-3
compensateTao = 0.7705 - 0.0433*(K_factor_dB^1) + 0.0002*(K_factor_dB^2) + 0.000017*(K_factor_dB^3);
clusterDelaysLos_Sec = clusterDelays_Sec ./ compensateTao;
end

