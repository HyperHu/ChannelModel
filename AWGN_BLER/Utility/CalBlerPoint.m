function [aveTbBler, aveCbBler] = CalBlerPoint(seIdx, nPrb, nSymbol, snrdB1, snrdB2)   
    nSample = 1000; nIterMax = 30; muList = tinv(0.99, 1:nIterMax);
    tbBlerSamples = zeros(1,nIterMax); cbBlerSamples = zeros(1,nIterMax);
    
    nIter = 0;
    while true
        [theTbBler, theCbBler] = calBler(seIdx, nPrb, nSymbol, snrdB1, snrdB2, nSample);
        nIter = nIter + 1; tbBlerSamples(nIter) = theTbBler; cbBlerSamples(nIter) = theCbBler;
        if (nIter < 15)
            continue;
        end

        varTbBler = var(tbBlerSamples(1:nIter)); varCbBler = var(cbBlerSamples(1:nIter));
        sigmaTb = muList(nIter) * sqrt(varTbBler / nIter); sigmaCb = muList(nIter) * sqrt(varCbBler / nIter);
        if (nIter >= nIterMax) || (max(sigmaTb, sigmaCb) < 0.01)
            break;
        end
    end
    aveTbBler = mean(tbBlerSamples(1:nIter)); aveCbBler = mean(cbBlerSamples(1:nIter));
    fprintf('cfg: [ %d %d %d ] SINR: [ %.2f %.2f ] TBBLER: %.4f [ %.4f %.4f %.4f ] CBBLER: %.4f [ %.4f %.4f %.4f ] N: %d\n',...
            seIdx, nPrb, nSymbol, snrdB1, snrdB2,...
            aveTbBler, aveTbBler-sigmaTb, aveTbBler+sigmaTb, sigmaTb,...
            aveCbBler, aveCbBler-sigmaCb, aveCbBler+sigmaCb, sigmaCb, nIter);

end

