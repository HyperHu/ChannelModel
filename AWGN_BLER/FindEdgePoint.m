%%
clear all;
load("SpectralEfficiency_Table.mat");

%%
nPRB_list = [1 2 4 5 10 20 50 100 200];
for nPrbIdx = 1:size(nPRB_list,2)
    load("ep_list_base.mat", "ep_list");
    ddd = 0.1;
    snrdB_List = -15:ddd:30;
    blerMatrix = zeros(size(SpectralEfficiency_Table, 2), size(snrdB_List,2));
    nPrb = nPRB_list(nPrbIdx);
    for seIdx = 1:size(blerMatrix,1)
        tic
        disp(seIdx);
        tmpFlag = true;
        for snrIdx = 1:size(blerMatrix,2)
            if (snrdB_List(snrIdx) < ep_list(seIdx,1))
                blerMatrix(seIdx, snrIdx) = 1;
                continue;
            end
            if (snrdB_List(snrIdx) > ep_list(seIdx,2))
                break;
            end
            
            blerMatrix(seIdx, snrIdx) = calBler(seIdx, snrdB_List(snrIdx),...
                                                nPrb, 50);
            
            if ((blerMatrix(seIdx, snrIdx) < 1) && (tmpFlag == true))
                ep_list(seIdx,1) = snrdB_List(snrIdx) - 5 * ddd;
                tmpFlag = false;
            end
            if (blerMatrix(seIdx, snrIdx) > 0)
                ep_list(seIdx,2) = snrdB_List(snrIdx) + 5 * ddd;
            end
        end
        toc
    end
    ep_list(:,1) = ep_list(:,1) - 0.25;
    ep_list(:,2) = ep_list(:,2) + 0.25;
    save("ep_list_PRB"+nPRB_list(nPrbIdx), "ep_list", "nPrb");
end

%%
load("SpectralEfficiency_Table.mat");
figure(1); hold on; grid on;
nPRB_list = [1 2 4 5 10 20 50 100 200];
for nPrbIdx = 1:size(nPRB_list,2)
    load(pwd + "\ep_list_PRB"+nPRB_list(nPrbIdx)+".mat", "ep_list");
    plot(SpectralEfficiency_Table, ep_list(:,1), '--');
    plot(SpectralEfficiency_Table, ep_list(:,2), '.-');
end
