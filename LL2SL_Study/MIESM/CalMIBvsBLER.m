function [effSNR, theBLER] = CalMIBvsBLER(modMethod, targetRc, numLay, numPrb, numRe, blockSnr, nTest)
    addpath('..\..\AWGN_BLER\ReTransmit\NewVersion\');

    if modMethod == "QPSK"
        theQm = 2;
    elseif modMethod == "16QAM"
        theQm = 4;
    elseif modMethod == "64QAM"
        theQm = 6;
    elseif modMethod == "256QAM"
        theQm = 8;
    end

    aveMIB = CalAveMIB(modMethod, blockSnr);
    effSNR = CalEffSNR(modMethod, aveMIB);

    tmpCount = 0.0;
    for idx = 1:nTest
        theTransBlock = genTransBlockData(modMethod, targetRc, numLay, numPrb, numRe);
        encodedBits = doLdpcEncoding(theTransBlock, targetRc);

        theTbSize = int32(length(theTransBlock));
        rv = 0; outCWLen = int32(theQm * numLay * numPrb * numRe);
        theCodeWord = genCodeWordData(modMethod, numLay, encodedBits, rv, outCWLen);

        theLaySym = genLayersSymbol(1, 2, modMethod, numLay, theCodeWord);
        estLaySym = throughBlockAwgnChannel(theLaySym, db2pow(-blockSnr));

        %dlschLLRs = doLlrDecoding(1, 2, modMethod, estLaySym, mean(db2pow(-blockSnr), 'all'));
        dlschLLRs = doLlrDecoding(1, 2, modMethod, estLaySym, db2pow(-blockSnr));
        
        %
        thePrbCsi = mean(db2pow(-blockSnr), 'all') ./ db2pow(-blockSnr);
        theSymCsi = nrLayerDemap(kron(ones(1, numRe/12), kron(thePrbCsi, ones(1,12))).');
        theSymCsi = repmat(theSymCsi{1}.', theQm, 1);
        dlschLLRs = dlschLLRs .* theSymCsi(:);
        %
        
        raterecovered = doRateRecoverLDPC(theTbSize, targetRc, modMethod, numLay, rv, dlschLLRs);
        isAcked = doLdpcDecoding(theTbSize, targetRc, raterecovered, 15, "Offset min-sum");
        
        if ~isAcked
            tmpCount = tmpCount + 1.0;
        end
    end

    theBLER = tmpCount / double(nTest);
end



% 
% function aveEESM = CalAveEESM(blockSnr)
%     aveEESM = pow2db(-log(mean(exp(-db2pow(blockSnr)), 'all')));
% end
