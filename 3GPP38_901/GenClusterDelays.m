function clusterDelays_Sec = GenClusterDelays(numCluster, delaySpread_Sec, propFactor)
% 3GPP 38.901 Equation 7.5-1 ~ 7.5-2
tmpX = rand(1, numCluster);
tao_Pri = -propFactor * delaySpread_Sec * log(tmpX);
minDelay = min(tao_Pri);
clusterDelays_Sec = sort(tao_Pri - minDelay);
end

