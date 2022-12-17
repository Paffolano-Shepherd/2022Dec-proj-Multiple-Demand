%% Set up Globals
global df iv N T;
df = readmatrix('raw/blp.csv');
iv = readmatrix('raw/iv.csv');
% number of data points: 2217
N = size(df, 1);
% number of markets: 20
T = length(unique(df(:, 4)));


%% Unit-Demand Benchmark
% alpha = -0.18545
% beta: const =-9.7515
%       mpd   = 7.3202e-2
%       air   = 1.03672
%       space = 2.23804
%       hpwt  = 2.65471
ds_unit = log(df(:, 11)) - log(df(:, 12));
coef = tsls(ds_unit, df(:, 5:10), iv);
alpha_unit = coef(1);
beta_unit = coef(2:6);


%% Sequential Two-Step GMM
% search on grids for optimal nu
% grid 1: [1 0.1 0.01 0.001 0.0001]
% grid 2: [0.2 0.4 0.6 0.8]
% grid 3: [0.28 0.36 0.44 0.52]
% grid 4: [0.30 0.32 0.34 0.36 0.38 0.40 0.42]
% grid 5: [0.345 0.35 0.355 0.36 0.365 0.37 0.375]
% grid 6: [0.361 0.362 0.363 0.364 0.366 0.367 0.368 0.369]
% grid 7: [0.3682 0.3684 0.3686 0.3688
%          0.3692 0.3694 0.3696 0.3698]
% grid 8: [0.36884 0.36888 0.36892 0.36896
%          0.36904 0.36908 0.36912 0.36916]
% optimal nu = log(0.36908) = -0.996742

% Ks = [1 0.1 0.01 0.001 0.0001]
% Ks = [0.2 0.4 0.6 0.8]
% Ks = [0.28 0.36 0.44 0.52]
% Ks = [0.30 0.32 0.34 0.36 0.38 0.40 0.42]
% Ks = [0.345 0.35 0.355 0.36 0.365 0.37 0.375]
% Ks = [0.361 0.362 0.363 0.364 0.366 0.367 0.368 0.369]
% Ks = [0.3682 0.3684 0.3686 0.3688 ...
%       0.3692 0.3694 0.3696 0.3698]
Ks = [0.36884 0.36888 0.36892 0.36896 ...
      0.36904 0.36908 0.36912 0.36916];
K = max(size(Ks));
nus = zeros(K, 1);
val1s = zeros(K, 1);
val2s = zeros(K, 1);
alphas = zeros(K, 1);
betas = zeros(K, 5);
dss = zeros(N, K);
for k = 1:K
    sol = gmm(log(Ks(k)));
    % optimal nu and minimum obj
    nus(k) = sol.nu;
    alphas(k) = sol.alpha;
    betas(k, :) = sol.beta';
    val1s(k) = sol.obj(1);
    val2s(k) = sol.obj(2);
    dss(:, k) = sol.ds;
end
% output
writematrix([val1s val2s nus alphas betas], 'int/pas.csv');
writematrix(dss, 'int/dss.csv')


%% Optimal Nu
% nu = log(0.36908) = -0.99674
% alpha = -0.18335
% beta: const =-9.7549
%       mpd   = 7.1556e-2
%       air   = 1.0239
%       space = 2.2137
%       hpwt  = 2.6134
sol = gmm(0.36908);
alpha_multi = sol.alpha;
beta_multi = sol.beta;
ds_unit = sol.ds;


%% Analysis
% market shares of bundles


