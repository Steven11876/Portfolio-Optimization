function  x = MVO(mu, Q)
    n = size(Q,1); 
   
    % Disallow short sales
    lb = zeros(n,1);


    %constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    x = quadprog( 2 * Q, [], [], [], Aeq, beq, lb, [], [], options);    
    %----------------------------------------------------------------------
    
end