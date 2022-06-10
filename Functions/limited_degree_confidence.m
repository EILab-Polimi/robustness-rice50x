function [R, R_first, R_idx] = limited_degree_confidence(in1, q, beta, in2)

% Implementation of the robustness metric limited degree of confidence by
% McInerny et al. 2012. The inputs are:
% 
% in1 = array of data
% q = q-th portion of the utility distribution to be considered in the
% evaluation of the Conditional Value at Risk (CVaR) metric. For q = 1 the  
% metric corresponds to the expected utility maximization metric
% beta = decision maker's degree-of-confidence
% in2 = 'max' if the objective is to be maximized, 'min' if it is to be
% minimized
% 
% The outputs are:
% R = robustness value of every solution
% R_first = robustness value of the best solution
% R_idx = index of the robust solution

% 
% by Luca Ferrari

n = width(in1);

EUM = 1/n*sum(in1, 2);
% EUM = max(W);
N = q*n;
W_cap = sort(in1, 2);
CVaR = 1/N*sum(W_cap(:,1:N), 2);
R = beta.*EUM+(1-beta).*CVaR;

if in2 == 'max'
    R_first = max(R);
    idx = ismember(R, R_first);
    [R_idx, ~] = find(idx);
elseif in2 == 'min'
    R_first = min(R);
    idx = ismember(R, R_first);
    [R_idx, ~] = find(idx);
end
end