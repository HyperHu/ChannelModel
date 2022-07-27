function [effSNRList, blerSampleList, diffList] = GenBlerSamples(modMethod, targetRc, numLay, numPrb, numRe, ...
                                                                 fadingMu, fadingSig, aveSnrList, nSample, nTest, skipRange)
    effSNRList = zeros(size(aveSnrList,1)*nSample, 1);
    blerSampleList = zeros(size(aveSnrList,1)*nSample, 1);
    diffList = zeros(size(aveSnrList,1)*nSample, 2);
    sampleCnt = 0;
    for theSNR = aveSnrList
        theSNR
        tic
        for sampleIdx = 1:nSample
            % build the block fading channel
            blockSnr = fadingMu + sqrt(fadingSig) .* randn(numLay, numPrb);
            blockSnr = blockSnr + theSNR;

            aveMIB = CalAveMIB(modMethod, blockSnr);
            effSNR = CalEffSNR(modMethod, aveMIB);
            diffMean = mean(blockSnr(:) - effSNR);
            diffStd = std(blockSnr(:) - effSNR);

            % skip too low or too high range
            if skipRange(1) >= effSNR || effSNR >= skipRange(2)
                continue;
            end
            
            [~, theBLER] = CalMIBvsBLER(modMethod, targetRc, numLay, numPrb, numRe, blockSnr, nTest);
            sampleCnt = sampleCnt + 1;
            effSNRList(sampleCnt) = effSNR;
            blerSampleList(sampleCnt) = theBLER;
            diffList(sampleCnt,1) = diffMean;
            diffList(sampleCnt,2) = diffStd;
        end
        toc
    end
    effSNRList = effSNRList(1:sampleCnt);
    blerSampleList = blerSampleList(1:sampleCnt);
    diffList = diffList(1:sampleCnt, :);
end
