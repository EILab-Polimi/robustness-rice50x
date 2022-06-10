function [out1, out2] = extract_setting(in, setting)

% The function takes the list of solutions' names as inputs and gives the
% value of the desidered settings both as a numerical value and as a
% string. the inputs are:
% 
% in = string array containing the name of the solutions
% setting = 'SSP'/'damage'/'prstp'/'disnt'/'Eland'/'coop'
% 
% The output are:
% 
% out1 = string array containing the desidered setting of every solution
% which has been given as an input
% out2 = same information as out1, but given as a double array. In
% particular for SSP the values are:
% 
% 1 = SSP1, 2 = SSP2, 3 = SSP3, 4 = SSP4, 5 =SSP5 
% 
% and for damage funtion the values are:
% 
% 1 = BurkeSR, 2 = BurkeLR, 3 = BurkeSRDiff, 4 = BurkeLRDiff, 5 = DJO, 
% 6 = Kahn, 7 = OFF
% 
% by Luca Ferrari - 25/06/2021

out1 = strings(size(in));
out2 = nan(size(in));
    
if strcmp(setting, 'SSP')
    % SSP of optimal solutions
    idx = contains(in, 'ssp1');
    out2(idx) = 1;
    out1(idx) = 'SSP1';
    idx = contains(in, 'ssp2');
    out2(idx) = 2;
    out1(idx) = 'SSP2';
    idx = contains(in, 'ssp3');
    out2(idx) = 3;
    out1(idx) = 'SSP3';
    idx = contains(in, 'ssp4');
    out2(idx) = 4;
    out1(idx) = 'SSP4';
    idx = contains(in, 'ssp5');
    out2(idx) = 5;
    out1(idx) = 'SSP5';
elseif strcmp(setting, 'damage')
    % Damage function of optimal solutions
    idx = contains(in, 'BHMn-SR');
    out2(idx) = 1;
    out1(idx) = 'BHM-SR';
    idx = contains(in, 'BHMn-LR');
    out2(idx) = 2;
    out1(idx) = 'BHM-LR';
    idx = contains(in, 'BHMn-SRdiff');
    out2(idx) = 3;
    out1(idx) = 'BHM-SRdiff';
    idx = contains(in, 'BHMn-LRdiff');
    out2(idx) = 4;
    out1(idx) = 'BHM-LRdiff';
    idx = contains(in, 'DJO');
    out2(idx) = 5;
    out1(idx) = 'DJO';
    idx = contains(in, 'KAHN');
    out2(idx) = 6;
    out1(idx) = 'Kahn';
    idx = contains(in, 'OFF');
    out2(idx) = 7;
    out1(idx) = 'OFF';
elseif strcmp(setting, 'prstp')
    % Initial rate of social time preference per year of optimal solutions
    out1(:) = '0.015';
    out2(:) = 0.015;

    idx = contains(in, '0x001');
    out1(idx) = '0.001';
    out2(idx) = 0.001;
    idx = contains(in, '0x03');
    out1(idx) = '0.03';
    out2(idx) = 0.03;
elseif strcmp(setting, 'disnt')
    % Inequality adversion of optimal solutions
    out1(:) = 'NaN';

    idx = contains(in, 'g0');
    out1(idx) = '0';
    out2(idx) = 0;
    idx = contains(in, 'g0x5');
    out1(idx) = '0.5';
    out2(idx) = 0.5;
    idx = contains(in, 'g1x45');
    out1(idx) = '1.45';
    out2(idx) = 1.45;
    idx = contains(in, 'g2');
    out1(idx) = '2';
    out2(idx) = 2;
elseif strcmp(setting, 'Eland')
    % E land emissions
    idx = contains(in, 'BASE') | contains(in, 'CBA');
    out1(idx) = 'OPT';
    out2(idx) = 1;
    idx = contains(in, 'BAU');
    out1(idx) = 'BAU';
    out2(idx) = 2;
elseif strcmp(setting, 'coop')
    % Cooperation
    out1(:) = 'NaN';

    idx = contains(in, '_coop');
    out1(idx) = 'coop';
    out2(idx) = 1;
    idx = contains(in, 'noncoop');
    out1(idx) = 'noncoop';
    out2(idx) = 2;
end
end