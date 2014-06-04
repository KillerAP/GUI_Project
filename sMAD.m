function [ MAD_x MAD_var ] = sMAD(time_series, return_range, mu)
%% STANDARD MEAN ABSOLUTE DEVIATION MODEL VIA LINPROG
% Input the time series data, the range of desired returns, and the
% mean vector, and the function will return the optimal portvolio weights
% in MAD_x and the corresponding portfolio variances in MAD_var.
R = return_range;
r_it = time_series;
[T, n_assets] = size(r_it);


c = [zeros(n_assets,1); ones(T,1); ones(T,1)]; %[x_i, y_t, z_t]
Aeq = [r_it-repmat(mu,T,1) -eye(T) eye(T);
        ones(1,n_assets) zeros(1, 2*T);];
beq = [zeros(T,1); 1;];
lb = zeros(n_assets+T+T,1);
ub = [];


% Solve MAD and store SD values for plotting
for a = 1:length(R);
    A = -[mu zeros(1,2*T);];
    b = -R(a);
    [MAD_x(:,a), fval(a,1)] = linprog(c, A, b, Aeq, beq, ...
                                        lb, ub, []);
end

MAD_x = MAD_x';
MAD_x = MAD_x(:,1:n_assets);

fval = fval / T;
MAD_var = (pi/2)^(1/2) * fval;
MAD_var = MAD_var.^2;
end

