%%
clear all;
SpectralEfficiency_Table_size = 43;

%% out of data since some interface changed
% nPRB_list = [1 2 4 5 8 10 20 50 100 200];
% SINRMidPoint = zeros(size(nPRB_list,2), SpectralEfficiency_Table_size);
% 
% for nPrbIdx = 1:size(nPRB_list,2)
%     tmpPoint = -8;
%     for seIdx = 1:SpectralEfficiency_Table_size
%         tmpPoint = tmpPoint + 0.2;
%         tmpL = -15; tmpR = 30;
%         
%         while true
%             tmpBler = calBler(seIdx, tmpPoint, nPRB_list(nPrbIdx), 1000);
%             if (tmpBler > 0.8)
%                 tmpL = tmpPoint;
%                 tmpPoint = tmpPoint + 0.1;
%             elseif (tmpBler < 0.2)
%                 tmpR = tmpPoint;
%                 tmpPoint = tmpPoint - 0.1;
%             else
%                 break;
%             end
%             if (tmpPoint == tmpL) || (tmpPoint == tmpR)
%                 fprintf('WRONG nPRB %d seIdx %d SINR [%.4f %.4f]\n',...
%                         nPRB_list(nPrbIdx), seIdx, tmpL, tmpR);
%                 break;
%             end
%         end
%         fprintf('nPRB %d seIdx %d SINR %.4f BLER %.4f\n',...
%                 nPRB_list(nPrbIdx), seIdx, tmpPoint, tmpBler);
%         SINRMidPoint(nPrbIdx, seIdx) = tmpPoint;
%     end
% end
% 
% save("SINRMidPoint.mat", "nPRB_list", "SINRMidPoint");
