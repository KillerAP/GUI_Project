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

disp('SF')
for i=1:n-1
    for j=1:n-1
        if i==j
            Q_sf(i,i)=beta(i)^2*del_M+del_epsi(i);
        else
            Q_sf(i,j)=beta(i)*beta(j)*del_M;
        end
    end
end

for a=1:length(R)
    A=-(alpha+beta*mu(1));
    b=-R(a);% RHS, the only pertubation for loop
    %%%%% quadratic optimization call %%%%%
    [x_sf(a,:), fval_sf(a,1)] = quadprog(Q_sf, c, A,b, Aeq,beq, lb,ub,[],options);
    std_sf(a,1)=(x_sf(a,:)*Q_sf*x_sf(a,:)')^.5; %standard deviation = (x'*Q*x)^.5
end