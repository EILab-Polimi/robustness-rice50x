function [R, R_first, R_idx, scenario] = maximax(in1, in2)

% Implementation of the robustness metric maximax by Wald 1950
% The inputs are:
% 
% in1 = array of data
% in2 = 'max' if the objective is to be maximized, 'min' if it is to be minimized
% 
% The outputs are:
% R = robustness value of every solution
% R_first = robustness value of the best solution
% R_idx = index of the robust solution
% scenario = index of every robust value (reference to scenario)
% 
% by Luca Ferrari

if in2 == 'max'
    [R, scenario] = max(in1, [], 2);
    R_first = max(R);
    idx = ismember(R, R_first);
    R_idx = find(idx);
elseif in2 == 'min'
    [R, scenario] = min(in1, [], 2);
    R_first = min(R);
    idx = ismember(R, R_first);
    R_idx = find(idx);
end
end