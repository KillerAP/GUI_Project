    function [ SF_x, SF_var] = sSF( r_it, r_M, return_range, mu, mu_M)
%% SINGLE FACTOR MEAN VARIANCE OPTIMIZATION VIA QUADPROG
% Input the historical return data for assets, return data for the market, range of desired returns
% the mean vector for the assets and the mean return of the market. The function will return
% optimal portfolio weights in SF_x, and the corresponding variance 
% function value in SF_var.
%
% [optimal weights, corresponding optimal objective function] 
%   = sMVO(asset return data, market return data,range of desired returns, expected return vector for assets, 
%          expected return of the market)

R = return_range;

[T, n_assets] = size(r_it);

del_M=sum((r_M(:,1) - mu_M(1)).^2)/T; % Factor variance
beta=(sum(r_it(:,1:end).*repmat(r_M(:,1),1,n_assets))/T-mean(r_it(:,1:end)*...
    mean(r_M(:,1)))/del_M); 
alpha = mu(1:end)-beta*mu_M;
c = [zeros(n_assets,1);];
Aeq = ones(1, n_assets);
beq = 1;
lb = zeros(100,1);
ub = [];
options = optimset('Algorithm', 'active-set', 'TolFun', 1/10^8, 'MaxFunEvals', 100, 'MaxIter', 100);

%Noise vector
for i=1:n_assets
    epsi(:,i)=r_it(:,i)-(alpha(i)+beta(i)*r_M(:,1));
end
del_epsi=diag(cov(epsi));

% Single factor covariance 
for i = 1:n_assets;
    for j = 1:n_assets;
        if i==j
            Q_sf(i,i)=beta(i)^2*del_M+del_epsi(i);
        else
            Q_sf(i,j)=beta(i)*beta(j)*del_M;
        end
    end
end
            
% Solve Single Factor model and store SD values

for i = 1:length(R);
    A=-(alpha+beta*mu_M(1));
    b=-R(i);
    [SF_x(i,:), fval(i,1)] = quadprog(Q_sf, c, A,b, Aeq,beq,...
                                      lb, ub, [], options);
    SF_var(i,1)=(SF_x(i,:)*Q_sf*SF_x(i,:)');
end


end

