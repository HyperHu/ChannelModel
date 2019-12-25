function [gridPos, gridLsp] = GenLspGrid(radius_meter, particle_meter, corrDistList, corrCoefMat)
assert(size(corrCoefMat, 1) == size(corrCoefMat, 2));
assert(size(corrDistList, 1) == size(corrCoefMat, 1));
assert(size(corrDistList, 2) == 1);

nPar = size(corrDistList, 1);
tmpL = ceil((radius_meter - particle_meter/2) / particle_meter);
nSize = 2*tmpL+1;
gridPos = zeros(nSize, nSize, 2);
gridPos(:, :, 1) = repmat((-tmpL:tmpL) * particle_meter, [nSize 1]);
gridPos(:, :, 2) = repmat((-tmpL:tmpL)' * -particle_meter, [1 nSize]);

gridTlsp = zeros(nSize, nSize, nPar);
% Auto-correlation
for idxP = 1:nPar
    hHalfD = ceil(2 * corrDistList(idxP) / particle_meter);
    tmpX = kron((-hHalfD:hHalfD), ones([2*hHalfD+1, 1])) * particle_meter;
    tmpY = kron((-hHalfD:hHalfD)', ones([1, 2*hHalfD+1])) * particle_meter;
    tmpD = ((tmpX .^ 2) + (tmpY .^ 2)) .^ 0.5;
    h = exp(-(tmpD ./ corrDistList(idxP)));
    h = h ./ norm(h);
    
    iidValue = randn(nSize+2*hHalfD, nSize+2*hHalfD);
    gridTlsp(:, :, idxP) = filter2(h, iidValue, 'valid');
end

% Cross-correlation
cMatRoot = chol(corrCoefMat);
for idxI = 1:nSize
    for idxJ = 1:nSize
        gridTlsp(idxI, idxJ, :) = cMatRoot * squeeze(gridTlsp(idxI, idxJ, :));
    end
end

% Transform from TLSP to LSP.
% In order  [SF, K, DS, ASD, ASA, ZSD, ZSA]
gridLsp = zeros(nSize, nSize, nPar);

muSF_dB = 0;
sigmaSF_dB = 7;
gridLsp(:, :, 1) = muSF_dB + gridTlsp(:, :, 1) * sigmaSF_dB;

muK_dB = 9;
sigmaK_dB = 5;
gridLsp(:, :, 2) = muK_dB + gridTlsp(:, :, 2) * sigmaK_dB;

muLogDS = -6.62;
sigmaLogDS = 0.32;
gridLsp(:, :, 3) = power(10, muLogDS + gridTlsp(:, :, 3) * sigmaLogDS);

muLogASD = 1.25;
sigmaLogASD = 0.42;
gridLsp(:, :, 4) = power(10, muLogASD + gridTlsp(:, :, 4) * sigmaLogASD);
gridLsp(:, :, 4) = min(gridLsp(:, :, 4), 104);

muLogASA = 1.76;
sigmaLogASA = 0.16;
gridLsp(:, :, 5) = power(10, muLogASA + gridTlsp(:, :, 5) * sigmaLogASA);
gridLsp(:, :, 5) = min(gridLsp(:, :, 5), 104);

muLogZSD = 1.08;
sigmaLogZSD = 0.36;
gridLsp(:, :, 6) = power(10, muLogZSD + gridTlsp(:, :, 6) * sigmaLogZSD);
gridLsp(:, :, 6) = min(gridLsp(:, :, 6), 52);

muLogZSA = 1.01;
sigmaLogZSA = 0.43;
gridLsp(:, :, 7) = power(10, muLogZSA + gridTlsp(:, :, 7) * sigmaLogZSA);
gridLsp(:, :, 7) = min(gridLsp(:, :, 7), 52);

end

