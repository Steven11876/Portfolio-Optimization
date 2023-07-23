function  x = MVO(mu, Q)
    % Find the total number of assets
    n = size(Q,1); 
    
    % Set the target as the average expected return of all assets
    targetRet = mean(mu);
    
    % Disallow short sales
    lb = zeros(n,1);

    % Add the expected return constraint
    A = -1 .* mu';
    b = -1 * targetRet;

    % Constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    x = quadprog( 2 * Q, [], A, b, Aeq, beq, lb, [], [], options);
    
    %----------------------------------------------------------------------
    
end