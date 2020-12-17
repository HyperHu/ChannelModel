clear all;
addpath(pwd + "\..");
addpath(pwd + "\..\Utility");

scenario = 'UMi';
interSiteDistance_meter = 100; hUT_meter = 1.5; hBS_meter = 10;
Fc_Hz = 3.5*1e9;

%% Site Position
normSitePosition = [0, 0;
                    1, 0; 0.5, sqrt(3)/2; -0.5, sqrt(3)/2;
                    -1, 0; -0.5, -sqrt(3)/2; 0.5, -sqrt(3)/2];

downtilt_deg = 65;
sectorDirct_deg = [0; 120; 240];
% sectorDirct_deg = [30; 150; 270];

showSiteFigure = false;
if showSiteFigure == true
    figure(1); hold on; grid on; plot(normSitePosition(:,1), normSitePosition(:,2), 'o');
    for siteIdx = 1:size(normSitePosition,1)
        for sectorIdx = 1:size(sectorDirct_deg,1)
            x0 = normSitePosition(siteIdx, 1); y0 = normSitePosition(siteIdx, 2);
            dx = 0.1*cosd(sectorDirct_deg(sectorIdx)); dy = 0.1*sind(sectorDirct_deg(sectorIdx));
            plot([x0, x0 + dx], [y0, y0 + dy], 'k');
        end
    end
end

numOfSite = size(normSitePosition, 1);
numOfSector = size(sectorDirct_deg, 1);
numOfCell = numOfSite * numOfSite;
sitePosition = interSiteDistance_meter .* normSitePosition;
[nodePos_X, nodePos_Y] = BuildCoordinateGrid(sitePosition, 1, interSiteDistance_meter, true);

%% Pathloss
plCalculator_LOS = GenPathLoss(scenario, true, Fc_Hz, hUT_meter, hBS_meter);
pathlossMap = cell([1, numOfSite]);
for siteIdx = 1:numOfSite
    pathlossMap{siteIdx} = ones(size(nodePos_X, 2), size(nodePos_Y, 2)) * 1000;
    for idxX = 1:size(nodePos_X,2)
        for idxY = 1:size(nodePos_Y,2)
            dx = nodePos_X(idxX) - sitePosition(siteIdx, 1);
            dy = nodePos_Y(idxY) - sitePosition(siteIdx, 2);
            dz = hUT_meter - hBS_meter;
            dist3D_meter = sqrt(dx^2 + dy^2 + dz^2);
            pathlossMap{siteIdx}(idxX, idxY) = plCalculator_LOS(dist3D_meter);
        end
    end
end

showPathlossFigure = false;
if showPathlossFigure == true
    figure(2); contour(nodePos_X, nodePos_Y, pathlossMap{1}.'); grid on;
end

%% Antenna Gain (radiator gain + beamforming gain)
radGainCalculator = GenRadiatorGain('3GPP');
antGainMap = cell([1, numOfCell]);
for siteIdx = 1:numOfSite
    for sectorIdx = 1:numOfSector
        cellIdx = (siteIdx - 1) * numOfSector + sectorIdx;
        antGainMap{cellIdx} = zeros(size(nodePos_X, 2), size(nodePos_Y, 2));
        [DirToLCS, ~, ~, ~] = GenCoordSysTransformer([sectorDirct_deg(sectorIdx) downtilt_deg 0]);
        for idxX = 1:size(nodePos_X,2)
            for idxY = 1:size(nodePos_Y,2)
                dx = nodePos_X(idxX) - sitePosition(siteIdx, 1);
                dy = nodePos_Y(idxY) - sitePosition(siteIdx, 2);
                dz = hUT_meter - hBS_meter;
                [azimuth,elevation,~] = cart2sph(dx,dy,dz);
                gcsDirect = [(pi/2 - elevation) / pi * 180, azimuth / pi * 180];
                lcsDirect = DirToLCS(gcsDirect);
                
                % Radiator Gain
                theRadGain = radGainCalculator(lcsDirect(1), lcsDirect(2));
                
                % Beamforming Gain
                theBeamGain = 0;
                
                antGainMap{cellIdx}(idxX, idxY) = theRadGain + theBeamGain;
            end
        end
    end
end

%% Cell Layout
totalLossMap = ones(size(nodePos_X, 2), size(nodePos_Y, 2)) * 1000;
siteIdxMap = zeros(size(nodePos_X, 2), size(nodePos_Y, 2));
cellIdxMap = zeros(size(nodePos_X, 2), size(nodePos_Y, 2));
for idxX = 1:size(nodePos_X,2)
    for idxY = 1:size(nodePos_Y,2)
        for siteIdx = 1:numOfSite
            for sectorIdx = 1:numOfSector
                cellIdx = (siteIdx - 1) * numOfSector + sectorIdx;
                theTotalLoss = pathlossMap{siteIdx}(idxX, idxY) - antGainMap{cellIdx}(idxX, idxY);
                if theTotalLoss < totalLossMap(idxX, idxY)
                    totalLossMap(idxX, idxY) = theTotalLoss;
                    siteIdxMap(idxX, idxY) = siteIdx;
                    cellIdxMap(idxX, idxY) = mod(siteIdx,2)*20 + sectorIdx*50;
                end
            end
        end
    end
end

showSiteLayoutFigure = true;
if showSiteLayoutFigure == true
    figure(); hold on; grid on; contourf(nodePos_X, nodePos_Y, cellIdxMap.');
    plot(sitePosition(:,1), sitePosition(:,2), 'ko');
    for siteIdx = 1:numOfSite
        for sectorIdx = 1:numOfSector
            x0 = sitePosition(siteIdx, 1); y0 = sitePosition(siteIdx, 2);
            dx = 0.2*cosd(sectorDirct_deg(sectorIdx)); dy = 0.2*sind(sectorDirct_deg(sectorIdx));
            dx = interSiteDistance_meter * dx; dy = interSiteDistance_meter * dy;
            plot([x0, x0 + dx], [y0, y0 + dy], 'k');
        end
    end
    tttX = [0, 0.5, 1.5, 2, 1.5, 0.5, 0] * interSiteDistance_meter / 3;
    tttY = [0, -sqrt(3)/2, -sqrt(3)/2, 0, sqrt(3)/2, sqrt(3)/2, 0] * interSiteDistance_meter / 3;
    plot(tttX, tttY, 'k');
    axis square;
end

%%
clear all;
scenario = 'UMi';
hUT_meter = 1.5; hBS_meter = 20;
Fc_Hz = 3.5*1e9;
downtilt_deg = 10;

plCalculator_LOS = GenPathLoss(scenario, true, Fc_Hz, hUT_meter, hBS_meter);
radGainCalculator = GenRadiatorGain('3GPP');
[DirToLCS, ~, ~, ~] = GenCoordSysTransformer([60 downtilt_deg 0]);
distList = 1:0.25:500; totalLoss = zeros(size(distList)); plLoss = zeros(size(distList));
for idx = 1:size(distList,2)
    dL = distList(idx); dH = hUT_meter - hBS_meter;
    [azimuth,elevation,~] = cart2sph(dL, 0, dH);
    gcsDirect = [(pi/2 - elevation) / pi * 180, azimuth / pi * 180];
    lcsDirect = DirToLCS(gcsDirect);
    theRadGain = radGainCalculator(lcsDirect(1), lcsDirect(2));
    plLoss(idx) = plCalculator_LOS(sqrt(dL^2 + dH^2));
    totalLoss(idx) = plLoss(idx) - theRadGain;
end

plot(distList, totalLoss); hold on; grid on;
plot(distList, plLoss, '--'); hold on; grid on;
