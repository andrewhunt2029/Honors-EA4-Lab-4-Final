%% Lab 4: Synchronization - Main Driver Script

%clear; clc; close all; 

rng(1);

% ----- Part 1: N = 2 case -----

N = 2; % number of oscillators

% Case 1: diff omega > K
omegavec = [0.5, 1.2];
initvec = [0, 0]; % initial theta vals
K = 0.5;
[t, theta] = simulate_oscillations(N, K, initvec, omegavec, [0 40]);
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
[t, theta] = simulate_oscillations(N, K, initvec, omegavec, [0 40]);
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
    [t, theta] = simulate_oscillations(N, K, initvec, omegavec, [0 100]);

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

% Initialize parameters
K_anim = 3.0; % K well above Kc so that synchronization is clearly visible.
N_anim = 50;

% Random initial conditions drawn from the same distribution as the main
% code.
initvec_anim = 2*pi*rand(1, N_anim);
omegavec_anim = randn(1, N_anim) + 1;

% Use a linspace tspan so that frames are evenly distributed and smooth.
[t_anim, theta_anim] = simulate_oscillations(N_anim, K_anim, initvec_anim, omegavec_anim, linspace(0, 40, 400));

% Unit circle outline
theta_circle = linspace(0, 2*pi, 200);
figure('Name', 'Kuramoto Oscillators on Unit Circle');

% Empty struct for each frame.
M = struct('cdata', {}, 'colormap', {}); 

for frame = 1:length(t_anim)
    clf;
    hold on; axis equal; axis([-1.5 1.5 -1.5 1.5]);

    %Draw unit circle.
    plot(cos(theta_circle), sin(theta_circle), 'g', 'LineWidth', 0.5);

    %Plot each oscillator as a fixed position on the unit circle.
    scatter(cos(theta_anim(frame,:)), sin(theta_anim(frame,:)), 40, 'b', 'filled');

    %Compute order parameter (uses simplified formula to the longer one
    %above).
    z_mean = mean(exp(1i * theta_anim(frame,:)));
    R_now = abs(z_mean);
    Psi_now = angle(z_mean);

    % Draw R as an arrow from the center to the centroid.
    quiver(0, 0, R_now*cos(Psi_now), R_now*sin(Psi_now), 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'AutoScale', 'off');

    title(sprintf('t = %.1f,   R = %.3f,   K = %.1f', t_anim(frame), R_now, K_anim));
    xlabel('cos θ'); ylabel('sin θ');
    grid on;

    drawnow;
    M(frame) = getframe(gcf); %Capture the frame
end

%Save all captured frames to a video file.
v = VideoWriter('kuramoto_sync.mp4', 'MPEG-4');
v.FrameRate = 24;
open(v);
writeVideo(v, M);
close(v);
fprintf("Extra credit 1 done\n");


% EXTRA CREDIT 3: solve for gaussian numerically, and overlay R(K)

% instead of the sqrt approximation, directly solve the implicit equation
% 1 = K * integral(cos^2(theta) * g(KR*sin(theta)), -pi/2, pi/2)
% for R at each K value, giving the exact theoretical R(K) curve


% Gaussian frequency distribution g(omega), zero mean, std = sigma
% zero mean because equation (4.7) is written in the co-rotating frame
g = @(omega) (1/(sqrt(2*pi))) * exp(-omega.^2 / 2);

% only solve for K > Kc since R=0 is the only solution below threshold
Kvals_theory = linspace(Kc, 4, 200);
R_theory = zeros(1, length(Kvals_theory));

for ki = 1:length(Kvals_theory)
    K_t = Kvals_theory(ki);

    % residual function: equals zero when R satisfies equation (4.7) exactly
    % fzero searches the interval [1e-6, 1-1e-6] for a root
    % lower bound avoids R=0 (trivial solution) upper bound keeps R physical
    residual = @(R) K_t * integral(@(theta) cos(theta).^2 .* g(K_t * R * sin(theta)), -pi/2, pi/2) - 1;
    try
        R_theory(ki) = fzero(residual, [1e-6, 1-1e-6]);
    catch
        % fzero fails near Kc where the R>0 branch is very close to zero
        R_theory(ki) = 0;
    end
end

% plot simulation, sqrt approximation, and exact theory on the same axes
figure('Name', sprintf('R(K) | N = %d with theory overlay', N));
plot(Kvals, R, 'b-', 'LineWidth', 1, 'DisplayName', 'Simulation R(K)'); hold on;
xline(Kc, '-', {'K_c'}, 'DisplayName', 'K_c');
plot(Kvals(1:length(Rpredic)), Rpredic, 'r--', 'LineWidth', 1, 'DisplayName', 'Kuramoto sqrt approximation');
plot(Kvals_theory, R_theory, 'g-', 'LineWidth', 2, 'DisplayName', 'Exact theory (numerical)');
xlabel('Coupling Strength K'); ylabel('Order Parameter R');
title(sprintf('Order Parameter R(K) | N = %d', N));
legend; grid on;
fprintf("Extra credit 3 done\n");
