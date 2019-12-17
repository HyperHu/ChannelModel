function steeringVector = getSteeringVector(aePosition, cFreq_Hz, theta_deg, phi_deg)

waveNumber = 2*pi*cFreq_Hz/299792458;
waveVector = waveNumber .* [sind(theta_deg) .* cosd(phi_deg);
                            sind(theta_deg) .* sind(phi_deg);
                            cosd(theta_deg)];

steeringVector = exp(-1j .* (aePosition * waveVector));
end

