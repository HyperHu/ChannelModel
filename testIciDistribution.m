%%
clear all;

mu = 1;
numPRB = 273;
subFrameDuration = 1 * 1e-3;    % 1ms
subCarriarSpace = (15 * 1e3) * (2 ^ mu);
numSymbolPerSubFrame = 14 * (2 ^ mu);
nFFT = 2 ^ ceil(log2(numPRB * 12));
nData = numPRB * 12;
sampleRate = nFFT * subCarriarSpace;


%%
rayList = genRandomRay(10, 0, (200/sampleRate)*1e9, 5*1000, 2*pi);
%rayList(:,3) = subCarriarSpace * 0.1;
distDRange = -10:10;
stdList = zeros(1, size(distDRange, 2));
for idx = 1:size(distDRange,2)
    theChannel = calChannelH(rayList, distDRange(idx), mu, nData);
    stdList(idx) = mag2db(std(reshape(real(theChannel), 1, [])));
end
stem(distDRange, stdList); hold on; grid on;

%%
rayList = genRandomRay(20, 0, (200/sampleRate)*1e9, 5*1000, 2*pi);
%rayList(:,3) = subCarriarSpace * 0.25;
theChannel_0 = calChannelH(rayList, 0, mu, nData);
theChannel_1 = calChannelH(rayList, 1, mu, nData);
theChannel_n1 = calChannelH(rayList, -1, mu, nData);
theChannel_2 = calChannelH(rayList, 2, mu, nData);
theChannel_n2 = calChannelH(rayList, -2, mu, nData);
theChannel_3 = calChannelH(rayList, 3, mu, nData);
theChannel_n3 = calChannelH(rayList, -3, mu, nData);

totalChannel = theChannel_1 + theChannel_n1 ...
                + theChannel_2 + theChannel_n2 ...
                + theChannel_3 + theChannel_n3 ...
                + 1 .* theChannel_0;
figure(1); hold on; grid on;
histfit(reshape(real(theChannel_0), 1, []), 200);
figure(2); hold on; grid on;
histfit(reshape(real(theChannel_1), 1, []), 200);
figure(3); hold on; grid on;
histfit(reshape(real(theChannel_n1), 1, []), 200);

figure(4); hold on; grid on;
histfit(reshape(abs(totalChannel), 1, []), 200, 'rayleigh');
figure(5); hold on; grid on;
histfit(reshape(abs(totalChannel), 1, []), 200, 'rician');

%%

% figure(); hold on; grid on;
% histfit(reshape(max(0.01, -mag2db(abs(rcvDataViaTime - rcvDataViaCh0))), 1, []), 100, 'lognormal');
% 
% figure(); hold on; grid on;
% histfit(reshape(abs(rcvDataViaTime - rcvDataViaCh0), 1, []), 200, 'lognormal');
% % figure(); grid on;
% % histfit(reshape(abs(rcvDataViaTime - rcvDataViaCh0) .^ 2, 1, []), 200, 'lognormal');
% % figure(); grid on;
% % histfit(reshape(abs(rcvDataViaTime - rcvDataViaCh0) .^ 2, 1, []), 200, 'poisson');
% figure(); hold on; grid on;
% histfit(reshape(abs(rcvDataViaTime - rcvDataViaCh0), 1, []), 200, 'rayleigh');
% figure(); hold on; grid on;
% histfit(reshape(abs(rcvDataViaTime - rcvDataViaCh0), 1, []), 200, 'rician');
% figure(); hold on; grid on;
% histfit(reshape(real(rcvDataViaTime - rcvDataViaCh0), 1, []), 100);

%%

% theChannel_0 = calChannelH(rayList, 0, mu, nData);
% theChannel_1 = calChannelH(rayList, 1, mu, nData);
% theChannel_n1 = calChannelH(rayList, -1, mu, nData);
% theChannel_2 = calChannelH(rayList, 2, mu, nData);
% theChannel_n2 = calChannelH(rayList, -2, mu, nData);
% theChannel_3 = calChannelH(rayList, 3, mu, nData);
% theChannel_n3 = calChannelH(rayList, -3, mu, nData);
% theChannel_4 = calChannelH(rayList, 4, mu, nData);
% theChannel_n4 = calChannelH(rayList, -4, mu, nData);
% theChannel_5 = calChannelH(rayList, 5, mu, nData);
% theChannel_n5 = calChannelH(rayList, -5, mu, nData);

%%
% figure(); hold on; grid on;
% histfit(reshape(real(theChannel_0), 1, []), 200);
% figure(); hold on; grid on;
% histfit(reshape(real(theChannel_1), 1, []), 200);
% histfit(reshape(real(theChannel_n1), 1, []), 200);
% figure(); hold on; grid on;
% histfit(reshape(real(theChannel_2), 1, []), 200);
% histfit(reshape(real(theChannel_n2), 1, []), 200);
% figure(); hold on; grid on;
% histfit(reshape(real(theChannel_3), 1, []), 200);
% histfit(reshape(real(theChannel_n3), 1, []), 200);
% figure(); hold on; grid on;
% histfit(reshape(real(theChannel_4), 1, []), 200);
% histfit(reshape(real(theChannel_n4), 1, []), 200);
% figure(); hold on; grid on;
% histfit(reshape(real(theChannel_5), 1, []), 200);
% histfit(reshape(real(theChannel_n5), 1, []), 200);

%%
% std(reshape(real(theChannel_0), 1, []))
% std(reshape(real(theChannel_1), 1, []))
% std(reshape(real(theChannel_n1), 1, []))
% std(reshape(real(theChannel_2), 1, []))
% std(reshape(real(theChannel_n2), 1, []))
% std(reshape(real(theChannel_3), 1, []))
% std(reshape(real(theChannel_n3), 1, []))
% std(reshape(real(theChannel_4), 1, []))
% std(reshape(real(theChannel_n4), 1, []))
% std(reshape(real(theChannel_5), 1, []))
% std(reshape(real(theChannel_n5), 1, []))