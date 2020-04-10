%% test X,Y Range: [-4.3 3.3] x [5.3 13.2] for (1:43)(1:273)(1:14)
clear all; addpath(pwd + "\Utility");
xList = -4.4:0.01:3.4; yList = 5.2:0.01:13.3;
tmpCnt = zeros(size(xList,2), size(yList,2));
tmpCnt_1 = zeros(size(xList,2), size(yList,2));
tmpCnt_2 = zeros(size(xList,2), size(yList,2));
testSeList = 1:43; testPrbList = 1:273; testSymList = 1:14;
load("Utility\TablesIn3GPP.mat");
for idxSe = 1:size(testSeList,2)
    disp(idxSe);
    for idxPrb = 1:size(testPrbList,2)
        for idxSym = 1:size(testSymList,2)
            
            seIdx = testSeList(idxSe); nPrb = testPrbList(idxPrb); nSymbol = testSymList(idxSym);
            pdsch = struct(); pdsch.NLayers = 1;
            pdsch.PRBSet = 0:nPrb - 1; pdsch.nPrb = nPrb; pdsch.nSymbol = nSymbol;
            pdsch.TargetCodeRate = TargetCodeRate_Table(seIdx) / 1024;
            pdsch.Modulation = ModulationOrder_Table{seIdx};
            pdsch.BitsPerSymbol = BitsPerSymbol_Table(seIdx);
            
            theTbSize = hPDSCHTBS(pdsch, 12*pdsch.nSymbol);
            tmpInfo = nrDLSCHInfo(theTbSize, pdsch.TargetCodeRate);
            bgn = tmpInfo.BGN; nCb = tmpInfo.C;
            effCodeRate = theTbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb);
            effCR = effCodeRate / (12 * nSymbol * nPrb * pdsch.BitsPerSymbol * pdsch.NLayers);
            k_dot = (theTbSize + tmpInfo.L + (tmpInfo.C * tmpInfo.Lcb)) / nCb;

            tmpX = log2(effCR*BitsPerSymbol_Table(idxSe)); tmpY = log2(k_dot);
            idxX = find(xList>tmpX,1); idxY = find(yList>tmpY,1);
            tmpCnt(idxX,idxY) = tmpCnt(idxX,idxY) + 1;
            if bgn == 1
                tmpCnt_1(idxX,idxY) = tmpCnt_1(idxX,idxY) + 1;
            else
                tmpCnt_2(idxX,idxY) = tmpCnt_2(idxX,idxY) + 1;
            end
        end
    end
end

ttt = sum(tmpCnt,2);
minX = xList(find(ttt>0,1) - 1); maxX = xList(find(ttt>0, 1, 'last') + 1);
ttt = sum(tmpCnt,1);
minY = yList(find(ttt>0,1) - 1); maxY = yList(find(ttt>0, 1, 'last') + 1);
figure(); mesh(xList, yList, tmpCnt'>0);
figure(); mesh(xList, yList, tmpCnt_1'>0);
figure(); mesh(xList, yList, tmpCnt_2'>0);

%%
% clear all;
% N = 20000;
% 
% blerEst = (0.1 ^ (1/100)) .^ (200:399);
% 
% estErr = sqrt(blerEst .* (1- blerEst) / (N - 1));
% 
% figure(1); hold on; grid on;
% plot(blerEst, estErr);
% 
% figure(2); hold on; grid on;
% plot(blerEst, 3*estErr ./ blerEst);

%%
% clear all;
% 
% theBler = 0.5;
% nSample = 1000*5;
% nTest = 10000;
% tmpV = rand(nSample, nTest);
% estBler = sum(tmpV < theBler, 1) ./ nSample;
% (max(estBler) - min(estBler))
% histfit(estBler);

%%
% clear all;
% 
% snrdB_List = -15:0.01:30;
% 
% M = 4;
% baseOffset = -pow2db(sum(pow2(2:2:M)));
% itemOffset = 3 * 2 * (1:(M/2))';
% itemSinr = snrdB_List + baseOffset + itemOffset;
% itemNoisePower = db2pow(-(itemSinr));
% totalNoisePow = mean(itemNoisePower, 1);
% effSnrdB_List = -pow2db(totalNoisePow);
% figure(1); hold on; grid on;
% plot(snrdB_List, effSnrdB_List);

%%
% clear all;
% BB = -1/1; C = 1;
% snrdB_List = -20:0.01:30; snrLin = db2mag(snrdB_List);
% tmpY = exp(C*(BB*(snrLin .^ 2) + log(snrLin)));
% %tmpY = tmpY ./ sum(tmpY);
% figure(1); hold on; grid on; plot(snrdB_List, tmpY);


%%
% clear all;
% snrdB_List = -15:0.01:-5;
% c_dot = -db2pow(-10.92 + pow2db(10/log(10)));
% tmpY = exp(c_dot ./ (10 .^ (snrdB_List / 10)) - snrdB_List); x0 = -10*log10(-10/(log(10)*c_dot));
% b = 4.5; tmpY = tmpY / max(tmpY); tmpY = tmpY .^ b; tmpY = 0.087 * tmpY;
% tmpC = -db2pow(x0 + pow2db(10/log(10)));
% figure(3); hold on; grid on;
% plot(snrdB_List, tmpY); plot(x0*ones(1,22), max(tmpY)*(0:21)/20, '--');
