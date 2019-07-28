function [corrMat] = CalCorrMat(inputMat, winX, winY, dX, dY)
%CALCORRMAT 此处显示有关此函数的摘要
%   此处显示详细说明
[sizeX, sizeY] = size(inputMat);
corrMat = zeros(winX, winY);
meanVal = std(inputMat, 0, 'all');
inputMatConj = conj(inputMat);
for idxX = 1:winX
    for idxY = 1:winY
        distX = (idxX - 1) * dX;
        distY = (idxY - 1) * dY;
        tmpA = inputMat(1:(sizeX-distX), 1:(sizeY-distY));
        tmpB = inputMatConj((distX+1):sizeX, (distY+1):sizeY);
        corrMat(idxX, idxY) = mean((tmpA .* tmpB), 'all') / meanVal;
    end
end
end

