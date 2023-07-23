function  x = sharpe_ellipsoid_pen(mu, Q, N, alpha, lambda)
    % Find the total number of assets
    n = size(Q,1); 

    % Find the matrix of squared standard errors arising from the estimation of the asset expected returns
    theta = ((1/N)*diag(Q).*eye(n)).^0.5;

    % Scaling parameter that determines the size of our uncertainty set
    epsilon_two = sqrt(chi2inv(alpha,n));

    % Use the robust optimization objective function
    fun = @(x) lambda*transpose(x)*Q*x - (transpose(mu)*x-epsilon_two*norm(theta*x,2));
    x0 = 1/n.*(ones(n,1)); % this is where the optimizer starts checking
    
    % Set the options 
    opts = optimoptions(@fmincon,'Display','off');
    
    % Optimal asset weights

    A = [];
    b = [];
    Aeq = ones(1,n);
    beq = 1;
    lb = zeros(n,1);
    ub = [];
    x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],opts);
    
    %----------------------------------------------------------------------
    
end