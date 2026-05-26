%% Lab 4: Synchronization - Main Driver Script

clear; clc; close all;

% ----- Part 1: N = 2 case -----

N = 2;

% Case 1: diff omega > K
omega1 = 20;
omega2 = 10;
initvec = [0, 2.5]; % initial theta vals
K = 5;
[t, theta] = simulate_oscillations(N, K, initvec, [omega1, omega2]);
% Plot results
figure('Name', 'Oscillations | N = 2, diff omega > K');
plot(t, theta(:, 1), 'k-',  'LineWidth', 2,   'DisplayName', '1st oscillator'); hold on;
plot(t, theta(:, 2),  'r--', 'LineWidth', 2, 'DisplayName', '2nd oscillator');
xlabel('\omega'); ylabel('Response Amplitude R');
title('Oscillations | N = 2, diff omega > K');
legend; grid on;

% Case 2: diff omega < K
omega1 = 20;
omega2 = 10;
K = 5;
[t, theta] = simulate_oscillations(N, initvec, [omega1, omega2]);
figure('Name', 'Oscillations | N = 2, diff omega < K');
plot(t, theta(:, 1), 'k-',  'LineWidth', 2,   'DisplayName', '1st oscillator'); hold on;
plot(t, theta(:, 2),  'r--', 'LineWidth', 2, 'DisplayName', '2nd oscillator');
xlabel('\omega'); ylabel('Response Amplitude R');
title('Oscillations | N = 2, diff omega < K');
legend; grid on;

% expected result from mathematical analysis: no fixed points for Case 1 (not enough coupling
% strength_; fixed points at arcsin(diffomega/K) and pi - arcsin(diffomega/K) 

% ----- Part 2: N >> 1 Case, varying K -----

N = 50; % number of oscillators
Kvals = 0:0.01:1;
R = zeros(1, length(Kvals)); % vector of order parameter... "center of mass distances" / "proximity to synchronization"

for K = Kvals % cycle through uniform range of coupling strengths
    
    % Define random initial conditions
    initvec = 2*pi*rand(1, N); % initial theta vals vector, random from uniform distribution 0 to 2pi
    omegavec = randn(1, N) + 1; % initial omega vals vector, random from Gaussian curve

    % run integration of equation, where theta = phase
    [t, theta] = simulate_oscillations(N, initvec, omegavec);

    % theta, thetap are matrices of size [t, N]

    % Find R
    R(Kvals == K) = (1/N)*sqrt(sum(cos(theta(end, :)))^2 + (sum(sin(theta(end, :)))^2));
end

% Calculate threshold coupling strength, Kc

%Kc = (FILL IN)*sqrt(2/pi);

% Plot R vals with respect to K vals
figure('Name', 'R(K) | N = %d', N);
plot(K, R, 'k-',  'LineWidth', 2,   'DisplayName', 'R(K)'); hold on;
xline(Kc,'-',{'Threshold Coupling Strength','Kc'});
xlabel('Coupling Strength K'); ylabel('Order Parameter R');
title('Order Parameter R as a function of K | N = %d', N);
legend; grid on;

% EXTRA CREDIT 1: movie

% need array M containing content