function isAcked = doLdpcDecoding(tbSize, targetRc, harqBuffer)
%#codegen

info = nrDLSCHInfo(double(tbSize), targetRc);
decoded = nrLDPCDecode(harqBuffer, info.BGN, 6, Algorithm="Normalized min-sum");
desegmented = nrCodeBlockDesegmentLDPC(decoded, info.BGN, tbSize+info.L);
[~,blkErr] = nrCRCDecode(desegmented, info.CRC);

if blkErr == 0
    isAcked = true;
else
    isAcked = false;
end

