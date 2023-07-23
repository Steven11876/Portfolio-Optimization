function x = Inner_Function(periodReturns, periodFactRet, x0)

    %
    % INPUTS: periodReturns, periodFactRet, x0 (current portfolio weights)
    % OUTPUTS: x (optimal portfolio)
    %
    %----------------------------------------------------------------------

    % Example: subset the data to consistently use the most recent 3 years
    % for parameter estimation
    returns = periodReturns(end-35:end,:);
    factRet = periodFactRet(end-35:end,:);
    
    % Example: Use an OLS regression to estimate mu and Q
    [mu, Q] = OLS(returns, factRet);
    
    % Example: Use MVO to optimize our portfolio
    x = MVO(mu, Q);

    %----------------------------------------------------------------------
end
