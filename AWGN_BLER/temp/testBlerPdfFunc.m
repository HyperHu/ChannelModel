%%
clear all;

testList = 1:4:200;
resultList = zeros(size(testList));
for idx1 = 1:size(testList,2)
    theN = testList(idx1); theAlpha = 0.001;
    kList = -10000:2000;
    tmpItem1 = theAlpha ./ ((1 - theAlpha) .^ ((theN+1)*kList));
    tmpItem2 = exp(-theN ./ ((1 - theAlpha) .^ (2*kList)));
    tmpY = tmpItem1 .* tmpItem2;
    figure(1); hold on; grid on;
%     plot(kList, log10(tmpY)); plot(kList, log10(tmpItem1), '--'); plot(kList, log10(tmpItem2), ':');
    plot(kList .* -mag2db(1-theAlpha), log10(tmpY ./ sum(tmpY)));
%     resultList(idx1) = log10(sum(tmpY));
end
% plot(testList, resultList, '*-'); grid on;


% testList = [0];
% testList2 = 1:2:80;
% resultList = zeros(size(testList, 2), size(testList2,2));
% for idx1 = 1:size(testList,2)
%     for idx2 = 1:size(testList2,2)
%     thePdB = testList(idx1); theN = testList2(idx2);
%     noisePwrdB_List = -200:0.00001:100; rho_List = db2mag(noisePwrdB_List);
%     theAlpha = 1 - db2mag(noisePwrdB_List(1) - noisePwrdB_List(2)); deltaLen = theAlpha * rho_List;
%     resultList(idx1, idx2) = sum(((rho_List .* exp(-(rho_List .^ 2)/(2 * db2pow(thePdB)))) .^ theN) .* deltaLen);
%     end
% end
% % mesh(testList2, testList, log10(resultList));
% plot(testList, log10(resultList(:, :)), '.-'); grid on; hold on;

% testDDD = [0.00001, 0.0001, 0.001, 0.01];
% theSum = zeros(size(testDDD));
% for idx = 1:size(testDDD, 2)
%     ddd = testDDD(idx); thePdB = 0; theN = 1;
%     noisePwrdB_List = -200:ddd:100; rho_List = db2mag(noisePwrdB_List);
%     theAlpha = 1 - db2mag(noisePwrdB_List(1) - noisePwrdB_List(2)); deltaLen = theAlpha * rho_List;
%     theSum(idx) = sum(((rho_List .* exp(-(rho_List .^ 2)/(2 * db2pow(thePdB)))) .^ theN) .* deltaLen);
% %     theSum(idx) = sum(((rho_List .* exp(-(rho_List .^ 2)/(2 * db2pow(thePdB)))) .^ theN));
% end
% plot(testDDD, theSum, '*-'); grid on; hold on;
% plot(rho_List, tmpY, '*-'); grid on; hold on;
