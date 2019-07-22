function [qpskData] = genRandomQPSKData(nData, nSym)

DataI = (1 - 2 * randi((0:1), nData, nSym));
DataQ = 1i * (1 - 2 * randi((0:1), nData, nSym));
qpskData = (DataI + DataQ) / sqrt(2);

% DataI = ones(nData, nSym);
% DataQ = 1i * zeros(nData, nSym);
% qpskData = (DataI + DataQ) / sqrt(1);

end

