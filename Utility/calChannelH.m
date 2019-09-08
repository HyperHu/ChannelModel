function [theH_d] = calChannelH(rayList, distD, mu, nFFT, simulationTimeMs)
% theH_d is a [nFFT, nSymbol] matrix. The frequency of theH_d[1,:] is -pi. 
[~, subCarriarSpace, numSymbolPerSubFrame, sampleRate, nCP_List_subFrame] = calCommonPar(mu, nFFT);
nCP_List = repmat(nCP_List_subFrame, 1, simulationTimeMs);
nSymbol = numSymbolPerSubFrame*simulationTimeMs;
n0 = zeros(1, nSymbol);
for sym = 1:nSymbol
    n0(sym) = nFFT * (sym-1) + sum(nCP_List(1:sym));
end

theH_d = zeros(nFFT, nSymbol);
for idxRay = 1:size(rayList,1)
    scaler = db2mag(0 - rayList(idxRay, 1));
    delay_sample = (rayList(idxRay, 2) * 1e-9) * sampleRate;
    delay_n = fix(delay_sample);
    tao = delay_n;
    assert(tao < min(nCP_List));
    kds = rayList(idxRay, 3) / subCarriarSpace;
    tmpV = scaler * calIciFactor(distD, kds, nFFT);
    tmpV = tmpV .* calPhaseFactor(nFFT, n0, rayList(idxRay, 4), tao, kds, distD);
    theH_d = theH_d + tmpV;
end

end
