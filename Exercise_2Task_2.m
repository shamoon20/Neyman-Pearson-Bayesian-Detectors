% Exercise 2 - Task 2: Monte Carlo Simulation
clear; close all; clc;

%% Parameters
MC = 1e5;
N = 50;
A = 1;
sigma2 = 1;
sigma = sqrt(sigma2);
C10 = 2;
C01 = 2;

% Unit-norm DC signal
s = ones(N,1)/sqrt(N);

% Decision threshold
gamma = A/2;

%% Monte Carlo Simulation
T_H0 = zeros(MC,1);
T_H1 = zeros(MC,1);
decisions_H0 = zeros(MC,1);
decisions_H1 = zeros(MC,1);

for mc = 1:MC
    % Generate noise
    w = sigma * randn(N,1);
    
    % H0: noise only
    x_H0 = w;
    T_H0(mc) = sum(x_H0 .* s);
    decisions_H0(mc) = T_H0(mc) > gamma;
    
    % H1: signal + noise
    x_H1 = A*s + w;
    T_H1(mc) = sum(x_H1 .* s);
    decisions_H1(mc) = T_H1(mc) > gamma;
end

%% Performance Metrics
P_FA_sim = sum(decisions_H0) / MC;
P_M_sim = sum(~decisions_H1) / MC;
P_e_sim = 0.5 * (P_FA_sim + P_M_sim);
R_sim = C10 * 0.5 * P_M_sim + C01 * 0.5 * P_FA_sim;

%% Theoretical Calculations
P_FA_theory = qfunc(gamma / sigma);
P_M_theory = qfunc((A - gamma) / sigma);
P_e_theory = 0.5 * (P_FA_theory + P_M_theory);
R_theory = C10 * 0.5 * P_M_theory + C01 * 0.5 * P_FA_theory;

%% Display Results
fprintf('MC Simulation Results:\n');
fprintf('P_FA: theory=%.6f, sim=%.6f\n', P_FA_theory, P_FA_sim);
fprintf('P_M:  theory=%.6f, sim=%.6f\n', P_M_theory, P_M_sim);
fprintf('P_e:  theory=%.6f, sim=%.6f\n', P_e_theory, P_e_sim);
fprintf('Risk: theory=%.6f, sim=%.6f\n', R_theory, R_sim);
