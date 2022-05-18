%%
clear all;

tmpSinr = -15:0.05:30;
noise1 = ones(size(tmpSinr,2),1) * db2pow(-tmpSinr);
noise2 = (ones(size(tmpSinr,2),1) * db2pow(-tmpSinr))';
noiseTotal = (noise1 + noise2) ./ 2;
effSinr = -pow2db(noiseTotal);
mesh(tmpSinr, tmpSinr, effSinr);


%%
ttt = [0.3326 0.3100 0.3201 0.3251 0.3094 0.3188 0.3281 0.3133 0.3133 0.3220 0.3306 0.3167 0.3247 0.3328 0.3328 0.3196 0.3272 0.2976 0.3043 0.3110 0.3110 0.3178 0.3245 0.3312 0.3042 0.3102 0.3102 0.3163 0.3223 0.3284 0.3041 ...
0.3096 0.3096 0.3151 0.3206 0.3261 0.3316 0.3090 0.3090 0.3141 0.3191 0.3242];
plot(ttt, '*-'); grid on;

%%
clear all

% nSample = 2000000;
% theN = 16; theP_dB = 0;
% tmpV = randn(theN, nSample) * (db2mag(theP_dB) / sqrt(theN));
% tmpRho = sqrt(sum(tmpV .^ 2, 1));
% 
% hhh = fitdist(tmpRho', 'weibull');
% hhh
% % figure(1); hold on; grid on;
% % h = histogram(mag2db(tmpRho), BinEdge, 'Normalization', 'pdf', 'DisplayStyle', 'stairs');




BinEdge = -80:0.01:20;
nList = [1, 4, 16, 64];
resultList = zeros(size(nList));
sss = zeros(size(nList));

CCC = {};
VVV = {};
EEE = {};

for idx = 1:size(nList,2)
    nSample = 2000000;
    theN = nList(idx); theP_dB = 5;
    tmpV = randn(theN, nSample) * (db2mag(theP_dB) / sqrt(theN));
    tmpRho = sqrt(sum(tmpV .^ 2, 1));

    figure(1); hold on; grid on;
    h = histogram(mag2db(tmpRho), BinEdge, 'Normalization', 'pdf', 'DisplayStyle', 'stairs');
    %h = histogram(mag2db(tmpRho), 'Normalization', 'probability', 'DisplayStyle', 'stairs');
    resultList(idx) = (h.Values(find(h.BinEdges >0, 1) -1) + h.Values(find(h.BinEdges >0, 1) -2)) /2;
    sss(idx) = sum(h.Values);
    
    CCC{idx} = h.BinCounts;
    VVV{idx} = h.Values;
    EEE{idx} = h.BinEdges;
end
% histogram(tmpRho, 'Normalization', 'probability', 'DisplayStyle', 'stairs');

%
III = 4;
rhoList = (EEE{III}(1:end-1) + EEE{III}(2:end)) / 2;
tmpYYY = (db2mag(rhoList) .* exp(-db2pow(rhoList) ./ (2* db2pow(theP_dB)))) .^ nList(III);
scaleFactor = sum(VVV{III}) / sum(tmpYYY);
tmpYYY = tmpYYY * scaleFactor;
figure(2); hold on; grid on;
plot(rhoList, VVV{III}, '*');
plot(rhoList, tmpYYY, '--');

