function [estBlerCurve, snrPoint, A, B, C, stdErr] = FitOneBlerCurve(theBlerCurve, snrdB_List, showFigure)
    snrPoint = -15:0.001:30; estBlerCurve = zeros(size(snrPoint)); estBlerCurve(1) = 1;
    idxS = find(theBlerCurve < 1, 1, 'first'); idxE = find(theBlerCurve > 0, 1, 'last');
    tmpX = snrdB_List(idxS+1:idxE); tmpY = theBlerCurve(idxS:idxE-1) - theBlerCurve(idxS+1:idxE);
  
    %%%%%%%%%%%%%%%%%%%%%%%%%% Fit based on Gauss %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gaussEqn = 'a*exp(-((x-b)/c)^2)'; startPoints = [0.05 mean(tmpX) 0.25];
    fff_gauss = fit(tmpX', tmpY', gaussEqn, 'Start', startPoints);
    estY = fff_gauss(snrPoint); estY = estY ./ sum(estY);
    tmpL = find(estY > 0.000001, 1, 'first'); tmpR = find(estY > 0.000001, 1, 'last');
    startPoints = [fff_gauss.a fff_gauss.b abs(fff_gauss.c)];
    fff_gauss = fit(snrPoint(tmpL:tmpR)', estY(tmpL:tmpR), gaussEqn, 'Start', startPoints);
    estDiff = fff_gauss(snrPoint); A = fff_gauss.a; B = fff_gauss.b; C = abs(fff_gauss.c);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% New Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     deltaXXX = min(max(tmpX) - fff_gauss.b, fff_gauss.b - min(tmpX)); x0 = fff_gauss.b; x1 = x0 + deltaXXX;
%     y0 = fff_gauss(x0); y1 = fff_gauss(x1);
%     yy0 = db2pow(-x0) * exp(-db2pow(fff_gauss.b - x0)); yy1 = db2pow(-x1) * exp(-db2pow(fff_gauss.b - x1));
%     tmpC = log(y0 / y1) / log(yy0 / yy1); tmpB = fff_gauss.b;
%     
%     testNList = tmpC/2:1:tmpC*2; testBList = tmpB-0.5:0.001:tmpB+0.5; minErr = 1e10; ccc = 0; bbb = 0;
%     for iii = 1:size(testNList,2)
%         for jjj = 1:size(testBList,2)
%             tmpYY = db2pow(-tmpX) .* exp(-db2pow(testBList(jjj)-tmpX)); tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ testNList(iii);
%             tmpYY = tmpYY / sum(tmpYY); tmpYY = tmpYY * sum(tmpY);
%             tmpV = std(tmpY - tmpYY);
%             if tmpV < minErr
%                 minErr = tmpV; ccc = testNList(iii); bbb = testBList(jjj);
%             end
%         end
%     end
%     assert(ccc > min(testNList)); assert(ccc < max(testNList));
%     assert(bbb > min(testBList)); assert(bbb < max(testBList));
%     
%     tmpYY = db2pow(-snrPoint) .* exp(-db2pow(bbb-snrPoint)); tmpYY = tmpYY ./ max(tmpYY); tmpYY = tmpYY .^ ccc;
%     tmpYY = tmpYY / sum(tmpYY);
%     estDiff = tmpYY'; A = 1; B = bbb; C = ccc;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    for idx = 2:size(estBlerCurve,2)
        estBlerCurve(idx) = estBlerCurve(idx-1) - estDiff(idx);
    end
    
    tmpIdx = 1 + (idxS-1:idxE-1) * floor((snrdB_List(2)-snrdB_List(1)) / (snrPoint(2) - snrPoint(1)));
    stdErr = std(theBlerCurve(idxS:idxE) - estBlerCurve(tmpIdx));
    
    if showFigure > 0
        figure(showFigure); hold on; grid on;
        plot((floor((idxS-idxE)/2):floor((idxS-idxE)/2)+(idxE-idxS)), theBlerCurve(idxS:idxE) - estBlerCurve(tmpIdx), '.-');
        
        figure(showFigure+1); hold on; grid on; plot(tmpX, tmpY, '.');
        plot(tmpX, estBlerCurve(tmpIdx(1:end-1)) - estBlerCurve(tmpIdx(2:end)), '--');
    end
end

