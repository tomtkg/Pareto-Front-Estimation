function PFE
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
    
    %% EMO2021 paper
    Fig1();    % Example of the proposed Pareto front estimation procedure
    Fig2to3(); % Pareto front estimation in m = 2 objective case
    Fig4();    % Pareto front estimation of Pareto fronts with different objective value ranges
    
    Fig5to7(); % Pareto front estimation with three objective vector samplers
    Fig8to9(); % Pareto front estimation in m = 3 objective case
    DTLZ7();   % Figure 3(a) and Figure 9(a)

    %% Doctoral Thesis
    FigD1toD2();  % Example of response surface methodology and
                  % the proposed Pareto front estimation procedure
    FigD3toD4();  % Pareto front estimation in m = 2 objective case
    FigD5();      % Pareto front estimation of Pareto fronts with different objective value ranges
    
    FigD6toD8();  % Pareto front estimation with three objective vector samplers
    FigD9toD10(); % Pareto front estimation in m = 3 objective case
    DDTLZ7();     % Figure 4(a) and Figure 10(a)
end
