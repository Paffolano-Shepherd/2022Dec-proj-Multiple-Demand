% Graphs

%% GMM Objectives - Nu
df_res = readmatrix('int/res_est.csv');
nu_opt = 0.36908;

% present results for selected nus
y = [df_res(1:8, :); df_res(49, :)];
y = y(:, 2);
x = [6 4 3 2 1 4+2*[0.2 0.4 0.6 nu_opt]];
[~, idx] = sort(x, 'ascend');
x = x(idx);
y = y(idx);
% benchmark unit-demand line
sol = gmm(-10000);
x0 = linspace(0, 7, 100);
y0 = x0 - x0 + sol.obj(2);
y1 = linspace(9.3, df_res(49, 2), 100);
x1 = y1 - y1 + 4+2*nu_opt;

% graph
figure;
set(gcf, 'color', 'white');
set(gcf, 'position', [100 100 720 480]);
axes;
plot(x0, y0, 'r--', 'LineWidth', 0.5);
set(gca, 'fontname', 'HGXFX_CNKI');
set(gca, 'fontsize', 10);
set(gca, 'fontweight', 'bold')
set(gca, 'TickLabelInterpreter','latex'); 
set(gca, 'box', 'off')
xlim([0.5 6.5]);
ylim([9.3 9.41]);
xl = xlabel('$e^{\nu}$', 'Interpreter', 'latex', 'FontSize', 15);
xl.Position(1) = xl.Position(1) + 3.1;
xl.Position(2) = xl.Position(2) + 0.015;
xticks([1 2 3 4 4+2*nu_opt 6]);
xticklabels({'$10^{-4}$', '$10^{-3}$', '$10^{-2}$', '$10^{-1}$', ...
             '$e^{\nu^*}=0.369$', '$1$'});
yticks(9.3);
yticklabels('0');
title("GMM Objective Values under Different $\nu$'s", 'Interpreter', 'latex', 'FontSize', 18);
subtitle('Y-axis: GMM objective values', 'Interpreter', 'latex', 'FontSize', 10);

hold on;
plot(x, y, 'blue', 'LineWidth', 1);
hold on;
scatter(x, y, 'blue', 'filled');
hold on;
plot(x1, y1, 'k--', 'LineWidth', 0.5);
hold on;
patch([6.3 6.3 6.5], [9.3005, 9.2995, 9.3], 'k', 'clipping', 'off')
hold on;
patch([0.485 0.515 0.5], [9.405, 9.405, 9.41], 'k', 'clipping', 'off')
hold on;
legend({'Unit Demand', 'Two Demand, $\nu$'}, 'location', 'west', 'Interpreter', 'latex');
hold off;

exportgraphics(gcf, 'fig/gmmobj_nu.png');


%% ds_unit V.S. ds_opt
ds_unit = gmm(-10000).ds;
df_res = readmatrix('int/res_ds.csv');
ds_opt = df_res(2:2218, df_res(1, :) == 0.36908);

% ds_unit > ds_opt: 2215 products
disp(sum(ds_unit > ds_opt));
dds = ds_unit - ds_opt;
[~, idx] = max(dds);
y0 = linspace(-0.01, dds(idx), 100);
x0 = y0 - y0 + ds_opt(idx);
% split into three periods
% 1971-1977
% 1978-1984
% 1985-1990
x1 = ds_opt(1:626);
y1 = dds(1:626);
x2 = ds_opt(627:1380);
y2 = dds(627:1380);
x3 = ds_opt(1381:2217);
y3 = dds(1381:2217);

% graph
figure;
set(gcf, 'color', 'white');
set(gcf, 'position', [100 100 720 480]);
axes;
scatter(x1, y1, 2, 'blue', 'filled');
set(gca, 'fontname', 'HGXFX_CNKI');
set(gca, 'fontsize', 10);
set(gca, 'fontweight', 'bold')
set(gca, 'TickLabelInterpreter','latex'); 
set(gca, 'box', 'off')
xlim([-14 -4]);
ylim([-0.002 0.06]);
xl = xlabel('$\delta_j$', 'Interpreter', 'latex', 'FontSize', 15);
xl.Position(2) = xl.Position(2) + 0.003;
xticks([-12 -6]);
xticklabels({'unpopular vehicles', 'popular vehicles'});
yticks([0 0.05]);
yticklabels({'0', '5e-2'});
title('Changes in $\delta_j$ for Different Models', 'Interpreter', 'latex', 'FontSize', 18);
subtitle('Y-axis: $\Delta\delta_j=\delta_j^{unit}-\delta_j^*$', 'Interpreter', 'latex', 'FontSize', 10);

hold on;
scatter(x2, y2, 2, 'green', 'filled');
hold on;
scatter(x3, y3, 2, 'red', 'filled');
hold on;
plot(x0, y0, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.1);
hold on;
patch([-4.3 -4.3 -4], [-0.0017, -0.0023, -0.002], 'k', 'clipping', 'off')
hold on;
patch([-14.03 -13.97 -14], [0.0575, 0.0575, 0.06], 'k', 'clipping', 'off')
hold on;
legend({'1971-1977', '1978-1984', '1985-1990'}, 'location', 'west', 'Interpreter', 'latex');
hold off;

exportgraphics(gcf, 'fig/dds_ds.png');


%% Shares of Bundle Purchases
global df T;
nu_opt = 0.36908;

% by-year market shares
s_multi = zeros(T, 1);
s_unit = zeros(T, 1);
for t = 1:T
    ds = ds_opt(df(:, 4) == t);
    n = max(size(ds));
    sum_unit = sum(exp(ds));
    sum_multi = 0;
    for i = 1:(n-1)
        for j = (i+1):n
            sum_multi = sum_multi + exp(nu_opt) * exp(ds(i)) * exp(ds(j));
        end
    end
    
    s_unit(t) = sum_unit / (sum_unit + sum_multi);
    s_multi(t) = sum_multi / (sum_unit + sum_multi);
end
% plot multiple-choice shares in years
y0 = s_multi;
x0 = 1:T;
x = linspace(0, 21, 100);
y = x - x + 0.05;

% graph
figure;
set(gcf, 'color', 'white');
set(gcf, 'position', [100 100 720 480]);
axes;
plot(x0, y0, 'blue', 'LineWidth', 1);
set(gca, 'fontname', 'HGXFX_CNKI');
set(gca, 'fontsize', 10);
set(gca, 'fontweight', 'bold')
set(gca, 'TickLabelInterpreter','latex'); 
set(gca, 'box', 'off')
xlim([0.5 20.5]);
ylim([0 0.1]);
xticks([1 7 14 20]);
xticklabels({'1971', '1977', '1984', '1990'});
yticks([0 0.05 0.06 0.07 0.08 0.09]);
yticklabels({'0', '5\%', '6\%', '7\%', '8\%', '9\%'});
title("Percentage of Multiple Choices", 'Interpreter', 'latex', 'FontSize', 18);
subtitle('X-axis: Years', 'Interpreter', 'latex', 'FontSize', 10);

hold on;
scatter(x0, y0, 'blue', 'filled');
hold on;
plot(x, y, 'r--', 'LineWidth', 0.5);
hold on;
I = legend({'Multiple-Choice Shares'}, 'location', 'south', 'Interpreter', 'latex');
I.Position(2) = I.Position(2) + 0.13;
hold off;

exportgraphics(gcf, 'fig/sh_multi.png');

