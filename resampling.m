function  x = resampling(mu, Q, T, n, N)
    x_prime_storage = zeros(N,n);

    new_returns = zeros(T,n);
    for j=1:N
        for i=1:n
            new_returns(:,i) = normrnd(mu(i),Q(i,i), [T 1]);
        end
    
        mu_prime = geomean(new_returns+1)'-1;
        Q_prime = cov(new_returns);
        
        x_prime = MVO(mu_prime, Q_prime);
        x_prime_storage(j,:) = x_prime;
    end
    x = mean(x_prime_storage);
end