function [corrMat] = CalCorrMat(inputMat, winX, winY)
%CALCORRMAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[sizeX, sizeY] = size(inputMat);
corrMat = zeros(winX, winY);
meanVal = std(inputMat, 0, 'all');
inputMatConj = conj(inputMat);
for idxX = 1:winX
    for idxY = 1:winY
        tmpA = inputMat(1:(sizeX-idxX+1), 1:(sizeY-idxY+1));
        tmpB = inputMatConj((1+idxX-1):sizeX, (1+idxY-1):sizeY);
        corrMat(idxX, idxY) = mean(tmpA .* tmpB, 'all') / meanVal;
    end
end
end

