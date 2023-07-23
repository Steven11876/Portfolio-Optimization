function x = Correlation_Index(mu, Q)
    % Find the total number of assets
    n = size(Q,1); 
    

    % new stuff here
    correlation = corrcov(Q);
    disp(correlation);
    k = 10;

    % gurobi stuff 
    varTypes = [repmat('B', n+n*n, 1)];

    % Gurobi accepts an objective function of the following form:
    % f(x) = x' Q x + c' x 
    
    % Define the Q matrix in the objective 
    Q  = zeros(n+n*n);
    model.Q = sparse(Q);
    % c vector
    model.obj = [zeros(1, n) -1.*correlation(:)'];
    
    Aeq = zeros(n+1, n+n*n);
    for i = 1:n+1
        Aeq(i,(i-1)*n+1:(i-1)*n+n)= 1;
    end
    beq = [k; ones(n, 1)];
    

    A = zeros(n*n, n+n*n);
    for j = 1:n
        for i = 1:n
            A((j-1)*n+i, j)= -1; % y_j = -1
            A((j-1)*n+i, n*i+j)= 1; % z_ij = 1
        end
    end
    b = zeros(n*n, 1);

    model.A = [sparse(Aeq); sparse(A)];
    disp(size(model.A));
    
    % Define the right-hand side vector b
    model.rhs = full([beq; b]);

    % Indicate whether the constraints are ">=", "<=", or "="
    model.sense = [ repmat('=', (n + 1), 1) ; repmat('<', n*n, 1) ];

    % Define the variable type (continuous, integer, or binary)
    model.vtype = varTypes;

    % Define the variable upper and lower bounds
    lb = zeros(n+n*n, 1);
    ub = ones(n+n*n, 1); 

    model.lb = lb;
    model.ub = ub;

    % Set some Gurobi parameters to limit the runtime and to avoid printing the
    % output to the console. 
    clear params;
    params.TimeLimit = 100;
    params.OutputFlag = 0;

    results = gurobi(model,params);
    res = results.x;
    y = [res(1:n)];
    z = reshape(res(n+1:end), [n,n])';

    current_prices = periodPrices(end,:);
    shares = [3.64	0.986	1.505	1.091	4.544	1.543 4.345	3.326	5.157	4.525  6.938	0.858	6.456	3.08	3.682	0.77	0.332	5.468	3.899	0.578];
    
    x = zeros(n, 1);
    V = shares .* current_prices;
    for j=1:n
        num = 0;
        denum = 0;
        for i =1:n
            num = num + z(i,j)*V(i);
            denum = denum + V(i);
        end
        x(j) = num/denum;
    end

    
    fprintf('Optimal obj. value: %1.6f \n\nAsset weights:\n', results.objval);
    disp(results.x);
    disp(size(results.x));
    
    %----------------------------------------------------------------------
    
end
