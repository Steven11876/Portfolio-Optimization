function  x = MVO_Sharpe_box(mu, Q, alpha)
    % Find the total number of assets
    n = size(Q,1); 
    
    % Disallow short sales
    lb = zeros(2*n,1);

    % Find the matrix of squared standard errors arising from the estimation of the asset expected returns
    theta = ((1/n)*diag(Q).*eye(n)).^0.5;

    % Define the Q matrix in the objective 
    Q  = [Q zeros(n) ; zeros(n,2*n)];
    
    % Box stuff
    tailarea = (1-alpha)/2;

    % Find the z-value for the lower tail
    z_lower = norminv(tailarea);
    
    % Find the z-value for the upper tail
    z_upper = norminv(1-tailarea);
    % The critical value is the absolute value of either z-value
    epsilon_one = max(abs(z_lower), abs(z_upper));
    delta = epsilon_one .* diag(theta);
    
    A = [-1.*mu' delta' ; 
        -1.*ones(1, n) zeros(1, n);
        eye(n) -1.*eye(n);
        -1.*eye(n) -1.*eye(n)];
    b = [1; 0; zeros(2*n, 1)];
    Aeq = [];
    beq = [];

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    res = quadprog( 2 * Q, [], A, b, Aeq, beq, lb, [], [], options);

    y = res(1:n);
    k = sum(y);
    x = y./k;
    
    %----------------------------------------------------------------------
    
end