function [c, ceq] = ellipsoidalConstraint(x, mu, epsilon, theta, targetRet)
c = targetRet - (mu' * x - epsilon*norm(theta*x,2));
ceq = [];