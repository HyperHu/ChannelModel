function isAcked = doLdpcDecoding(tbSize, targetRc, harqBuffer, numIter, algo)
%#codegen

info = nrDLSCHInfo(double(tbSize), targetRc);
decoded = nrLDPCDecode(harqBuffer, info.BGN, numIter, Algorithm=algo);
%decoded = nrLDPCDecode(harqBuffer, info.BGN, numIter, Algorithm="Belief propagation");
%decoded = nrLDPCDecode(harqBuffer, info.BGN, numIter, Algorithm="Layered belief propagation");
%decoded = nrLDPCDecode(harqBuffer, info.BGN, numIter, Algorithm="Normalized min-sum");
%decoded = nrLDPCDecode(harqBuffer, info.BGN, numIter, Algorithm="Offset min-sum");
desegmented = nrCodeBlockDesegmentLDPC(decoded, info.BGN, tbSize+info.L);
[~,blkErr] = nrCRCDecode(desegmented, info.CRC);

if blkErr == 0
    isAcked = true;
else
    isAcked = false;
end

