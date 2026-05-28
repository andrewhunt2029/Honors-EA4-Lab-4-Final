% Simulate the phase oscillations for the system of coupled oscillations
function [t, theta] = simulate_oscillations(N, K, initvec, omegavec, tspan)
 if length(initvec) ~= N || length(omegavec) ~= N
     error('Incorrect vector length');
 end
     % MODIFY THIS CASE... it is still just running w/ t=100
     % We are now running the N >> 1 case in the code!
     % Iterate until we reach "steady state", which we interpret as being
     % when R - Rprev is within some tolerance
    initvec = initvec(:);
    omegavec = omegavec(:);
    [t, theta] = ode45(@(t, theta) rhs(t, theta, K/N, omegavec), tspan, initvec);

end
function dtheta = rhs(t, theta, scale, omegavec)
 dtheta = omegavec + scale*sum(sin(theta' - theta), 2);
end
