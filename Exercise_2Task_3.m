% Exercise 2 - Task 3: PDF Plots and Threshold Visualization
clear; close all; clc;

%% Parameters (same as Task 2)
MC = 1e5;
N = 50;
A = 1;
sigma2 = 1;
sigma = sqrt(sigma2);

% Unit-norm DC signal
s = ones(N,1)/sqrt(N);

% Decision threshold
gamma = A/2;

%% Generate test statistic data (same as Task 2)
T_H0 = zeros(MC,1);
T_H1 = zeros(MC,1);

for mc = 1:MC
    w = sigma * randn(N,1);
    
    % H0: noise only
    x_H0 = w;
    T_H0(mc) = sum(x_H0 .* s);
    
    % H1: signal + noise
    x_H1 = A*s + w;
    T_H1(mc) = sum(x_H1 .* s);
end

%% Plot Theoretical and Simulated PDFs
figure('Position', [100, 100, 1200, 500]);

% Subplot 1: Theoretical PDFs with shaded error regions
subplot(1,2,1);
x_vals = linspace(-3, 4, 1000);
pdf_H0 = normpdf(x_vals, 0, sigma);
pdf_H1 = normpdf(x_vals, A, sigma);

% Plot theoretical PDFs
plot(x_vals, pdf_H0, 'b-', 'LineWidth', 2); hold on;
plot(x_vals, pdf_H1, 'r-', 'LineWidth', 2);

% Plot threshold line
xline(gamma, 'k--', 'LineWidth', 2, 'Label', ['\gamma = ', num2str(gamma)]);

% Shade false alarm region (P_FA)
x_fa = x_vals(x_vals > gamma);
pdf_fa = pdf_H0(x_vals > gamma);
fill([x_fa, fliplr(x_fa)], [pdf_fa, zeros(1,length(x_fa))], ...
     [0.8 0.8 1], 'FaceAlpha', 0.5, 'EdgeColor', 'none');

% Shade missed detection region (P_M)
x_md = x_vals(x_vals <= gamma);
pdf_md = pdf_H1(x_vals <= gamma);
fill([x_md, fliplr(x_md)], [pdf_md, zeros(1,length(x_md))], ...
     [1 0.8 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'none');

xlabel('Test Statistic T(x)');
ylabel('Probability Density');
title('Theoretical PDFs with Error Regions');
legend('p(T|H₀)', 'p(T|H₁)', 'Threshold', 'P_{FA} Region', 'P_{M} Region', 'Location', 'northeast');
grid on;

% Subplot 2: Simulated vs Theoretical PDFs
subplot(1,2,2);
% Plot histograms (normalized to PDF)
histogram(T_H0, 80, 'Normalization', 'pdf', 'FaceColor', 'blue', 'FaceAlpha', 0.6); hold on;
histogram(T_H1, 80, 'Normalization', 'pdf', 'FaceColor', 'red', 'FaceAlpha', 0.6);

% Overlay theoretical PDFs
plot(x_vals, pdf_H0, 'b-', 'LineWidth', 2);
plot(x_vals, pdf_H1, 'r-', 'LineWidth', 2);

% Plot threshold line
xline(gamma, 'k--', 'LineWidth', 2, 'Label', ['\gamma = ', num2str(gamma)]);

xlabel('Test Statistic T(x)');
ylabel('Probability Density');
title('Theoretical vs Simulated PDFs');
legend('Sim H₀', 'Sim H₁', 'Theory H₀', 'Theory H₁', 'Threshold', 'Location', 'northeast');
grid on;

%% Display distribution statistics for verification
fprintf('Distribution Statistics Verification:\n');
fprintf('T|H₀: Mean = %.4f (theory: 0.0000), Std = %.4f (theory: 1.0000)\n', mean(T_H0), std(T_H0));
fprintf('T|H₁: Mean = %.4f (theory: 1.0000), Std = %.4f (theory: 1.0000)\n', mean(T_H1), std(T_H1));

