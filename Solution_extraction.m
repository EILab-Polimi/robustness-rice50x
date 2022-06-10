clear
close all
clc

%% Explanation
% The script loads the file CBA_regional_data.csv in a table, the table is
% sorted in crescent order by timestep and all the data regarding t = 1 are
% removed. The table is then sorted by region and timestep. In the cycle,
% for every one of the 484 solutions a name is generated, according to the
% info information of the specific solution j in the table. Then in the
% nested cycle the value of miu and S relative to solution k for the first
% region are inserted in a vector, for every time step. Then the
% corresponding values for the second operator and so on until the last.
% The resulting vector, containing all the values of miu and S relative to
% solution k, for every region and every time step, is saved both in a .txt
% file and in the k-th row of the matrix solutions.
% 
% by Luca Ferrari - 29/04/2021
% 
%% Load data
addpath('Data');
CBA_regional_data = readtable('CBA_regional_data.csv');

%% Organizing data
a1=sortrows(CBA_regional_data, [2]);
a1 = a1(27589:end,:);
a1=sortrows(a1, [1,2]);

%% Extraction of solutions
n = height(a1);
p = [];
solutions = [];
j = 1;
z = 1;
N = (n/484);
n1 = 'RICEx_d0x9x1_';

for k = 1:484
    j = k;
    z = k;
    n2 = char(a1.policy(j));
    n3 = char(a1.baseline(j));

    if strcmp(a1.impacts(j), 'OFF')
        n4 = '_OFF';
    elseif strcmp(a1.impacts(j), 'BHM-LR')
        n4 = '_BHMn-LR';
    elseif strcmp(a1.impacts(j), 'BHM-LRdiff')
        n4 = '_BHMn-LRdiff';
    elseif strcmp(a1.impacts(j), 'BHM-SR')
        n4 = '_BHMn-SR';
    elseif strcmp(a1.impacts(j), 'BHM-SRdiff')
        n4 = '_BHMn-SRdiff';
    elseif strcmp(a1.impacts(j), 'DJO')
        n4 = '_DJOn';
    elseif strcmp(a1.impacts(j), 'KAHN')
        n4 = '_KAHNn';
    end
    
    if strcmp(a1.cooperation(j), 'NA')
        n5 = '';
    elseif strcmp(a1.cooperation(j), 'coop-pop')
        n5 = '_coop-pop';
    elseif strcmp(a1.cooperation(j), 'noncoop-pop')
        n5 = '_noncoop-pop';
    end
    
    if a1.prstp(j) == 0.0150
        n6 = '';
    elseif a1.prstp(j) == 0.001
        n6 = '_prstp-0x001';
    elseif a1.prstp(j) == 0.03
        n6 = '_prstp-0x03';
    end
    
    if a1.disnt(j) == 0
        n7 = '_disnt-g0';
    elseif a1.disnt(j) == 0.5
        n7 = '_disnt-g0x5';
    elseif a1.disnt(j) == 1.45
        n7 = '_disnt-g1x45';
    elseif a1.disnt(j) == 2
        n7 = '_disnt-g2';
    else
        n7 = '';
    end

    for i = 1:N
        p = [p, a1.mitigation(z)/100, a1.savings(z)];
        z = z+484;
    end
    name = ['\RICE50++_Inputs\' n1 n2 '_' n3 n4 n5 n6 n7];
    writematrix(p, name, 'FileType', 'text', 'Delimiter', 'space');
    solutions = [solutions; p];
    p = []; n2 = ''; n3 = ''; n4 = ''; n5 = ''; n6 = ''; n7 = '';
end
