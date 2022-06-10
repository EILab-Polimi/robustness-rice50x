clear
% close all
clc

%% Load data
addpath('Functions', 'Data', 'RICE50++_Inputs', 'Images_data');
RO = load_robustness_data('\Data\robustnessOutput.txt', 'no off', 'coop');

%% Objectives
% Organizes the objectives values in tables where every row corresponds to
% a solution and every column to a scenario over which the solution has
% been re-simulated. Every cell of the matrix is the objective's value of
% the a solution over the corresponding scenario

N = length(RO.names);
Welfare = [reshape(RO.welfare', [90,N])'];
Temperature = [reshape(RO.T2100', [90,N])'];
Ratio_90_10 = [reshape(RO.r90_10', [90,N])'];
Ratio_80_20 = [reshape(RO.r80_20', [90,N])'];

%% Limited Degree of Confidence settings
beta = [0.2, 0.5, 0.7, 0.9];
q = 0.1;

%% Robustness - Welfare
% Evaluates all the robustness values for the welfare objective

[W_mmin] = maximin(Welfare, 'max');
[W_mmax] = maximax(Welfare, 'max');
[W_mv] = mean_variance(Welfare, 'max');
[W_ldc] = limited_degree_confidence(Welfare, q, beta, 'max');

%% Performance comparison - Welfare
% Normalization of all the robustness values between 0 and 1

W_mmin_norm = (W_mmin-min(W_mmin))/(max(W_mmin)-min(W_mmin));
W_mmax_norm = (W_mmax-min(W_mmax))/(max(W_mmax)-min(W_mmax));
W_mv_norm = (W_mv-min(W_mv))/(max(W_mv)-min(W_mv));
W_ldc_norm = (W_ldc-min(W_ldc))./(max(W_ldc)-min(W_ldc));

perf_W = table(W_mmin_norm, W_mmax_norm, W_mv_norm, W_ldc_norm(:,1), W_ldc_norm(:,2), W_ldc_norm(:,3), W_ldc_norm(:,4), 'VariableNames', {'maximin', 'maximax', 'mean-variance', 'LDC b=0.2', 'LDC b=0.5', 'LDC b=0.7', 'LDC b=0.9'});

%% Robustness - T 2100
[T_mmin] = maximin(Temperature, 'min');
[T_mmax] = maximax(Temperature, 'min');
[T_mv] = mean_variance(Temperature, 'min');
[T_ldc] = limited_degree_confidence(Temperature, q, beta, 'min');

%% Performance comparison - T 2100
% Normalization of all the robustness values between 0 and 1

T_mmin_norm = (T_mmin-max(T_mmin))/(min(T_mmin)-max(T_mmin));
T_mmax_norm = (T_mmax-max(T_mmax))/(min(T_mmax)-max(T_mmax));
T_mv_norm = (T_mv-max(T_mv))/(min(T_mv)-max(T_mv));
T_ldc_norm = (T_ldc-max(T_ldc))./(min(T_ldc)-max(T_ldc));

perf_T = table(T_mmin_norm, T_mmax_norm,T_mv_norm, T_ldc_norm(:,1), T_ldc_norm(:,2), T_ldc_norm(:,3), T_ldc_norm(:,4), 'VariableNames', {'maximin', 'maximax', 'mean-variance', 'LDC b=0.2', 'LDC b=0.5', 'LDC b=0.7', 'LDC b=0.9'});

%% Robustness - ratio 90/10
[R90_10_mmin] = maximin(Ratio_90_10, 'min');
[R90_10_mmax] = maximax(Ratio_90_10, 'min');
[R90_10_mv] = mean_variance(Ratio_90_10, 'min');
[R90_10_ldc] = limited_degree_confidence(Ratio_90_10, q, beta, 'min');

%% Performance comparison - ratio 90/10
% Normalization of all the robustness values between 0 and 1

R90_10_mmin_norm = (R90_10_mmin-max(R90_10_mmin))/(min(R90_10_mmin)-max(R90_10_mmin));
R90_10_mmax_norm = (R90_10_mmax-max(R90_10_mmax))/(min(R90_10_mmax)-max(R90_10_mmax));
R90_10_mv_norm = (R90_10_mv-max(R90_10_mv))/(min(R90_10_mv)-max(R90_10_mv));
R90_10_ldc_norm = (R90_10_ldc-max(R90_10_ldc))./(min(R90_10_ldc)-max(R90_10_ldc));

perf_R90_10 = table(R90_10_mmin_norm, R90_10_mmax_norm, R90_10_mv_norm, R90_10_ldc_norm(:,1), R90_10_ldc_norm(:,2), R90_10_ldc_norm(:,3), R90_10_ldc_norm(:,4), 'VariableNames', {'maximin', 'maximax', 'mean-variance', 'LDC β=0.2', 'LDC β=0.5', 'LDC β=0.7', 'LDC β=0.9'});

%% Robustness - ratio 80/20
[R80_20_mmin] = maximin(Ratio_80_20, 'min');
[R80_20_mmax] = maximax(Ratio_80_20, 'min');
[R80_20_mv] = mean_variance(Ratio_80_20, 'min');
[R80_20_ldc] = limited_degree_confidence(Ratio_80_20, q, beta, 'min');

%% Performance comparison - ratio 80/20
% Normalization of all the robustness values between 0 and 1

R80_20_mmin_norm = (R80_20_mmin-max(R80_20_mmin))/(min(R80_20_mmin)-max(R80_20_mmin));
R80_20_mmax_norm = (R80_20_mmax-max(R80_20_mmax))/(min(R80_20_mmax)-max(R80_20_mmax));
R80_20_mv_norm = (R80_20_mv-max(R80_20_mv))/(min(R80_20_mv)-max(R80_20_mv));
R80_20_ldc_norm = (R80_20_ldc-max(R80_20_ldc))./(min(R80_20_ldc)-max(R80_20_ldc));

perf_R80_20 = table(R80_20_mmin_norm, R80_20_mmax_norm, R80_20_mv_norm, R80_20_ldc_norm(:,1), R80_20_ldc_norm(:,2), R80_20_ldc_norm(:,3), R80_20_ldc_norm(:,4), 'VariableNames', {'maximin', 'maximax', 'mean-variance', 'LDC b=0.2', 'LDC b=0.5', 'LDC b=0.7', 'LDC b=0.9'});

%% Discard dominated solutions

Robustness_results = table(perf_W, perf_T, perf_R90_10, perf_R80_20);
Robustness_results = splitvars(Robustness_results);
Robustness_results = table2array(Robustness_results);

idx = dominated_rows(Robustness_results);
idx = logical(idx);
Robustness_results(idx,:) = NaN;

%% Robustness rankings
% The first sort function sorts the robustness values in descending order,
% independently for every column. Robustness_rank now gives the index of every
% value from the original Robustness_results matrix in the position where it
% is supposed to be placed in order to obtain the first sorting. The second
% sorting sorts those indexes in ascending order and this time
% Robustness_rank contains the the rank of every robustness value in the position
% corresponding to the original matrix Robustness_results. E. g. the first
% row contains the ranking of the robustness values of the first row of the
% matrix Robustness_results.

[~, Robustness_rank] = sort(Robustness_results, 'descend', 'MissingPlacement', 'last');
[~, Robustness_rank] = sort(Robustness_rank, 'ascend', 'MissingPlacement', 'last');

%% 2° compromise solution selection - maximin using ranking
% Selects the robust solutions applying the maximin criterion

[J_C,~,~,scen(:,1)] = maximin(Robustness_rank, 'min');
[J_C(:,2), J_C(:,1)] = sort(J_C);

%% Selection of robust solution for Welfare, T2100, 90/10
% Welfare
[J_W] = maximin(Robustness_rank(:,1:7), 'min');
[J_W(:,2), J_W(:,1)] = sort(J_W);

% T2100
[J_T] = maximin(Robustness_rank(:,8:14), 'min');
[J_T(:,2), J_T(:,1)] = sort(J_T);

% 90/10 ratio
[J_R,~,~,scen(:,2)] = maximin(Robustness_rank(:,15:21), 'min');
[J_R(:,2), J_R(:,1)] = sort(J_R);

%% Robust solutions names
selected_num = sort([J_C(1,1); J_W(1,1); J_T(1,1); J_R(1,1)]);

name_compromise = RO.names(J_C(1,1));
name_welfare = RO.names(J_W(1,1));
name_temperature = RO.names(J_T(1,1));
name_inequality = RO.names(J_R(1,1));

%% Decarbonization path

input_data(1,:) = load((RO.names(J_C(1,1))+'.txt'));
input_data(2,:) = load((RO.names(J_W(1,1))+'.txt'));
input_data(3,:) = load((RO.names(J_T(1,1))+'.txt'));
input_data(4,:) = load((RO.names(J_R(1,1))+'.txt'));

% Extract miu removing savings data
miu = round(input_data(:,1:2:end), 4);

miu_compromise = 100*reshape(miu(1,:), [57,57])';
miu_welfare = 100*reshape(miu(2,:), [57,57])';
miu_temperature = 100*reshape(miu(3,:), [57,57])';
miu_inequality = 100*reshape(miu(4,:), [57,57])';

% Years 2030, 2040, 2050, 2080, 2100
regions = readtable('RICE50+_Regions.xlsx');
regions.Properties.VariableNames = {'Region'};

miu_compromise_steps = [regions, table(miu_compromise(:,3), miu_compromise(:,7), miu_compromise(:,13), miu_compromise(:,17), 'VariableNames', {'2030', '2050', '2080', '2100'})];
miu_welfare_steps = [regions, table(miu_welfare(:,3), miu_welfare(:,7), miu_welfare(:,13), miu_welfare(:,17), 'VariableNames', {'2030', '2050', '2080', '2100'})];
miu_temperature_steps = [regions, table(miu_temperature(:,3), miu_temperature(:,7), miu_temperature(:,13), miu_temperature(:,17), 'VariableNames', {'2030', '2050', '2080', '2100'})];
miu_inequality_steps = [regions, table(miu_inequality(:,3), miu_inequality(:,7), miu_inequality(:,13), miu_inequality(:,17), 'VariableNames', {'2030', '2050', '2080', '2100'})];

writetable(miu_compromise_steps, 'Images_data\miu_compromise.csv', 'WriteRowNames',true);
writetable(miu_welfare_steps, 'Images_data\miu_welfare.csv', 'WriteRowNames',true);
writetable(miu_temperature_steps, 'Images_data\miu_temperature.csv', 'WriteRowNames',true);
writetable(miu_inequality_steps, 'Images_data\miu_inequality.csv', 'WriteRowNames',true);

% Saves complete miu datasets
miu_compromise = [regions, table(miu_compromise)];
miu_welfare = [regions, table(miu_welfare)];
miu_temperature = [regions, table(miu_temperature)];
miu_inequality = [regions, table(miu_inequality)];

% writetable(miu_compromise, 'Images_data\miu_compromise_complete.csv');
% writetable(miu_welfare, 'Images_data\miu_welfare_complete.csv');
% writetable(miu_temperature, 'Images_data\miu_temperature_complete.csv');
% writetable(miu_inequality, 'Images_data\miu_inequality_complete.csv');

%% Miu difference between compromise solution and other solutions
% Evaluates delta values
D_welfare = [miu_welfare{:,2} - miu_compromise{:,2}];
D_temperature = [miu_temperature{:,2} - miu_compromise{:,2}];
D_inequality = [miu_inequality{:,2} - miu_compromise{:,2}];

% Years 2030, 2040, 2050, 2080, 2100
D_welfare_steps = [regions, table(D_welfare(:,3), D_welfare(:,7), D_welfare(:,13), D_welfare(:,17), 'VariableNames', {'2030', '2050', '2080', '2100'})];
D_temperature_steps = [regions, table(D_temperature(:,3), D_temperature(:,7), D_temperature(:,13), D_temperature(:,17), 'VariableNames', {'2030', '2050', '2080', '2100'})];
D_inequality_steps = [regions, table(D_inequality(:,3), D_inequality(:,7), D_inequality(:,13), D_inequality(:,17), 'VariableNames', {'2030', '2050', '2080', '2100'})];

writetable(D_welfare_steps, 'Images_data\Delta_miu_welfare_compromise.csv', 'WriteRowNames',true);
writetable(D_temperature_steps, 'Images_data\Delta_miu_temperature_compromise.csv', 'WriteRowNames',true);
writetable(D_inequality_steps, 'Images_data\Delta_miu_inequality_compromise.csv', 'WriteRowNames',true);

% Saves complete miu datasets
% writetable([regions, table(D_welfare)], 'Images_data\Delta_welfare_complete.csv');
% writetable([regions, table(D_temperature)], 'Images_data\Delta_temperature_complete.csv');
% writetable([regions, table(D_inequality)], 'Images_data\Delta_inequality_complete.csv');

%% Export robustness ranking of the selected solutions

Robustness_ranking_selected_sol = Robustness_rank(selected_num,:);

VarNames = {'Solution' 'Welfare_Maximin' 'Welfare_Maximan' 'Welfare_Mean_Variance'...
    'Welfare_LDC_0.2' 'Welfare_LDC_0.5' 'Welfare_LDC_0.7' 'Welfare_LDC_0.9' ...
       'Temperature_Maximin'...
    'Temperature_Maximan' 'Temperature_Mean_Variance' 'Temperature_LDC_0.2' 'Temperature_LDC_0.5'...
    'Temperature_LDC_0.7' 'Temperature_LDC_0.9' ...
    'R90_10_Maximin' 'R90_10_Maximan' 'R90_10_Mean_Variance' 'R90_10_LDC_0.2' 'R90_10_LDC_0.5'...
    'R90_10_LDC_0.7' 'R90_10_LDC_0.9'  'R80_20_Maximin' 'R80_20_Maximan'...
    'R80_20_Mean_Variance' 'R80_20_LDC_0.2' 'R80_20_LDC_0.5' 'R80_20_LDC_0.7' 'R80_20_LDC_0.9'};

Robustness_ranking_selected_sol = table([RO.names(selected_num), Robustness_ranking_selected_sol]);
Robustness_ranking_selected_sol = splitvars(Robustness_ranking_selected_sol);
Robustness_ranking_selected_sol.Properties.VariableNames = VarNames;

writetable(Robustness_ranking_selected_sol, 'Images_data\Robustness_ranking_selected_solutions.csv', 'FileType', 'text', 'Delimiter', 'space');


