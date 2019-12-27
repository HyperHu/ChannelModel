function [gridPos_X, gridPos_Y] = BuildCoordinateGrid(posList, delta, sideMargin, forceSquare)

minX = min(posList(:,1)) - sideMargin;
maxX = max(posList(:,1)) + sideMargin;
minY = min(posList(:,2)) - sideMargin;
maxY = max(posList(:,2)) + sideMargin;
if forceSquare == true
    if maxX-minX >= maxY-minY
        tmpDiff = ((maxX-minX) - (maxY-minY)) / 2;
        maxY = maxY + tmpDiff;
        minY = minY - tmpDiff;
    else
        tmpDiff = ((maxY-minY) - (maxX-minX)) / 2;
        maxX = maxX + tmpDiff;
        minX = minX - tmpDiff;
    end
end

gridPos_X = minX:delta:maxX;
gridPos_Y = minY:delta:maxY;
end

