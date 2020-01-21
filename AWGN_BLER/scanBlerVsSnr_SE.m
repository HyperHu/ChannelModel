%%
clear all;
SpectralEfficiency_Table_size = 43;

testPRB_list = [1, 2, 4, 5, 8, 10, 16, 20, 32, 50, 64, 100, 128, 200, 256];
for nPrbIdx = 1:size(testPRB_list,2)
    load("SINRMidPoint.mat");
    assert(size(SINRMidPoint, 2) == SpectralEfficiency_Table_size);
    nPrb = testPRB_list(nPrbIdx);
    tmpIII = find(nPrb >= nPRB_list, 1, 'last');
    
    theMod = "QPSK"; seStart = 1; seEnd = 16; ddd = 0.01;
    %theMod = "16QAM"; seStart = 17; seEnd = 23; ddd = 0.02;
    %theMod = "64QAM"; seStart = 24; seEnd = 35; ddd = 0.02;
    %theMod = "256QAM"; seStart = 36; seEnd = 43; ddd = 0.01;
    
    snrdB_List = -15:ddd:30;
    tbBlerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
    cbBlerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
    for seIdx = seStart:seEnd
        tic
        midIdx = find(snrdB_List > SINRMidPoint(tmpIII, seIdx), 1);
        [tbBlerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx);
        tbBlerMatrix(seIdx, :) = tbBlerCurve;
        cbBlerMatrix(seIdx, :) = cbBlerCurve;
        toc
    end
    save("blerMat"+theMod+"_PRB"+nPrb, "tbBlerMatrix", "cbBlerMatrix", "snrdB_List", "nPrb");
end


function [blerCurve, cbBlerCurve] = CalBlerCurve(seIdx, nPrb, snrdB_List, midIdx)
    nSample = 1000;
    nIterMax = 50;
    thT = 0.01;
    nSymbol = 12;
    
    blerCurve = zeros(size(snrdB_List));
    cbBlerCurve = zeros(size(snrdB_List));
    
    tmpIdx = midIdx;
    while true
        nIter = 0;
        aveTbBler = 0;
        aveCbBler = 0;
        while true
            [theTbBler, theCbBler] = calBler(seIdx, snrdB_List(tmpIdx), nPrb, nSymbol, nSample);
            aveTbBler = (aveTbBler * nIter + theTbBler) / (nIter + 1);
            aveCbBler = (aveCbBler * nIter + theCbBler) / (nIter + 1);
            nIter = nIter + 1;
            
            tmpSigmaTb = sqrt(aveTbBler * (1 - aveTbBler) / (nSample*nIter - 1));
            tmpSigmaCb = sqrt(aveCbBler * (1 - aveCbBler) / (nSample*nIter - 1));
            tmpTb = min(0.1, min(aveTbBler, 1-aveTbBler));
            tmpCb = min(0.1, min(aveCbBler, 1-aveCbBler));
            
            if (nIter >= nIterMax) || ((tmpTb > 0) && (2*tmpSigmaTb/tmpTb < 0.1)...
                    && (tmpCb > 0) && (2*tmpSigmaCb/tmpCb < 0.1))
                break;
            end
        end
        fprintf('seIdx %d SINR %.4f BLER %.4f %.4f [ %.4f %.4f ] [%.4f %d]\n',...
                seIdx, snrdB_List(tmpIdx), aveTbBler, aveCbBler,...
                aveTbBler-2*tmpSigmaTb, aveTbBler+2*tmpSigmaTb,...
                tmpSigmaTb, nIter);
        blerCurve(tmpIdx) = aveTbBler;
        cbBlerCurve(tmpIdx) = aveCbBler;
        tmpIdx = tmpIdx + 1;
        if max(tmpTb, tmpCb) < thT
            break;
        end
    end

    tmpIdx = midIdx - 1;
    while true
        nIter = 0;
        aveTbBler = 0;
        aveCbBler = 0;
        while true
            [theTbBler, theCbBler] = calBler(seIdx, snrdB_List(tmpIdx), nPrb, nSymbol, nSample);
            aveTbBler = (aveTbBler * nIter + theTbBler) / (nIter + 1);
            aveCbBler = (aveCbBler * nIter + theCbBler) / (nIter + 1);
            nIter = nIter + 1;
            
            tmpSigmaTb = sqrt(aveTbBler * (1 - aveTbBler) / (nSample*nIter - 1));
            tmpSigmaCb = sqrt(aveCbBler * (1 - aveCbBler) / (nSample*nIter - 1));
            tmpTb = min(0.1, min(aveTbBler, 1-aveTbBler));
            tmpCb = min(0.1, min(aveCbBler, 1-aveCbBler));
            
            if (nIter >= nIterMax) || ((tmpTb > 0) && (2*tmpSigmaTb/tmpTb < 0.1)...
                    && (tmpCb > 0) && (2*tmpSigmaCb/tmpCb < 0.1))
                break;
            end
        end
        fprintf('seIdx %d SINR %.4f BLER %.4f %.4f [ %.4f %.4f ] [%.4f %d]\n',...
                seIdx, snrdB_List(tmpIdx), aveTbBler, aveCbBler,...
                aveTbBler-2*tmpSigmaTb, aveTbBler+2*tmpSigmaTb,...
                tmpSigmaTb, nIter);
        blerCurve(tmpIdx) = aveTbBler;
        cbBlerCurve(tmpIdx) = aveCbBler;
        tmpIdx = tmpIdx - 1;
        if max(tmpTb, tmpCb) < thT
            break;
        end
    end
    
    blerCurve(1:tmpIdx) = 1;
    cbBlerCurve(1:tmpIdx) = 1;
end

