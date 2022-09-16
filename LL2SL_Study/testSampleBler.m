%%
clear all;
theN = 2000*50;
theTimes = 1000;


%%
thePlist = 0.0001:0.001:0.1;
% theMeanList = zeros(size(thePlist));
% theStdList = zeros(size(thePlist));
the1QList = zeros(size(thePlist));
the2QList = zeros(size(thePlist));
the3QList = zeros(size(thePlist));
for idx = 1:size(thePlist,2)
%     [theMean, theStd] = calSampleBler(thePlist(idx), theN, theTimes);
%     theMeanList(idx) = theMean; theStdList(idx) = theStd;
    [the1Q, the2Q, the3Q] = calSampleBler(thePlist(idx), theN, theTimes);
    the1QList(idx) = the1Q; the2QList(idx) = the2Q; the3QList(idx) = the3Q;
end

figure(2); hold on; grid on;
%plot(thePlist, theMeanList, '-*');
%plot(thePlist, theMeanList + 2*theStdList, ':'); plot(thePlist, theMeanList - 2*theStdList, '--');

plot(thePlist, the2QList, '-*'); plot(thePlist, the1QList, ':'); plot(thePlist, the3QList, '--');

%%
function [the1Q, the2Q, the3Q] = calSampleBler(theP, theN, theTimes)
    theSampleBler = sum(rand(theN, theTimes) <= theP, 1) / theN;
    %theMean = mean(theSampleBler); theStd = std(theSampleBler);
    tmpQ = prctile(theSampleBler, [5, 50, 95]);
    the1Q = tmpQ(1); the2Q = tmpQ(2); the3Q = tmpQ(3);
end
