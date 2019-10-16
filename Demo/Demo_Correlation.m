%%
clear all;

%%
numRay = 20;
numSample = 2;

%% normal distribution
% normDList = 0.1 : 0.1 : 10;
% result = zeros(1, size(normDList,2));
% for idxD = 1:size(normDList,2)
%     x0 = exp(1i * randn(numRay, numSample) * sqrt(0.125) * normDList(idxD));
%     x0 = sum(x0, 1) ./ numRay;
%     result(idxD) = mean(x0);
% end
% figure(1); hold on; grid on;
% plot(normDList, abs(result), '--*');


%% uniform distribution
normDList = 0.1 : 0.1 : 10;
result = zeros(1, size(normDList,2));
for idxD = 1:size(normDList,2)
    x0 = exp(1i * (rand(numRay, numSample) - 0.5) * 4 * normDList(idxD));
    x0 = sum(x0, 1) ./ numRay;
    result(idxD) = mean(x0);
end
figure(1); hold on; grid on;
plot(normDList, abs(result), '--*');
std((rand(numRay, numSample) - 0.5) * 4, 0, 'all')
%%
% normDList = 0.5 : 0.5 : 50;
% %sigThetaList = 0.0001 : 0.0001 : 0.02;
% sigThetaList = 0.1 : 0.1 : 10;
% result = zeros(size(normDList,2), size(sigThetaList,2));
% 
% for idxD = 1:size(normDList,2)
%     for idxT = 1:size(sigThetaList,2)
%         tmpA = 1 / sqrt(numRay);
%         
% %         diffPhase = normDList(idxD) .* ...
% %             sin(randn(numRay, numSample) * pi * sqrt(sigThetaList(idxT)));
% 
%         % normal distribution
%         diffPhase = normDList(idxD) .* ...
%             randn(numRay, numSample) .* sqrt(sigThetaList(idxT));
% 
%         %x0 = tmpA .* exp(1i*2*pi * rand(numRay, numSample) * 1);
%         x0 = tmpA;
%         
%         x1 = x0 .* exp(-1i * diffPhase);
%         x0 = sum(x0, 1);
%         x1 = sum(x1, 1);
%         result(idxD, idxT) = mean(conj(x0) .* x1);
%     end
% end
% 
% figure();
% %mesh(sigThetaList, normDList, mag2db(abs(result)));
% mesh(sigThetaList, normDList, (abs(result)));

