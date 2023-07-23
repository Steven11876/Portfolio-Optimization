function  x = MVO_Sharpe_ellipsoid(mu, Q, alpha)
    % Find the total number of assets
    n = size(Q,1); 
    
    % Disallow short sales
    lb = zeros(n);

    % Use the robust optimization objective function
    fun = @(x) x'*Q*x;
    x0 = 1/n.*(ones(n,1)); % this is where the optimizer starts checking

    % Find the matrix of squared standard errors arising from the estimation of the asset expected returns
    theta = ((1/n)*diag(Q).*eye(n)).^0.5;

    % Scaling parameter that determines the size of our uncertainty set
    epsilon_two = sqrt(chi2inv(alpha,n));
    
    A = -1.*ones(1, n);
    b = 0;
    Aeq = [];
    beq = [];

    % Set the options 
    opts = optimoptions(@fmincon,'Display','off');
    
    % Optimal asset weights
    y = fmincon(fun, x0, A, b, Aeq, beq, lb, [], @(x)ellipsoidalConstraint(x, mu, epsilon_two, theta, -1), opts);
    k = sum(y);
    x = y./k;
    
    %----------------------------------------------------------------------
    
end