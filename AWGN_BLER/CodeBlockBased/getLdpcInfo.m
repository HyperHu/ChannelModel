
function [tbSize, bgn, nCb, effCr, kDot] = getLdpcInfo(theQm, nLay, nPrb, nRePerPrb, targetCr, theG)
% Input:
% theQm: 2\4\6\8. for QPSK, 16QAM, 64QAM, 256QAM.
% nLay: number of layers. 1 ~ 4.
% nPrb: number of PRB.
% nRePerPrb: data RE in each PRB. Must be mutiple of 12.
% targetCr: target code rate. 0 ~ 1.
% theG: number of total RE avaliable for this transmission.

% Output:
% tbSize: the length of TB, in bits.
% bgn: LDPC base graph selection (1 or 2)
% nCb: number of code blocks
% effCr: effective code rate. (tbSize + CRC bits) / (theQm * theG)
% kDot: information bis per code block. (tbSize + CRC bits) / nCb

%#codegen

NRE = min(156.0, double(nRePerPrb)) * double(nPrb);
Ninfo = NRE * targetCr * double(theQm) * double(nLay);
if Ninfo <= 3824
    n = max(3,floor(log2(Ninfo))-6);
    NdInfo = max(24,(2^n)*floor(Ninfo/(2^n)));

    tbsTable = [  24;  32;  40;  48;  56;  64;  72;  80;  88;  96; 104; 112; 120; 128; 136; 144; 152; 160; 168; 176; 184; 192; 208; 224; 240; 256; 272; 288; 304; 320; 336;...
                 352; 368; 384; 408; 432; 456; 480; 504; 528; 552; 576; 608; 640; 672; 704; 736; 768; 808; 848; 888; 928; 984;1032;1064;1128;1160;1192;1224;1256;1288;1320;...
                1352;1416;1480;1544;1608;1672;1736;1800;1864;1928;2024;2088;2152;2216;2280;2408;2472;2536;2600;2664;2728;2792;2856;2976;3104;3240;3368;3496;3624;3752;3824];
    tbsIndex = find(tbsTable >= NdInfo, 1);
    tbSize = int32(tbsTable(tbsIndex(1)));
else
    n = floor(log2(Ninfo - 24)) - 5;
    NdInfo = max(3840,(2^n)*round((Ninfo - 24)/(2^n)));
    if targetCr <= 1/4
        C = ceil((NdInfo + 24)/3816);
    else
        if NdInfo > 8424
            C = ceil((NdInfo + 24)/8424);
        else
            C = 1;
        end
    end
    tbSize = int32(8*C*ceil((NdInfo + 24)/(8*C)) - 24);
end

tmpInfo = nrDLSCHInfo(double(tbSize), targetCr);
bgn = tmpInfo.BGN;
nCb = tmpInfo.C;
totalBits = double(tbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb));
effCr = totalBits / double(theQm * theG);
kDot = totalBits / double(nCb);

end

