%%
clearvars;
load("erfcfit.mat");    %1:QM, 2:effCR, 3:nRE, 4:mu, 5:sig

testQM = 8;
erfcfit = erfcfit(erfcfit(:, 1) == testQM,:);

for itemIdx = 1:size(erfcfit,1)
    theQm = erfcfit(itemIdx,1);
    theEffCR = erfcfit(itemIdx,2);
    theNPRB = floor(erfcfit(itemIdx,3) / 144);
    modMethod = "pi/2-BPSK";
    if theQm == 2
        modMethod = "QPSK";
    elseif theQm == 4
        modMethod = "16QAM";
    elseif theQm == 6
        modMethod = "64QAM";
    elseif theQm == 8
        modMethod = "256QAM";
    end

    webMu = erfcfit(itemIdx,4);
    webSig = erfcfit(itemIdx,5);

    tbSize = nrTBS(modMethod, 1, theNPRB, 144, theEffCR);
    tmpInfo = nrDLSCHInfo(tbSize, theEffCR);
    totalBits = double(tbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb));
    effCr = totalBits / double(theQm * 144*theNPRB);
    kDot = totalBits / double(tmpInfo.C);
    [~, myMu, mySig] = getCbBler(0, effCr, kDot, theQm, tmpInfo.BGN);
    
%     if tmpInfo.C == 1
%         figure(theQm); hold on; grid on;
%         plot3(effCr, kDot, (myMu - webMu) / webMu, '*');
%         figure(theQm+1); hold on; grid on;
%         plot3(effCr, kDot, (mySig - webSig) / webSig, '*');
%     end

    webSnr = webMu;
    mySnr = myMu + mySig*erfcinv(2*(1-0.5^(1/tmpInfo.C)));
    figure(1); hold on; grid on;
    plot3(effCr, kDot, webSnr - mySnr, 'y*');
end


%%
clearvars;
load("erfcfit.mat");    %1:QM, 2:effCR, 3:nRE, 4:mu, 5:sig

testQM = 8;
erfcfit = erfcfit(erfcfit(:, 1) == testQM,:);
theCalCR = zeros(size(erfcfit,1),1);
theCalCR_fix = zeros(size(erfcfit,1),1);
for itemIdx = 1:size(erfcfit,1)
    theQm = erfcfit(itemIdx,1);
    theEffCR = erfcfit(itemIdx,2);
    theNPRB = floor(erfcfit(itemIdx,3) / 144);
    modMethod = "pi/2-BPSK";
    if theQm == 2
        modMethod = "QPSK";
    elseif theQm == 4
        modMethod = "16QAM";
    elseif theQm == 6
        modMethod = "64QAM";
    elseif theQm == 8
        modMethod = "256QAM";
    end
    theCalCR(itemIdx) = nrTBS(modMethod, 1, theNPRB, 144, theEffCR) / (theQm * 144*theNPRB);
    fixCR = min(max(theEffCR + (theEffCR - theCalCR(itemIdx))/2, 0.01), 0.98);
    theCalCR_fix(itemIdx) = nrTBS(modMethod, 1, theNPRB, 144, fixCR) / (theQm * 144*theNPRB);

    figure(theNPRB); hold on; grid on;
    plot(theEffCR, theCalCR(itemIdx), 'r*');
end

prbList = [1, 2, 3, 4, 5, 10, 20, 30, 40, 50, 75, 100];
for itemIdx = 1:size(prbList,2)
    figure(prbList(itemIdx)); hold on; grid on;
    plot(0:0.1:1, 0:0.1:1, 'b--');
end

figure(200+testQM);
subplot(2,1,1); hold on; grid on;
plot(erfcfit(:,2), '-*'); plot(theCalCR, '-o'); %plot(theCalCR_fix, '-x');
legend(["Web", "MATLAB"]);
subplot(2,1,2); hold on; grid on;
plot((theCalCR - erfcfit(:,2)), '-*');
%plot((theCalCR_fix - erfcfit(:,2)), '-o');
legend("difference");

%%
clearvars
addpath('..\..\AWGN_BLER\ReTransmit\NewVersion\');
load("erfcfit.mat");    %1:QM, 2:effCR, 3:nRE, 4:mu, 5:sig

%testResults = doTesting(2, erfcfit, 1.5);
%load("QPSK_AlignData.mat","testResults");
% load("TempResult_QPSK_2_100_20.mat", "testResults");
load("TempResult_16QAM_2_200_20.mat","testResults");
%load("TempResult_64QAM_2_200_20.mat","testResults");
%load("TempResult_256QAM_2_400_10.mat","testResults");

tmpLegend = {100,1};
for idx = 1:100
    tmpLegend{idx} = [];
end
for itemIdx = 1:size(testResults,1)
    if isempty(testResults{itemIdx})
        continue;
    end
    lineStyle = "";

    theQm = testResults{itemIdx}.theQm;
    theEffCR = testResults{itemIdx}.effCR;
    theNPRB = testResults{itemIdx}.nPRB;
    modMethod = "pi/2-BPSK";
    if theQm == 2
        modMethod = "QPSK";
    elseif theQm == 4
        modMethod = "16QAM";
    elseif theQm == 6
        modMethod = "64QAM";
    elseif theQm == 8
        modMethod = "256QAM";
    end
    realCR = nrTBS(modMethod, 1, theNPRB, 144, theEffCR) / (theQm * 144*theNPRB);
    if abs(realCR - testResults{itemIdx}.effCR) > 1
        lineStyle = "--";
    end
    figure(testResults{itemIdx}.nPRB); hold on; grid on;
    %figure(); hold on; grid on;
    %plot(testResults{itemIdx}.snrRange, testResults{itemIdx}.curve, lineStyle);

    tbSize = nrTBS(modMethod, 1, theNPRB, 144, theEffCR);
    tmpInfo = nrDLSCHInfo(tbSize, theEffCR);
    totalBits = double(tbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb));
    effCr = totalBits / double(theQm * 144*theNPRB);
    kDot = totalBits / double(tmpInfo.C);
    theBler = getCbBler(testResults{itemIdx}.snrRange, effCr, kDot, theQm, tmpInfo.BGN);
    plot(testResults{itemIdx}.snrRange, testResults{itemIdx}.testSample_Mean - (1 - (1-theBler) .^ tmpInfo.C));

