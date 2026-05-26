%% Lab 4: Synchronization - Main Driver Script

clear; clc; close all;

% ----- Part 1: example of how to integrate phase system -----

% Define initial conditions

K = 1; % coupling strength
N = 50; % number of oscillators
initvec = zeros(1, N); % initial theta vals vector
omegavec = zeros(1, N); % initial omega vals vector

% run integration of equation, where theta = phase
[t, theta, thetap] = simulate_oscillations(N, initvec, omegavec);

% theta, thetap are matrices of size [t, N]

% ----- Part 2: N = 2 case -----

N = 2;

% Case 1: diff omega > K
omega1 = 20;
omega2 = 10;
K = 5;
[t, theta, thetap] = simulate_oscillations(N, initvec, [omega1, omega2])
% Plot results
figure('Name', 'Oscillations | N = 2, diff omega > K');
plot(t, theta(1, :), 'k-',  'LineWidth', 2,   'DisplayName', '1st oscillator'); hold on;
plot(t, theta(2, :),  'r--', 'LineWidth', 2, 'DisplayName', '2nd oscillator');
xlabel('\omega'); ylabel('Response Amplitude R');
title('Oscillations | N = 2, diff omega > K');
legend; grid on;

% Case 2: diff omega < K
omega1 = 20;
omega2 = 10;
K = 5;
[t, theta, thetap] = simulate_oscillations(N, initvec, [omega1, omega2])
figure('Name', 'Oscillations | N = 2, diff omega < K');
plot(t, theta(1, :), 'k-',  'LineWidth', 2,   'DisplayName', '1st oscillator'); hold on;
plot(t, theta(2, :),  'r--', 'LineWidth', 2, 'DisplayName', '2nd oscillator');
xlabel('\omega'); ylabel('Response Amplitude R');
title('Oscillations | N = 2, diff omega < K');
legend; grid on;

% expected result from mathematical analysis: no fixed points for Case 1 (not enough coupling
% strength_; fixed points at arcsin(diffomega/K) and pi - arcsin(diffomega/K) 

% ----- Part 3: N >> 1 Case, varying K -----

for K = 0:0.01:1 % coupling strengths vector
    
    % Define initial conditions
    N = 50; % number of oscillators
    initvec = zeros(1, N); % initial theta vals vector
    omegavec = zeros(1, N); % initial omega vals vector

    % run integration of equation, where theta = phase
    [t, theta, thetap] = simulate_oscillations(N, initvec, omegavec);

    % theta, thetap are matrices of size [t, N]
end



% EXTRA CREDIT 1: movie

% need array M containing content