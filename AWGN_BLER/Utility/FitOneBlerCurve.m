function [theB, theC, theErr, estBler, snrPoint] = FitOneBlerCurve(snrSet, blerSet, theMethod, showFigure)
    theMargin = 0.05;
    idxS = find(blerSet < (1-theMargin), 1, 'first'); idxE = find(blerSet > (0+theMargin), 1, 'last');
    [estMu, estSigma] = CoarseFit(snrSet(idxS:idxE), blerSet(idxS:idxE));
    
    snrPoint = -15:0.001:30;
    switch theMethod
        case 1
            [theB, theC, estBler] = fitMethod_1(estMu, estSigma, snrPoint);
        case 2
            [theB, theC, estBler] = fitMethod_2(estMu, estSigma, snrPoint,...
                                                snrSet(idxS:idxE), blerSet(idxS:idxE));
        case 3
            [theB, theC, estBler] = fitMethod_3(estMu, estSigma, snrPoint,...
                                                snrSet(idxS:idxE), blerSet(idxS:idxE));
        case 4
            [theB, theC, estBler] = fitMethod_4(estMu, estSigma, snrPoint,...
                                                snrSet(idxS:idxE), blerSet(idxS:idxE));
    end
    
    % cal error
    tmpIdx = 1 + (idxS-1:idxE-1) * floor((snrSet(2)-snrSet(1)) / (snrPoint(2) - snrPoint(1)));
    theErr = sqrt(mean((blerSet(idxS:idxE) - estBler(tmpIdx)) .^ 2));
    
    % show figure
    if showFigure > 0
        figure(showFigure); hold on; grid on;
        plot(snrSet, blerSet, 'x'); plot(snrPoint, estBler, '--');
        
        figure(showFigure+1); hold on; grid on;
        plot(snrSet(idxS:idxE), blerSet(idxS:idxE) - estBler(tmpIdx), 'x-');
        
        figure(showFigure+2); hold on; grid on;
        plot((snrSet(idxS:idxE) - theB) / (3*theC), blerSet(idxS:idxE) - estBler(tmpIdx), '.');
        
        figure(showFigure+3); hold on; grid on;
        plot(snrSet(idxS+1:idxE), blerSet(idxS:idxE-1)-blerSet(idxS+1:idxE), '.');
        plot(snrPoint(tmpIdx(2:end)), estBler(tmpIdx(1:end-1)) - estBler(tmpIdx(2:end)), '--');
    end
end

function [estMu, estSigma] = CoarseFit(snrSet, blerSet)
    tmpX = snrSet(2:end); tmpY = blerSet(1:end-1) - blerSet(2:end);
    gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [0.05 mean(tmpX) 0.25];
    fff_gauss = fit(tmpX', tmpY', gaussEqn, 'Start', startPoints);
    estMu = fff_gauss.b; estSigma = abs(fff_gauss.c);
end

function [theB, theC, estBler] = fitMethod_1(estMu, estSigma, snrPoint)
    estBler = zeros(size(snrPoint)); estBler(1) = 1;
    estY = exp(-(((snrPoint - estMu) / estSigma) .^ 2)); estY = estY ./ sum(estY);
    tmpL = find(estY > 0.000001, 1, 'first'); tmpR = find(estY > 0.000001, 1, 'last');
    gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [0.05 estMu estSigma];
    fine_gauss = fit(snrPoint(tmpL:tmpR)', estY(tmpL:tmpR)', gaussEqn, 'Start', startPoints);
    theB = fine_gauss.b; theC = abs(fine_gauss.c);
    estDiff = fine_gauss(snrPoint);
    for idx = 2:size(estBler,2)
        estBler(idx) = estBler(idx-1) - estDiff(idx);
    end
end

function [theB, theC, estBler] = fitMethod_2(estMu, estSigma, snrPoint, tmpX, tmpY)
    assert(false);
    estBler = zeros(size(snrPoint)); estBler(1) = 1;    
    x0 = estMu; x1 = x0 + min(max(tmpX) - estMu, estMu - min(tmpX));
    y0 = 1; y1 = exp(-((x1-estMu)/estSigma)^2);
    yy0 = db2pow(-x0) * exp(-db2pow(estMu - x0)); yy1 = db2pow(-x1) * exp(-db2pow(estMu - x1));
    tmpC = log(y0 / y1) / log(yy0 / yy1); tmpB = estMu;
    
    testNList = tmpC/4:1:tmpC*4; testBList = tmpB-0.5:0.005:tmpB+0.5;
    minErr = 1e50; ccc = 0; bbb = 0;
    for iii = 1:size(testNList,2)
        for jjj = 1:size(testBList,2)
            tmpYY = db2pow(-tmpX) .* exp(-db2pow(testBList(jjj)-tmpX));
            tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ testNList(iii);
            tmpYY = tmpYY / sum(tmpYY); tmpYY = tmpYY * sum(tmpY);
            tmpV = mean((tmpY - tmpYY) .^ 2);
            %tmpV = std(tmpY - tmpYY);
            if tmpV < minErr
                minErr = tmpV; ccc = testNList(iii); bbb = testBList(jjj);
            end
        end
    end
    assert(ccc > min(testNList)); assert(ccc < max(testNList));
    assert(bbb > min(testBList)); assert(bbb < max(testBList));
    
    tmpYY = db2pow(-snrPoint) .* exp(-db2pow(bbb-snrPoint));
    tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ ccc; tmpYY = tmpYY / sum(tmpYY);
    theB = bbb; theC = abs(ccc);
    for idx = 2:size(estBler,2)
        estBler(idx) = estBler(idx-1) - tmpYY(idx);
    end
end

function [theB, theC, estBler] = fitMethod_3(estMu, estSigma, snrPoint, tmpX, tmpY)
    diffMu = -0.1:0.001:0.1; diffSigma = -0.1:0.001:0.1;
    minErr = 1e50; selectI = 0; selectJ = 0;
    for idxI = 1:size(diffMu,2)
        for idxJ = 1:size(diffSigma,2)
            if estSigma+diffSigma(idxJ) <= 0.0001
                continue;
            end
            tmpCurve = erfc((tmpX - (estMu+diffMu(idxI))) / (estSigma+diffSigma(idxJ)))/2;
            tmpErr = mean((tmpY - tmpCurve).^2);
            if (tmpErr < minErr)
                minErr = tmpErr;
                selectI = idxI; selectJ = idxJ;
            end
        end
    end
    assert(selectI > 1); assert(selectI < size(diffMu,2));
    assert(selectJ > 1); assert(selectJ < size(diffSigma,2));
    theB = estMu+diffMu(selectI); theC = estSigma+diffSigma(selectJ);
    estBler = erfc((snrPoint - theB) / theC)/2;
end

function [theB, theC, estBler] = fitMethod_4(estMu, estSigma, snrPoint, tmpX, tmpY)
    assert(false);
    newEqn = '1/(1 + exp(-a*x - b))'; startPoints = [-45 16];
    newFunc = fit(db2pow(tmpX)', tmpY', newEqn, 'Start', startPoints);
    theB = newFunc.a; theC = newFunc.b;
    estBler = newFunc(db2pow(snrPoint))';
end
