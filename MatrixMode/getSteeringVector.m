function steeringVector = getSteeringVector(aePosition, cFreq_Hz, gcs_direction_deg)
assert(size(aePosition,2) == 3);
tmpT = gcs_direction_deg(1);
tmpP = gcs_direction_deg(2);
waveNumber = 2*pi*cFreq_Hz/299792458;
waveVector = waveNumber .* [sind(tmpT) .* cosd(tmpP);
                            sind(tmpT) .* sind(tmpP);
                            cosd(tmpT)];

steeringVector = exp(-1j .* (aePosition * waveVector));
end

