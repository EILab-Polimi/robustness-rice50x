function [R, R_first, R_idx] = percentile_based_peakedness(in1, ~)

% Implementation of the robustness metric percentile based peakdness by
% Hamarat et al. 2014. The inputs are:
% 
% in1 = array of data
% in2 = 'max' if the objective is to be maximized, 'min' if it is to be minimized
% 
% The outputs are:
% R = robustness value of every solution
% R_first = robustness value of the best solution
% R_idx = index of the robust solution
% 
% The robustness value for alternative i is evaluated with the formula:
% 
% R(i) = ((q_90 + q_10)/2 - q_50)/((q_90 - q_10)/2)
% 
% For an objective to be maximized, and:
% 
% R(i) = - ((q_90 + q_10)/2 - q_50)/((q_90 - q_10)/2)
% 
% For an objective to be minimized
% 
% by Luca Ferrari

p = prctile(in1, [10, 25, 75, 90], 2);

% if in2 == 'max'
    R = (p(:,4)-p(:,1))./(p(:,3)-p(:,2));
    R_first = max(R);
    idx = ismember(R, R_first);
    R_idx = find(idx);
% elseif in2 == 'min'
%     out3 = -(p(:,4)-p(:,1))./(p(:,3)-p(:,2));
%     out1 = min(out3);
%     idx = ismember(out3, out1);
%     out2 = find(idx);
% end
end
