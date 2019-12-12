%%
clear all;
SpectralEfficiency_Table_size = 43;

%%
%nPRB_list = [5 10 20 50 100 200];
nPRB_list = [5 10 50 100];
for nPrbIdx = 1:size(nPRB_list,2)
    load("ep_list_PRB"+nPRB_list(nPrbIdx), "ep_list", "nPrb");
    ddd = 0.05;
    snrdB_List = -15:ddd:30;
    seStart = 1;
    seEnd = SpectralEfficiency_Table_size;
    blerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
    
    if nPRB_list(nPrbIdx) == 5
        seStart = 38;
        load("Done37_blerMatrix_2KSample_PRB5.mat", "blerMatrix");
    end
    
    for seIdx = seStart:seEnd
        tic
        disp(seIdx);
        for snrIdx = 1:size(blerMatrix,2)
            if (snrdB_List(snrIdx) < ep_list(seIdx,1))
                blerMatrix(seIdx, snrIdx) = 1;
                continue;
            end
            if (snrdB_List(snrIdx) > ep_list(seIdx,2))
                break;
            end
            blerMatrix(seIdx, snrIdx) = ...
                        calBler(seIdx, snrdB_List(snrIdx), nPrb, 2*1000);
        end
        toc
    end
   
    save("blerMatrix_2KSample_PRB"+nPRB_list(nPrbIdx),...
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




