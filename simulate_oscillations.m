% Simulate the phase oscillations for the system of coupled oscillations
function [t, theta] = simulate_oscillations(N, K, initvec, omegavec)
 if length(initvec) ~= N || length(omegavec) ~= N
     error('Incorrect vector length');
 end
 initvec = initvec(:);
 omegavec = omegavec(:);
 if N > 2 % MODIFY THIS CASE... it is still just running w/ t=100
     % We are now running the N >> 1 case in the code!
     % Iterate until we reach "steady state", which we interpret as being
     % when R - Rprev is within some tolerance
    [t, theta] = ode45(@(t, theta) rhs(t, theta, K/N, omegavec), [0 100], initvec);
 else
    % We are now running the N = 2 case; simply run 40 iterations
    [t, theta] = ode45(@(t, theta) rhs(t, theta, K/N, omegavec), [0 40], initvec);
 end
end
function dtheta = rhs(t, theta, scale, omegavec)
 dtheta = omegavec + scale*sum(sin(theta' - theta), 2);
end
