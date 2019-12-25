%% Parameters Set
clear all;

particle_meter = 50;
scenario = 'RMa';
Fc_Hz = 3*1e9;
hBS_meter = 35;
hUT_meter = 1.5;

%% Cell Layout
intersiteDistance_meter = 5000;

% sitePosition_meter = [0 0];
% sitePosition_meter = [1, 0;
%                       2, 0;
%                       0.5, sqrt(3)/2;
%                       1.5, sqrt(3)/2;
%                       2.5, sqrt(3)/2;
%                       1, sqrt(3);
%                       2, sqrt(3)] * intersiteDistance_meter;
sitePosition_meter = [0,    0;
                      1,    0;
                      0.5,  sqrt(3)/2;
                      -0.5, sqrt(3)/2;
                      -1,   0;
                      -0.5, -sqrt(3)/2;
                      0.5,  -sqrt(3)/2] * intersiteDistance_meter;
numSite = size(sitePosition_meter, 1);

sectorDirct_deg = [0; 120; 240];
%sectorDirct_deg = [30; 150; 270];


%% Pathloss Map
tmpX = ceil((max(sitePosition_meter(:,1)) - min(sitePosition_meter(:,1)) + 2*intersiteDistance_meter) / particle_meter);
tmpY = ceil((max(sitePosition_meter(:,2)) - min(sitePosition_meter(:,2)) + 2*intersiteDistance_meter) / particle_meter);
nodePosition_X = ((0:tmpX) + floor((min(sitePosition_meter(:,1))-intersiteDistance_meter) / particle_meter)) * particle_meter;
nodePosition_Y = ((0:tmpY) + floor((min(sitePosition_meter(:,2))-intersiteDistance_meter) / particle_meter)) * particle_meter;
pathlossMap_LOS_dB = ones(size(nodePosition_X,2), size(nodePosition_Y,2)) * 1000;
pathlossMap_NLOS_dB = ones(size(nodePosition_X,2), size(nodePosition_Y,2)) * 1000;
siteIdMap = zeros(size(nodePosition_X,2), size(nodePosition_Y,2));
cellIdMap = zeros(size(nodePosition_X,2), size(nodePosition_Y,2));
pathLossCalculator_LOS = GenPathLoss(scenario, true, Fc_Hz, hUT_meter, hBS_meter);
for idxX = 1:size(nodePosition_X,2)
    for idxY = 1:size(nodePosition_Y,2)
        for idxSite = 1:numSite
            d3D = sqrt((nodePosition_X(idxX) - sitePosition_meter(idxSite,1))^2 + (nodePosition_Y(idxY) - sitePosition_meter(idxSite,2))^2 + (hBS_meter - hUT_meter)^2);
            tmpV = pathLossCalculator_LOS(d3D);
%             if tmpV < pathlossMap_LOS_dB(idxX, idxY)
%                 pathlossMap_LOS_dB(idxX, idxY) = tmpV;
%                 siteIdMap(idxX, idxY) = idxSite;
%             end
            
            tmpTheta = 90 - 0 + asind((hBS_meter-hUT_meter) / d3D);
            tmpPhi = angle(nodePosition_X(idxX) - sitePosition_meter(idxSite,1) + 1j*(nodePosition_Y(idxY) - sitePosition_meter(idxSite,2))) / pi * 180;
            if tmpPhi < 0
                tmpPhi = tmpPhi + 360;
            end
            for sectorIdx = 1:3
                ppp = mod(tmpPhi-sectorDirct_deg(sectorIdx)+360, 360);
                if ppp >= 180
                    ppp = ppp - 360;
                end
                AntLoss_dB = min(-(-min(12*((tmpTheta - 90)/65)^2, 30) + -min(12*(ppp/65)^2, 30)), 30);
%                 if abs(ppp) < 65
%                     AntLoss_dB = 0;
%                 else
%                     AntLoss_dB = 100;
%                 end
                if (abs(imag(AntLoss_dB)) > 0.0001)
                    assert(0);
                end
                if (tmpV + AntLoss_dB) < pathlossMap_LOS_dB(idxX, idxY)
                    pathlossMap_LOS_dB(idxX, idxY) = tmpV + AntLoss_dB;
                    siteIdMap(idxX, idxY) = idxSite;
                    cellIdMap(idxX, idxY) = idxSite*3 + sectorIdx;
                end
            end
        end
    end
end

figure(); mesh(nodePosition_X, nodePosition_Y, pathlossMap_LOS_dB'); hold on;
figure(); mesh(nodePosition_X, nodePosition_Y, siteIdMap'); hold on;
figure(); mesh(nodePosition_X, nodePosition_Y, cellIdMap'); hold on;


%%

%%
% numSite = 1;
% siteCoverRadius_meter = 100;
% particle_meter = 5;
% 
% 
% 
% %% Large Scale Parameters
% 
% %% Step 4: Generate large scale parameters.
% % In order  [SF, K, DS, ASD, ASA, ZSD, ZSA]
% corrDistList = [10, 15, 7, 8, 8, 12, 12]';
% corrCoefMat = [1.0 	0.5 	-0.4 	-0.5 	-0.4 	0.0 	0.0;
%                0.5 	1.0 	-0.7 	-0.2 	-0.3 	0.0 	0.0;
%               -0.4 	-0.7	1.0 	0.5 	0.8 	0.0 	0.2;
%               -0.5 	-0.2 	0.5 	1.0 	0.4 	0.5 	0.3;
%               -0.4 	-0.3 	0.8 	0.4 	1.0 	0.0 	0.0;
%                0.0 	0.0 	0.0 	0.5 	0.0 	1.0 	0.0;
%                0.0 	0.0 	0.2 	0.3 	0.0 	0.0 	1.0];
% 
% [gridPos, gridLsp] = GenLspGrid(siteCoverRadius_meter, particle_meter,...
%                                 corrDistList, corrCoefMat);