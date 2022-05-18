function [blerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, nSymbol, snrdB_List, midIdx)
    thT = 0.25; blerCurve = zeros(size(snrdB_List)); cbBlerCurve = zeros(size(snrdB_List));

    tmpIdx = midIdx;
    while true
        tmpSnr = snrdB_List(tmpIdx);
        [aveTbBler, aveCbBler] = CalBlerPoint(seIdx, nPrb, nSymbol, tmpSnr, tmpSnr);
        blerCurve(tmpIdx) = aveTbBler; cbBlerCurve(tmpIdx) = aveCbBler; tmpIdx = tmpIdx + 1;
        if (aveCbBler < thT)
            break;
        end
    end

    tmpIdx = midIdx - 1;
    while true
        tmpSnr = snrdB_List(tmpIdx);
        [aveTbBler, aveCbBler] = CalBlerPoint(seIdx, nPrb, nSymbol, tmpSnr, tmpSnr);
        blerCurve(tmpIdx) = aveTbBler; cbBlerCurve(tmpIdx) = aveCbBler; tmpIdx = tmpIdx - 1;
        if (1 - aveCbBler) < thT
            break;
        end
    end
    blerCurve(1:tmpIdx) = 1; cbBlerCurve(1:tmpIdx) = 1;
end

