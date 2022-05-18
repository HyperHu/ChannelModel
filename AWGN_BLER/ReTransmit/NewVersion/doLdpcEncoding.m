function encodedBits = doLdpcEncoding(theTransBlock, targetRc)
%#codegen

chinfo = nrDLSCHInfo(length(theTransBlock), targetRc);
crced = nrCRCEncode(theTransBlock, chinfo.CRC);
segmented = nrCodeBlockSegmentLDPC(crced, chinfo.BGN);
encodedBits = nrLDPCEncode(segmented, chinfo.BGN);
end

