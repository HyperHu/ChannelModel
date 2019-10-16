%%
clear all;

%%
nRx = 4;
dd = 0.5;
tmpResult = zeros(180, 180);
for idxI = 1:180
    for idxJ = 1:180
        h1 = exp(-1i * 2*pi * (0:nRx-1)' * cosd(idxI) * dd);
        h2 = exp(-1i * 2*pi * (0:nRx-1)' * cosd(idxJ) * dd);
        tmpH = [h1, h2];
        tmpL = svd(tmpH);
        tmpResult(idxI, idxJ) = tmpL(2) / tmpL(1);
    end
end
 mesh((1:180), (1:180), tmpResult);