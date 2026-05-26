% Simulate the phase oscillations for the system of coupled oscillations
function [t, theta] = simulate_oscillations(N, K, initvec, omegavec)
 if length(initvec) ~= N || length(omegavec) ~= N
     error('Incorrect vector length');
 end
 initvec = initvec(:);
 omegavec = omegavec(:);
 [t, theta] = ode45(@(t, theta) rhs(t, theta, K/N, omegavec), [0 50], initvec);
end
function dtheta = rhs(t, theta, scale, omegavec)
 dtheta = omegavec + scale*sum(sin(theta' - theta), 2);
end
