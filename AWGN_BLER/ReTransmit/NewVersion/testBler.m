function theBler = testBler(nid, rnti, modMethod, targetRc, numLay, numPrb, numRe, ...
                            snrVal, nSample, nDec, numIter, algo)

if modMethod == "QPSK"
    theQm = 2;
elseif modMethod == "16QAM"
    theQm = 4;
elseif modMethod == "64QAM"
    theQm = 6;
elseif modMethod == "256QAM"
    theQm = 8;
end

rvList = [0, 2, 3, 1];

tmpCount = 0.0;
for idx = 1:nSample
    %% Generate Transport Block. Max TB size :2000000 x 1. Type: int8
    theTransBlock = genTransBlockData(modMethod, targetRc, numLay, numPrb, numRe);
    theTbSize = int32(length(theTransBlock));

    %% LDPC coding. Output max size: 30000 x 200.
    encodedBits = doLdpcEncoding(theTransBlock, targetRc);
    harqBuffer = zeros(size(encodedBits));

    for decIdx = 1:nDec
        %% Rate matching. Max CW size: 2000000 x 1. Type: int8
        rv = int32(rvList(decIdx)); outCWLen = int32(theQm * numLay * numPrb * numRe);
        theCodeWord = genCodeWordData(modMethod, numLay, encodedBits, rv, outCWLen);

        %% Convert to Symbol. Max size: :4 x :1000000. Type complex.
        theLaySym = genLayersSymbol(nid, rnti, modMethod, numLay, theCodeWord);

        %% Through AWGN channel
        %estLaySym = awgn(theLaySym, snrVal);
        estLaySym = throughBlockAwgnChannel(theLaySym, ones(numLay, numPrb) ./ db2pow(snrVal));

        %% LLR Decoding. size same as CW. Type: double
        dlschLLRs = doLlrDecoding(nid, rnti, modMethod, estLaySym, db2pow(-snrVal));

        %% Rate Recovery. Max codedbits: :30000 x :200. Type: double
        raterecovered = doRateRecoverLDPC(theTbSize, targetRc, modMethod, numLay, rv, dlschLLRs);

        harqBuffer = harqBuffer + raterecovered;
        isAcked = doLdpcDecoding(theTbSize, targetRc, harqBuffer, numIter, algo);
        if isAcked
            break;
        end
    end
    
    if ~isAcked
        tmpCount = tmpCount + 1.0;
    end
end

theBler = tmpCount / double(nSample);
end

