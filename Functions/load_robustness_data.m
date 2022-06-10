function [struct] = load_robustness_data(varargin)

% The function takes as an input the file robustnessOutput.txt and gives as
% output the data loaded into a structure.
% If 'no off' is given as a second argument, the solutions where the damage
% function is OFF are excluded. A second input different from 'no off' will
% result in an error message. 
% If 'coop' is given as a third argument, the solutions where the
% cooperaton setting is different from cooperative are excluded. A third
% input different from 'coop' will result in an error message. 
% 
% By Luca Ferrari - 20/04/2021

opts = detectImportOptions(varargin{1});
opts.SelectedVariableNames = ['Var1'];
struct.solution = string(readmatrix(varargin{1}, opts));

opts.SelectedVariableNames = [{'Var2', 'Var3', 'Var4', 'Var5', 'Var6', 'Var7', 'Var8', 'Var9', 'Var10',...
    'Var11', 'Var12'}];

switch nargin
    case 2
        robustnessOutput = readmatrix(varargin{1}, opts);
        if strcmp(varargin{2}, 'no off')
            idx = contains(struct.solution, 'OFF');
            struct.solution(idx) = [];
            robustnessOutput(idx, :) = [];
        else
            fprintf('Error! Input not recognized, please use ''no off'' as input to remove solutions with OFF damage function');
        end
    case 3
        robustnessOutput = readmatrix(varargin{1}, opts);
        if strcmp(varargin{2}, 'no off')
            idx = contains(struct.solution, 'OFF');
            struct.solution(idx) = [];
            robustnessOutput(idx, :) = [];
        else
            fprintf('Error! Input not recognized, please use ''no off'' as input to remove solutions with OFF damage function');
        end
        if strcmp(varargin{3}, 'coop')
            idx = contains(struct.solution, '_coop');
            struct.solution(~idx) = [];
            robustnessOutput(~idx, :) = [];
        else
            fprintf('Error! Input not recognized, please use ''coop'' as input to remove solutions with OFF damage function');
        end
    otherwise
        robustnessOutput = readmatrix(varargin{1}, opts);
end

struct.names = unique(struct.solution(:,1), 'stable');

%% ECS, SSP and damage function used in resimulation
struct.ECS = robustnessOutput(:,1);
struct.ssp = robustnessOutput(:,2);
struct.damages = robustnessOutput(:,3);

% ECS resimulation
ECS = {'2.5', '3', '4'};
ECS_num = [2.5, 3, 4];
struct.ECS_resim = strings(length(struct.ECS),1);

for i = 1:3
    idx = struct.ECS == ECS_num(i);
    struct.ECS_resim(idx) = ECS(i);
end

% Damage resimulation
damage = {'BHM-SR', 'BHM-LR', 'BHM-SRdiff', 'BHM-LRdiff', 'DJO', 'Kahn'};
struct.damages_resim = strings(length(struct.damages),1);

for i = 1:6
    idx = struct.damages == i;
    struct.damages_resim(idx) = damage(i);
end

% SSP resimulation
SSP = {'SSP1', 'SSP2', 'SSP3', 'SSP4', 'SSP5'};
struct.ssp_resim = strings(length(struct.ssp),1);

for i = 1:5
    idx = struct.ssp == i;
    struct.ssp_resim(idx) = SSP(i);
end

%% Normalization of welfare
W_max = max(robustnessOutput(:,4));
W_min = min(robustnessOutput(:,4));
struct.welfare = (robustnessOutput(:,4)-W_min)/(W_max-W_min);

%% Other objectives
struct.T2100 = robustnessOutput(:,5);
struct.Tmax = robustnessOutput(:,6);
struct.gini = robustnessOutput(:,7);
struct.r90_10 = robustnessOutput(:,8)./robustnessOutput(:,11);
struct.r80_20 = robustnessOutput(:,9)./robustnessOutput(:,10);

% SSP of optimal solutions
[struct.ssp_name, struct.ssp_num] = extract_setting(struct.solution, 'SSP');

% Damage function of optimal solutions
[struct.damages_name, struct.damages_num] = extract_setting(struct.solution, 'damage');

% Initial rate of social time preference per year of optimal solutions
[struct.prstp_name, struct.prstp_num] = extract_setting(struct.solution, 'prstp');

% Inequality adversion of optimal solutions
[struct.disnt_name, struct.disnt_num] = extract_setting(struct.solution, 'disnt');

% E Land of optimal solutions
[struct.Eland_name, struct.Eland_num] = extract_setting(struct.solution, 'Eland');

end

























