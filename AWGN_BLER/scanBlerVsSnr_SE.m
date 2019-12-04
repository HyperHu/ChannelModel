%%
clear all;

SpectralEfficiency_Table = [0.0586 0.0781 0.0977 0.125 0.1523 0.1934 0.2344 0.3066 0.377 0.4902 0.6016 0.7402 0.877 1.0273 1.1758 1.3262 ...
                            1.3281 1.4766 1.6953 1.9141 2.1602 2.4063 2.5703 ...
                            2.5664 2.7305 3.0293 3.3223 3.6094 3.9023 4.2129 4.5234 4.8164 5.1152 5.332 5.5547 ...
                            5.332 5.5547 5.8906 6.2266 6.5703 6.9141 7.1602 7.4063];

%%
if (1)
    load("cp_list_base.mat");
    %load("temp23_RawData.mat");
else
    cp_list = zeros(size(SpectralEfficiency_Table, 2), 2);
    for idx = 1:size(SpectralEfficiency_Table, 2)
        %tmpX = (sqrt(SpectralEfficiency_Table(idx)) - 0.24) / 0.07085;
        cp_list(idx,1) = -15;
        cp_list(idx,2) = 30;
    end
end

%%
ddd = 1;
while (ddd > 0.01)
    snrdB_List = -15:ddd:30;
    blerMatrix = zeros(size(SpectralEfficiency_Table, 2), size(snrdB_List,2));
    for seIdx = 1:size(blerMatrix,1)
        tic
        disp(seIdx);
        tmpFlag = true;
        for snrIdx = 1:size(blerMatrix,2)
            if (snrdB_List(snrIdx) < cp_list(seIdx,1))
                blerMatrix(seIdx, snrIdx) = 1;
                continue;
            end
            if (snrdB_List(snrIdx) > cp_list(seIdx,2))
                break;
            end
            blerMatrix(seIdx, snrIdx) = calBler(seIdx, snrdB_List(snrIdx), 20, 10);
            
            if ((blerMatrix(seIdx, snrIdx) < 1) && (tmpFlag == true))
                cp_list(seIdx,1) = snrdB_List(snrIdx) - 3 * ddd;
                tmpFlag = false;
            end
            if (blerMatrix(seIdx, snrIdx) > 0)
                cp_list(seIdx,2) = snrdB_List(snrIdx) + 3 * ddd;
            end
        end
        toc
    end
   ddd = ddd / 10; 
end

%%
% snrdB_List = -20:1:30;
% blerMatrix = zeros(size(SpectralEfficiency_Table, 2), size(snrdB_List,2));
% for seIdx = 1:size(blerMatrix,1)
%     tic
%     disp(seIdx);
%     for snrIdx = 1:size(blerMatrix,2)
%         blerMatrix(seIdx, snrIdx) = calBler(seIdx, snrdB_List(snrIdx), 10);
%         if (blerMatrix(seIdx, snrIdx) == 0)
%             break;
%         end
%     end
%     toc
% end

%%
figure(1); hold on; grid on;
mesh(snrdB_List, sqrt(SpectralEfficiency_Table), blerMatrix);

%%
figure(2);
for idx = 1:size(blerMatrix,1)
    plot(snrdB_List, blerMatrix(idx,:), '*--'); hold on; grid on;
end

save("temp_10Sample_20PRB_RawData.mat");


