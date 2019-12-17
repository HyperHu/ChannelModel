function theRadPattern = getRadiationPattern(theta_deg, phi_deg, slant_deg, polaMode)
% theta_deg, phi_deg is defined in LCS of antenna pannel (the pannel is in yoz plane). 
% slant_deg (clock-wise) = 0 means a purely vertically antenna element. 
% slant_deg = +45 means \. -45 means /.

if (polaMode == "Mode-1")
    tmpT = acosd(cosd(0)*cosd(slant_deg)*cosd(theta_deg) + (sind(0)*cosd(slant_deg)*cosd(phi_deg - 0) - sind(slant_deg)*sind(phi_deg - 0))*sind(theta_deg));
    tmpP = angle((cosd(0)*sind(theta_deg)*cosd(phi_deg - 0) - sind(0)*cosd(theta_deg)) + 1i*(cosd(0)*sind(slant_deg)*cosd(theta_deg) + (sind(0)*sind(slant_deg)*cosd(phi_deg - 0) + cosd(slant_deg)*sind(phi_deg - 0))*sind(theta_deg))) / pi * 180;
elseif (polaMode == "Mode-2")
    tmpT = theta_deg;
    tmpP = phi_deg;
end

assert(0 <= tmpT);
assert(tmpT <= 180);
assert(-180 <= tmpP);
assert(tmpP <= 180);

aVir = -min(12*(((tmpT - 90)/65)^2), 30);
aHor = -min(12*((tmpP/65)^2), 30);
tmpA = db2pow(-min(-(aVir + aHor), 30));
%tmpA = 1;

if (polaMode == "Mode-1")
    pasi = angle((sind(slant_deg)*cosd(theta_deg)*sind(phi_deg - 0) + cosd(slant_deg)*(cosd(0)*sind(theta_deg) - sind(0)*cosd(theta_deg)*cosd(phi_deg - 0))) + 1i*(sind(slant_deg)*cosd(phi_deg - 0) + sind(0)*cosd(slant_deg)*sind(phi_deg - 0))) / pi * 180;
elseif (polaMode == "Mode-2")
    pasi = slant_deg;
end

theRadPattern = sqrt(tmpA) .* [cosd(pasi) +sind(pasi);
                               -sind(pasi) cosd(pasi)];
end

