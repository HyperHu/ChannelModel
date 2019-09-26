clear all;

%%
% nList = 1:10;
% wList = 1:20;
% tmpRatio = zeros(size(nList,2), size(wList,2));
% 
% for idxN = 1:size(nList,2)
%     for idxW = 1:size(wList,2)
%         n = nList(idxN);
%         w = wList(idxW);
%         tmpRatio(idxN, idxW) = ((w*n/(w*n+1)) + (w /(w+n))) / ((1/(w*n+1)) + (n/(w+n)));
%     end
% end
% 
% mesh(wList, nList, tmpRatio);

%%
xdBList = -20:0.1:20;
xList = db2pow(xdBList);
tmpV1 = log2(1 + xList);
tmpV2 = log2(xList);
tmpV3 = xList .* log2(exp(1));
tmpV4 = (0.08*xdBList + 1.02) .^ 2;
%tmpV4 = (0.09*xdBList) .^ 2 + (0.17 * xdBList) + 1;

figure(1); hold on; grid on;
plot(xdBList, tmpV1);
plot(xdBList(200:end), tmpV2(200:end));
plot(xdBList(1:200), tmpV3(1:200));
plot(xdBList(100:300), tmpV4(100:300));


figure(2); hold on; grid on;
plot(xdBList(200:end), (tmpV2(200:end) - tmpV1(200:end)) ./ tmpV1(200:end));
plot(xdBList(1:200), (tmpV3(1:200) - tmpV1(1:200)) ./ tmpV1(1:200));
plot(xdBList(100:300), (tmpV4(100:300) - tmpV1(100:300)) ./ tmpV1(100:300));
plot(xdBList, 0.05 * ones(1,size(xdBList,2)));
plot(xdBList, -0.05 * ones(1,size(xdBList,2)));



