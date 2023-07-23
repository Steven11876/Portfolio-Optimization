function x = Tracking_Error(mu, Q)
    % Find the total number of assets
    n = size(Q,1); 
    

    % new stuff here
    k = 10;

    % gurobi stuff (x, then y)
    varTypes = [repmat('C', n, 1), repmat('B', n, 1)];

    % Gurobi accepts an objective function of the following form:
    % f(x) = x' Q x + c' x 

    current_prices = periodPrices(end,:);
    
    shares = [3.64	0.986	1.505	1.091	4.544	1.543	...
    4.345	3.326	5.157	4.525  6.938	0.858	6.456	...
    3.08	3.682	0.77	0.332	5.468	3.899	0.578];

    x_mkt = (current_prices.*shares./sum(current_prices.*shares))';
    
    % c vector
    model.obj = [-2*Q*x_mkt; zeros(n, 1)];

    % Define the Q matrix in the objective 
    Q  = [Q zeros(n); zeros(n,2*n)];
    model.Q = sparse(Q);
    
    % We must also include the target return constraint. We can add another row
    % onto matrix B to account for the target return constraint. Therefore, our
    % complete matrix A will have dimension (2n + 1) * 2n
    disp(size([zeros(1, n) ones(1, n); diag([ones(1, n)]) diag([ones(1, n)])*-1]))

    A = [zeros(1, n) ones(1, n); rets(end, :)*-1 zeros(1,n); diag([ones(1, n)]) diag([ones(1, n)])*-1];
    
    % We must also define the right-hand side coefficients of the inequality 
    % constraints, b, which is a column vector of dimension (2n + 1)
    
    b = [k; -(rets(end, :))*x_mkt; zeros(n, 1)];

    % We only have 2 equality constraints: the cardinality constraint (sum of
    % y's) and the budget constraint (sum of x's):
    
    Aeq = [ones(1, n) zeros(1, n)];
    
    % We must also define the right-hand side coefficients of the equality 
    % constraints, beq:
    
    beq = 1;


    model.A = [sparse(Aeq); sparse(A)];
    disp(size(model.A));
    
    % Define the right-hand side vector b
    model.rhs = full([beq; b]);

    % Indicate whether the constraints are ">=", "<=", or "="
    model.sense = [ repmat('=', 1, 1) ; repmat('<', n+2, 1) ];

    % Define the variable type (continuous, integer, or binary)
    model.vtype = varTypes;

    % Define the variable upper and lower bounds
    lb = zeros(2*n, 1);
    ub = ones(2*n, 1); 

    model.lb = lb;
    model.ub = ub;

    % Set some Gurobi parameters to limit the runtime and to avoid printing the
    % output to the console. 
    clear params;
    params.TimeLimit = 100;
    params.OutputFlag = 0;

    results = gurobi(model,params);
    res = results.x;
    disp(res);
    x = res(1:n);



    
    fprintf('Optimal obj. value: %1.6f \n\nAsset weights:\n', results.objval);
    disp(results.x);
    disp(size(results.x));
    
    %----------------------------------------------------------------------
    
end
