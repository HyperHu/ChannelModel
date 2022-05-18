function [gridPos, randomValues] = GenCorrelateRandomGrid(radius_meter, particle_meter,...
                                                          corrDistList, corrCoefMat)
    assert(size(corrCoefMat, 1) == size(corrCoefMat, 2));
    assert(size(corrDistList, 1) == size(corrCoefMat, 1));
    assert(size(corrDistList, 2) == 1);

    nPar = size(corrDistList, 1);
    tmpL = ceil((radius_meter - particle_meter/2) / particle_meter);
    nSize = 2*tmpL+1;
    gridPos = zeros(nSize, nSize, 2);
    gridPos(:, :, 1) = repmat((-tmpL:tmpL) * particle_meter, [nSize 1]);
    gridPos(:, :, 2) = repmat((-tmpL:tmpL)' * -particle_meter, [1 nSize]);

    randomValues = zeros(nSize, nSize, nPar);
    
    % Auto-correlation
    for idxP = 1:nPar
        hHalfD = ceil(5 * corrDistList(idxP) / particle_meter);
        tmpX = kron((-hHalfD:hHalfD), ones([2*hHalfD+1, 1])) * particle_meter;
        tmpY = kron((-hHalfD:hHalfD)', ones([1, 2*hHalfD+1])) * particle_meter;
        tmpD = ((tmpX .^ 2) + (tmpY .^ 2)) .^ 0.5;
        h = exp(-(tmpD ./ corrDistList(idxP)));
        h = h ./ norm(h,'fro');
        
        iidValue = randn(nSize+2*hHalfD, nSize+2*hHalfD);
        randomValues(:, :, idxP) = filter2(h, iidValue, 'valid');
    end
    
    % Cross-correlation
    cMatRoot = chol(corrCoefMat).'; % defined in 3GPP.
    %cMatRoot = sqrtm(corrCoefMat); % in MoRSE
    for idxI = 1:nSize
        for idxJ = 1:nSize
            randomValues(idxI, idxJ, :) = cMatRoot * squeeze(randomValues(idxI, idxJ, :));
        end
    end
    
    doVerify = true;
    if doVerify == true
        % Distribution
        figure(3); hold on; grid on;
        for parIdx = 1:nPar
            histfit(reshape(randomValues(:,:,parIdx), 1, []), 100);
        end
        
        % Auto-correlation
        
        % Cross-correlation
        tmpCov = cov(reshape(randomValues, [], nPar));
        figure(2); hold on; grid on;
        mesh((tmpCov - corrCoefMat) ./ (corrCoefMat + (corrCoefMat == 0) * 1000))
    end
end

