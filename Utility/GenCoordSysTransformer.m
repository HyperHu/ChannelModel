function [DirToLCS, DirToGCS, FCToLCS, FCToGCS] = GenCoordSysTransformer(ori_deg)
% DirToLCS: Transformer of direction represent in GCS to LCS.
% DirToGCS: Transformer of direction represent in LCS to GCS.
% FCToLCS: Transformer of field component represent in GCS to LCS.
% FCToGCS: Transformer of field component represent in LCS to GCS.
assert(size(ori_deg, 1) == 1);
assert(size(ori_deg, 2) == 3);

DirToLCS = @(dirInGCS) (TransGCSToLCS_Dir(ori_deg, dirInGCS));
DirToGCS = @(dirInLCS) (TransLCSToGCS_Dir(ori_deg, dirInLCS));
FCToLCS = @(dirInGCS, fcInGCS) (TransGCSToLCS_FC(ori_deg, dirInGCS, fcInGCS));
FCToGCS = @(dirInLCS, fcInLCS) (TransLCSToGCS_FC(ori_deg, dirInLCS, fcInLCS));

end

function theR = buildRMat(ori_deg)
oA = ori_deg(1);
oB = ori_deg(2);
oG = ori_deg(3);
theR = [cosd(oA)*cosd(oB) cosd(oA)*sind(oB)*sind(oG)-sind(oA)*cosd(oG) cosd(oA)*sind(oB)*cosd(oG)+sind(oA)*sind(oG);
        sind(oA)*cosd(oB) sind(oA)*sind(oB)*sind(oG)+cosd(oA)*cosd(oG) sind(oA)*sind(oB)*cosd(oG)-cosd(oA)*sind(oG);
        -sind(oB)         cosd(oB)*sind(oG)                            cosd(oB)*cosd(oG)];
end

function dirInLCS = TransGCSToLCS_Dir(ori_deg, dirInGCS)
% Direction: [theta, phi].
assert(size(dirInGCS, 1) == 1);
assert(size(dirInGCS, 2) == 2);

tmpT = dirInGCS(1);
tmpP = dirInGCS(2);
dirInLCS = zeros(size(dirInGCS));

theR = buildRMat(ori_deg);
tmpV = [sind(tmpT)*cosd(tmpP); sind(tmpT)*sind(tmpP); cosd(tmpT)];
tmpV = theR' * tmpV;
dirInLCS(1) = acosd(tmpV(3));
dirInLCS(2) = angle(tmpV(1) + 1j*tmpV(2)) / pi * 180; %(-180, 180]

% tmpV = sind(oB)*cosd(oG)*cosd(tmpP-oA) - sind(oG)*sind(tmpP-oA);
% tmpV = tmpV * sind(tmpT);
% tmpV = tmpV + cosd(oB)*cosd(oG)*cosd(tmpT);
% dirInLCS(1) = acosd(tmpV);
% 
% tmpV = sind(oB)*sind(oG)*cosd(tmpP-oA) + cosd(oG)*sind(tmpP-oA);
% tmpV = tmpV * sind(tmpT);
% tmpV = tmpV + cosd(oB)*sind(oG)*cosd(tmpT);
% tmpV = 1j*tmpV + cosd(oB)*sind(tmpT)*cosd(tmpP-oA) - sind(oB)*cosd(tmpT);
% dirInLCS(2) = angle(tmpV) / pi * 180; %(-180, 180]
end

function dirInGCS = TransLCSToGCS_Dir(ori_deg, dirInLCS)
% Direction: [theta, phi].
assert(size(dirInLCS, 1) == 1);
assert(size(dirInLCS, 2) == 2);

tmpT = dirInLCS(1);
tmpP = dirInLCS(2);
dirInGCS = zeros(size(dirInLCS));

theR = buildRMat(ori_deg);
tmpV = [sind(tmpT)*cosd(tmpP); sind(tmpT)*sind(tmpP); cosd(tmpT)];
tmpV = theR * tmpV;
dirInGCS(1) = acosd(tmpV(3));
dirInGCS(2) = angle(tmpV(1) + 1j*tmpV(2)) / pi * 180; %(-180, 180]
end

function [dirInLCS, fcInLCS, dMat] = TransGCSToLCS_FC(ori_deg, dirInGCS, fcInGCS)
% field component: [theta_Hat, phi_Hat]
assert(size(fcInGCS, 1) == 1);
assert(size(fcInGCS, 2) == 2);

tmpT = dirInGCS(1);
tmpP = dirInGCS(2);
gcsT_Hat = [cosd(tmpT)*cosd(tmpP); cosd(tmpT)*sind(tmpP); -sind(tmpT)];
gcsP_Hat = [-sind(tmpP); cosd(tmpP); 0];

dirInLCS = TransGCSToLCS_Dir(ori_deg, dirInGCS);
tmpT = dirInLCS(1);
tmpP = dirInLCS(2);
lcsT_Hat = [cosd(tmpT)*cosd(tmpP); cosd(tmpT)*sind(tmpP); -sind(tmpT)];
lcsP_Hat = [-sind(tmpP); cosd(tmpP); 0];

theR = buildRMat(ori_deg)';
tmpMat = [lcsT_Hat' * theR * gcsT_Hat, lcsT_Hat' * theR * gcsP_Hat;
          lcsP_Hat' * theR * gcsT_Hat, lcsP_Hat' * theR * gcsP_Hat];
fcInLCS = fcInGCS * (tmpMat');
dMat = (tmpMat');
end

function [dirInGCS, fcInGCS, dMat] = TransLCSToGCS_FC(ori_deg, dirInLCS, fcInLCS)
% field component: [theta_Hat, phi_Hat]
assert(size(fcInLCS, 1) == 1);
assert(size(fcInLCS, 2) == 2);

tmpT = dirInLCS(1);
tmpP = dirInLCS(2);
lcsT_Hat = [cosd(tmpT)*cosd(tmpP); cosd(tmpT)*sind(tmpP); -sind(tmpT)];
lcsP_Hat = [-sind(tmpP); cosd(tmpP); 0];

dirInGCS = TransLCSToGCS_Dir(ori_deg, dirInLCS);
tmpT = dirInGCS(1);
tmpP = dirInGCS(2);
gcsT_Hat = [cosd(tmpT)*cosd(tmpP); cosd(tmpT)*sind(tmpP); -sind(tmpT)];
gcsP_Hat = [-sind(tmpP); cosd(tmpP); 0];

theR = buildRMat(ori_deg);
tmpMat = [gcsT_Hat' * theR * lcsT_Hat, gcsT_Hat' * theR * lcsP_Hat;
          gcsP_Hat' * theR * lcsT_Hat, gcsP_Hat' * theR * lcsP_Hat];
fcInGCS = fcInLCS * (tmpMat');
dMat = (tmpMat');
end
