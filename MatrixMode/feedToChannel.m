function chOUT = feedToChannel(chIN, theRay)

% An ray can be character by
% powerLoss_dB: 
% delay_sample:
% freqShift_rad:
% initPhase_rad [2, 2]:
% XPR_dB:
% aod_deg\zod_deg:
% aoa_deg\zoa_deg:

assert(size(chIN,2) == 2);  %[F_theta, F_Phi]

delayMat = circshift(eye(size(chIN,1)), -theRay.delay_sample, 2);
tmpMat = exp(1j * theRay.initPhase_rad);
tmpMat = tmpMat .* [1 db2mag(-theRay.XPR_dB); db2mag(-theRay.XPR_dB) 1];
tmpMat = db2mag(-theRay.pathLoss_dB) .* tmpMat;
freqShiftMat = repmat(exp((0:size(chIN,1)-1)' .* (1j * theRay.freqShift_rad)), [1 2]);

chOUT = (delayMat * chIN * tmpMat) .* freqShiftMat;
end

