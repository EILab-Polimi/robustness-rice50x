function [R, R_first, R_idx] = mean_variance(in1, in2)

% Implementation of the robustness metric mean-variance by Hamarat et al.
% 2014. The inputs are:
% 
% in1 = array of data
% in2 = 'max' if the objective is to be maximized, 'min' if it is to be minimized
% 
% The outputs are:
% R = robustness value of every solution
% R_first = robustness value of the best solution
% R_idx = index of the robust solution
% 
% by Luca Ferrari

m = mean(in1, 2);
s = std(in1, 0, 2);

if in2 == 'max'
    R = (m+1)./(s+1);
    %R = log((m+1)./(s+1));
    R_first = max(R);
    idx = ismember(R, R_first);
    R_idx = find(idx);
elseif in2 == 'min'
    R = (m+1).*(s+1);
    %R = log((m+1).*(s+1));
    R_first = min(R);
    idx = ismember(R, R_first);
    R_idx = find(idx);
end
end