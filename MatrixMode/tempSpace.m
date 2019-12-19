%%
clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

%%
[f1, f2, f3, f4] = GenCoordSysTransformer([0 0 -45]);

for idx = 1:100000
    dirInLCS = [180*rand(1) 180*(2*rand(1) - 1)];
    fcInLCS = rand(1, 2);
    [dirInGCS, fcInGCS] = f4(dirInLCS, fcInLCS);
    [ddd, fff] = f3(dirInGCS, fcInGCS);
    if (norm(dirInLCS - ddd) > 1e-6)
        dirInLCS
        ddd
        assert(0);
    end
    if (norm(fcInLCS - fff) > 1e-6)
        fcInLCS
        fff
        assert(0);
    end
end

%%
% tao = 2;
% nSamples = 5;
% delayMat = circshift(eye(nSamples), -tao, 2);
% 
% pathLoss_dB = 10;
% kappa_dB = 8;
% randomPhase = exp(2j*pi*rand(2));
% N1_Mat = db2mag(-pathLoss_dB) .* [1 db2mag(-kappa_dB); db2mag(-kappa_dB) 1] .* randomPhase;



%%
% TxSIG = ones(64, 8);
% theTrxGain = getTrxGain(0, 1, 8, 'V');
% ttt = kron(TxSIG, theTrxGain);
% 
% theRadPattern_1 = theTrxGain * getRadiationPattern(0, 90, 45, "Mode-1");
% theRadPattern_2 = theTrxGain * getRadiationPattern(0, 90, 45, "Mode-2");
% disp(theRadPattern_2 - theRadPattern_1);


%%
% theTrxGain = getTrxGain(0, 1, 0, 'V');
% slant_deg = 90;
% 
% thetaList = 0:180;
% phiList = -180:180;
% theHPowerMat_mode1 = zeros(size(thetaList, 2), size(phiList, 2));
% theVPowerMat_mode1 = zeros(size(thetaList, 2), size(phiList, 2));
% theHPowerMat_mode2 = zeros(size(thetaList, 2), size(phiList, 2));
% theVPowerMat_mode2 = zeros(size(thetaList, 2), size(phiList, 2));
% for theThetaIdx = 1:size(thetaList, 2)
%     for thePhiIdx = 1:size(phiList, 2)
%         tmpF = theTrxGain * getRadiationPattern(thetaList(theThetaIdx), phiList(thePhiIdx), slant_deg, "Mode-1");
%         theHPowerMat_mode1(size(thetaList, 2)-theThetaIdx+1, thePhiIdx) = pow2db(abs(tmpF(2)) .^ 2);
%         theVPowerMat_mode1(size(thetaList, 2)-theThetaIdx+1, thePhiIdx) = pow2db(abs(tmpF(1)) .^ 2);
%         tmpF = theTrxGain * getRadiationPattern(thetaList(theThetaIdx), phiList(thePhiIdx), slant_deg, "Mode-2");
%         theHPowerMat_mode2(size(thetaList, 2)-theThetaIdx+1, thePhiIdx) = pow2db(abs(tmpF(2)) .^ 2);
%         theVPowerMat_mode2(size(thetaList, 2)-theThetaIdx+1, thePhiIdx) = pow2db(abs(tmpF(1)) .^ 2);
%     end
% end
% 
% azList = -180:180;
% elList = -90:90;
% customAE_1 = phased.CustomAntennaElement('AzimuthAngles',azList, 'ElevationAngles',elList,...
%                                          'SpecifyPolarizationPattern',true,...
%                                          'HorizontalMagnitudePattern',theHPowerMat_mode1,...
%                                          'VerticalMagnitudePattern',theVPowerMat_mode1);
% 
% customAE_2 = phased.CustomAntennaElement('AzimuthAngles',azList, 'ElevationAngles',elList,...
%                                          'SpecifyPolarizationPattern',true,...
%                                          'HorizontalMagnitudePattern',theHPowerMat_mode2,...
%                                          'VerticalMagnitudePattern',theVPowerMat_mode2);
% %%
% fc = 6e9;
% plotAzRange = -180:1:180;
% plotElRange = 85;
% figure(), pattern(customAE_1, fc, plotAzRange, plotElRange, 'Type','powerdb','Polarization','H', 'CoordinateSystem', 'rectangular');
% figure(), pattern(customAE_1, fc, plotAzRange, plotElRange, 'Type','powerdb','Polarization','V', 'CoordinateSystem', 'rectangular');
% figure(), pattern(customAE_2, fc, plotAzRange, plotElRange, 'Type','powerdb','Polarization','H', 'CoordinateSystem', 'rectangular');
% figure(), pattern(customAE_2, fc, plotAzRange, plotElRange, 'Type','powerdb','Polarization','V', 'CoordinateSystem', 'rectangular');
% 
% 
