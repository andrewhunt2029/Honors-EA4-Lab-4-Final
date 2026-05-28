%% Lab 4: Synchronization - Main Driver Script

%clear; clc; close all; 

rng(1);

% ----- Part 1: N = 2 case -----

N = 2; % number of oscillators

% Case 1: diff omega > K
omegavec = [0.5, 1.2];
initvec = [0, 0]; % initial theta vals
K = 0.5;
[t, theta] = simulate_oscillations(N, K, initvec, omegavec);
% theta is matrix of size [t, N]
% Plot results
figure('Name', 'Oscillations | N = 2, diff omega > K');
plot(t, theta(:, 1), 'b-',  'LineWidth', 1,   'DisplayName', '1st oscillator'); hold on;
plot(t, theta(:, 2),  'r-', 'LineWidth', 1, 'DisplayName', '2nd oscillator');
xlabel('iterations t'); ylabel('phase angle (radians)');
title('Oscillations | N = 2, diff omega > K');
legend; grid on;

fprintf("N = 2, Case 1 done\n");

% Case 2: diff omega < K
omegavec = [0.5, 0.7];
initvec = [0, 2];
K = 0.5;
[t, theta] = simulate_oscillations(N, K, initvec, omegavec);
% Plot results
figure('Name', 'Oscillations | N = 2, diff omega < K');
plot(t, theta(:, 1), 'b-',  'LineWidth', 1,   'DisplayName', '1st oscillator'); hold on;
plot(t, theta(:, 2),  'r-', 'LineWidth', 1, 'DisplayName', '2nd oscillator');
xlabel('iterations t'); ylabel('phase angle (radians)');
title('Oscillations | N = 2, diff omega < K');
legend; grid on;

fprintf("N = 2, Case 2 done\n");

% expected result from mathematical analysis: no fixed points for Case 1 (not enough coupling
% strength); for Case 2, fixed points at arcsin(diffomega/K) and pi - arcsin(diffomega/K) 

% ----- Part 2: N >> 1 Case, varying K -----

N = 250;

Kvals = linspace(0, 4, 251);
R = zeros(1, length(Kvals)); % vector of order parameter... "center of mass distances" / "proximity to synchronization"

for K = Kvals % cycle through uniform range of coupling strengths
    
    % Define random initial conditions
    initvec = 2*pi*rand(1, N); % initial theta vals vector, random from uniform distribution 0 to 2pi
    omegavec = randn(1, N) + 1; % initial omega vals vector, random from Gaussian curve

    % run integration of equation, where theta = phase
    [t, theta] = simulate_oscillations(N, K, initvec, omegavec);

    % theta, thetap are matrices of size [t, N]

    % Find R
    R(Kvals == K) = (1/N)*sqrt(sum(cos(theta(end, :)))^2 + (sum(sin(theta(end, :)))^2)); % <--- should be an equivalent calculation
    %R(Kvals == K) = (1/N)*abs(sum(exp(1i*theta(end, :))));
end

fprintf("N >> 1 Case done\n");

% Calculate threshold coupling strength, Kc
% Kc = the coupling strength such that, if K > Kc, solutions R > 0 exist
Kc = 2*sqrt(2/pi); % where sigma = 1

% Calculate Kuramoto's Prediction function, the vector Rpredic,
% with guess proportionality constant a
a = 0.9;
Rpredic = a .* sqrt(Kvals - Kc);
Rpredic = Rpredic(1, 1:(find(Rpredic > 1, 1)));

% Plot R vals with respect to K vals
figure('Name', sprintf('R(K) | N = %d', N));
plot(Kvals, R, 'b-',  'LineWidth', 1,   'DisplayName', 'R(K)'); hold on;
xline(Kc,'-',{'Threshold Coupling Strength'}, 'DisplayName', 'Kc'); hold on;
plot(Kvals(1, 1:length(Rpredic)), Rpredic, 'r-','LineWidth', 1,   'DisplayName', 'Kuramoto Prediction');
xlabel('Coupling Strength K'); ylabel('Order Parameter R');
title(sprintf('Order Parameter R as a function of K | N = %d', N));
legend; grid on;

% EXTRA CREDIT 1: movie

% EXTRA CREDIT 2: verify Lorentzian

% EXTRA CREDIT 3: solve for gaussian numerically, and overlay R(K)

% need array M containing content