%     plot(testResults{itemIdx}.snrRange, testResults{itemIdx}.testSample_Mean, '*');
%     ppp = fill([testResults{itemIdx}.snrRange testResults{itemIdx}.snrRange(end:-1:1)], ...
%         [testResults{itemIdx}.testSample_Low testResults{itemIdx}.testSample_High(end:-1:1)], ...
%         'r', 'FaceColor', [1, 0.6, 1], 'EdgeColor', 'none'); alpha(ppp, 0.3);
    
%     tmpLegend{testResults{itemIdx}.nPRB} = [tmpLegend{testResults{itemIdx}.nPRB}, ...
%         sprintf("%.2f", testResults{itemIdx}.effCR) + " curve", ...
%         sprintf("%.2f", testResults{itemIdx}.effCR) + " sample", ...
%         sprintf("%.2f", testResults{itemIdx}.effCR) + " range"];
    tmpLegend{testResults{itemIdx}.nPRB} = [tmpLegend{testResults{itemIdx}.nPRB}, ...
    sprintf("%.2f", testResults{itemIdx}.effCR) + " curve"];
end

for idx = 1:100
    if size(tmpLegend{idx},1) > 0
        figure(idx); legend(tmpLegend{idx});
    end
end


%%
function testResults = doTesting(testQM, erfcfit, scanFactor)
    erfcfit = erfcfit(erfcfit(:, 1) == testQM,:);
    testResults = cell(size(erfcfit,1), 1);

    for itemIdx = 1:size(erfcfit,1)
        theSnrRange = (erfcfit(itemIdx,4)-scanFactor/erfcfit(itemIdx,5)) : 0.1 : (erfcfit(itemIdx,4)+scanFactor/erfcfit(itemIdx,5)+0.1);
        
        theCurve = 0.5*erfc((theSnrRange - erfcfit(itemIdx,4))*erfcfit(itemIdx,5));

        theQm = erfcfit(itemIdx,1);
        theEffCR = erfcfit(itemIdx,2);
        theNPRB = floor(erfcfit(itemIdx,3) / 144);
        if theQm == 2
            modMethod = "QPSK";
        elseif theQm == 4
            modMethod = "16QAM";
        elseif theQm == 6
            modMethod = "64QAM";
        elseif theQm == 8
            modMethod = "256QAM";
        end

        tic;
        testSample_Mean = zeros(size(theSnrRange));
        testSample_Low = zeros(size(theSnrRange));
        testSample_High = zeros(size(theSnrRange));
        for snrIdx = 1:size(theSnrRange, 2)
            blerSamples = testingBler(modMethod, theEffCR, theNPRB, theSnrRange(snrIdx), 10, 10);
            tmpQ = prctile(blerSamples, [5, 50, 95]);
            testSample_Low(snrIdx) = tmpQ(1);
            testSample_Mean(snrIdx) = tmpQ(2);
            testSample_High(snrIdx) = tmpQ(3);
        end
        processTime = toc;

        testResults{itemIdx}.theQm = theQm;
        testResults{itemIdx}.effCR = theEffCR;
        testResults{itemIdx}.nPRB = theNPRB;
        testResults{itemIdx}.snrRange = theSnrRange;
        testResults{itemIdx}.curve = theCurve;
        testResults{itemIdx}.testSample_Mean = testSample_Mean;
        testResults{itemIdx}.testSample_Low = testSample_Low;
        testResults{itemIdx}.testSample_High = testSample_High;
        testResults{itemIdx}.processTime = processTime;

        figure(testResults{itemIdx}.nPRB); hold on; grid on;
        plot(testResults{itemIdx}.snrRange, testResults{itemIdx}.curve);
        plot(testResults{itemIdx}.snrRange, testResults{itemIdx}.testSample_Mean, '-*');
        ppp = fill([testResults{itemIdx}.snrRange testResults{itemIdx}.snrRange(end:-1:1)], ...
                   [testResults{itemIdx}.testSample_Low testResults{itemIdx}.testSample_High(end:-1:1)], ...
                   'r', 'FaceColor', [1, 0.6, 1], 'EdgeColor', 'none'); alpha(ppp, 0.3);
        %pause();
    end
end

%%
function blerSamples = testingBler(modMethod, targetRc, numPrb, snrVal, nSamples, nTest)
    blerSamples = zeros(1,nTest);
    for idx = 1:nTest
        blerSamples(idx) = testBler(1, 1, modMethod, targetRc, 1, numPrb, 144, snrVal, nSamples, 1, 50, "Belief propagation");
        %disp("Test Idx: " + idx + ", SNR: " + snrVal + ", BLER: " + blerSamples(idx));
    end
    disp("SNR: " + snrVal + ", BLER: " + mean(blerSamples));
end
