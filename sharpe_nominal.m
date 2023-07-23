function  x = MVO_Sharpe(mu, Q)
    % Find the total number of assets
    n = size(Q,1); 
    
    % Disallow short sales
    lb = zeros(n+1,1);

    % Define the Q matrix in the objective 
    Q  = [Q zeros(n, 1) ; zeros(1,n+1)];
    
    A = [];
    b = [];
    Aeq = [mu' 0; ones(1, n) -1];
    beq = [1; 0];

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    res = quadprog( 2 * Q, [], A, b, Aeq, beq, lb, [], [], options);

    y = res(1:end-1);
    k = res(end);

    x = y./k;
    
    %----------------------------------------------------------------------
    
end