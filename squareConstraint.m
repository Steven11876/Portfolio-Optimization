function [c, ceq] = squareConstraint(x, mu, delta, targetRet)
c = targetRet - (mu' * x - delta' * abs(x)); % if this doesn't work, try removing ' from delta
ceq = [];