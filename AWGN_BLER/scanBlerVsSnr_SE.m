%%
clear all;

SpectralEfficiency_Table = [0.0586 0.0781 0.0977 0.125 0.1523 0.1934 0.2344 0.3066 0.377 0.4902 0.6016 0.7402 0.877 1.0273 1.1758 1.3262 ...
                            1.3281 1.4766 1.6953 1.9141 2.1602 2.4063 2.5703 ...
                            2.5664 2.7305 3.0293 3.3223 3.6094 3.9023 4.2129 4.5234 4.8164 5.1152 5.332 5.5547 ...
                            5.332 5.5547 5.8906 6.2266 6.5703 6.9141 7.1602 7.4063];

%%
nPRB_list = [5 10 20 50 100 200];
for nPrbIdx = 1:size(nPRB_list,2)
    load("ep_list_PRB"+nPRB_list(nPrbIdx), "ep_list", "nPrb");
    ddd = 0.05;
    snrdB_List = -15:ddd:30;
    blerMatrix = zeros(size(SpectralEfficiency_Table, 2), size(snrdB_List,2));
    
    tic
    for seIdx = 1:size(blerMatrix,1)
        disp(seIdx);
        for snrIdx = 1:size(blerMatrix,2)
            if (snrdB_List(snrIdx) < ep_list(seIdx,1))
                blerMatrix(seIdx, snrIdx) = 1;
                continue;
            end
            if (snrdB_List(snrIdx) > ep_list(seIdx,2))
                break;
            end
            blerMatrix(seIdx, snrIdx) = calBler(seIdx, snrdB_List(snrIdx), nPrb, 5000);
        end
    end
    toc
    
    save("blerMatrix_5KSample_PRB"+nPRB_list(nPrbIdx),...
         "blerMatrix", "snrdB_List", "nPrb");
end

%%
% figure(1); hold on; grid on;
% mesh(snrdB_List, sqrt(SpectralEfficiency_Table), blerMatrix);

%%
% figure(2);
% for idx = 1:size(blerMatrix,1)
%     plot(snrdB_List, blerMatrix(idx,:), '*--'); hold on; grid on;
% end




