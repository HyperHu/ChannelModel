function theRadPattern = getRadiationPattern(lcs_direction_deg)
% theta_deg, phi_deg is defined in LCS of antenna element. 
tmpT = lcs_direction_deg(1);
tmpP = lcs_direction_deg(2);

assert(0 <= tmpT);
assert(tmpT <= 180);
assert(-180 <= tmpP);
assert(tmpP <= 180);

aVir = -min(12*(((tmpT - 90)/65)^2), 30);
aHor = -min(12*((tmpP/65)^2), 30);
theRadPattern = db2mag(-min(-(aVir + aHor), 30));
end

