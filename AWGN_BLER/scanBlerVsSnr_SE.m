%%
clear all;
SpectralEfficiency_Table_size = 43;

%%
nPRB_list = [50 100 200 2 4 10 1 5 20];
for nPrbIdx = 1:size(nPRB_list,2)
    load("ep_list_PRB"+nPRB_list(nPrbIdx), "ep_list", "nPrb");
    
    % QPSK
    seStart = 1; seEnd = 16;
    ddd = 0.05;
    snrdB_List = -15:ddd:30;
    blerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
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
                        calBler(seIdx, snrdB_List(snrIdx), nPrb, 5*1000);
        end
        toc
    end
    save("blerMatrixQPSK_5KSample_PRB"+nPRB_list(nPrbIdx),...
         "blerMatrix", "snrdB_List", "nPrb");
     
    % 16QAM
    seStart = 17; seEnd = 23;
    ddd = 0.025;
    snrdB_List = -15:ddd:30;
    blerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
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
                        calBler(seIdx, snrdB_List(snrIdx), nPrb, 5*1000);
        end
        toc
    end
    save("blerMatrix16QAM_5KSample_PRB"+nPRB_list(nPrbIdx),...
         "blerMatrix", "snrdB_List", "nPrb");
    
    % 64QAM
    seStart = 24; seEnd = 35;
    ddd = 0.02;
    snrdB_List = -15:ddd:30;
    blerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
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
                        calBler(seIdx, snrdB_List(snrIdx), nPrb, 5*1000);
        end
        toc
    end
    save("blerMatrix64QAM_5KSample_PRB"+nPRB_list(nPrbIdx),...
         "blerMatrix", "snrdB_List", "nPrb");
     
    % 256QAM
    seStart = 36; seEnd = 43;
    ddd = 0.01;
    snrdB_List = -15:ddd:30;
    blerMatrix = zeros(SpectralEfficiency_Table_size, size(snrdB_List,2));
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
                        calBler(seIdx, snrdB_List(snrIdx), nPrb, 5*1000);
        end
        toc
    end
    save("blerMatrix256QAM_5KSample_PRB"+nPRB_list(nPrbIdx),...
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




