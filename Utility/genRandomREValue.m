function [reMat, bitData] = genRandomREValue(nRE, nSymbol, modulateOrder)

switch (modulateOrder)
    case 2
        mod = 'QPSK';
    case 4
        mod = '16QAM';
    case 6
        mod = '64QAM';
    case 8
        mod = '256QAM';
    otherwise
        assert(false);
end

bitData = randi([0 1], nRE*nSymbol*modulateOrder, 1);
reMat = reshape(nrSymbolModulate(bitData, mod), nRE, []);
end

%%% test for nrSymbolModulate and nrSymbolDemodulate.
% data = randi([0 1],100,1,'int8');
% modsymb = nrSymbolModulate(data,'16QAM');
% recsymb = awgn(modsymb,15);
% demodbits = nrSymbolDemodulate(recsymb,'16QAM','DecisionType','Hard');
% numErr = biterr(data,demodbits)
