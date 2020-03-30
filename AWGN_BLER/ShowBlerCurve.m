%%
clear all;

figure(1); hold on; grid on;

seIdx = 16;

targetFile = "SampleData\DynErr\blerMatQPSK_PRB20.mat";
load(targetFile);
plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');


%%



targetFile = "blerMatQPSK_PRB2.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "blerMatQPSK_PRB5.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "blerMatQPSK_PRB10.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "NewData\blerMatQPSK_PRB10.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "NewData\blerMatQPSK_PRB15.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "NewData\blerMatQPSK_PRB20.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "NewData\blerMatQPSK_PRB25.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "NewData\blerMatQPSK_PRB30.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "NewData\blerMatQPSK_PRB40.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "NewData\blerMatQPSK_PRB50.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');

targetFile = "NewData\blerMatQPSK_PRB70.mat";
load(targetFile);
% plot(snrdB_List, cbBlerMatrix(seIdx,:), '.-');
plot(snrdB_List, tbBlerMatrix(seIdx,:), 'o-');