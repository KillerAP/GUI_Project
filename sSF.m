function [ SF_x, SF_var] = sSF( r_it, r_M, return_range, mu, mu_M)
%SSF Summary of this function goes here
%   Detailed explanation goes here

el_M=sum((r_M(:,1) - mu_M(1)).^2)/T; % Factor variance
beta=(sum(r_it(:,1:end).*repmat(r_M(:,1),1,n))/T-mean(r_it(:,1:end)*...
    mean(r_M(:,1)))/del_M); 
alpha = mu(1:end)-beta*mu_M;
c = [zeros(n,1);];
Aeq = ones(1, n);
beq = 1;

%Noise vector
for i=1:n
    epsi(:,i)=r_it(:,i)-(alpha(i)+beta(i)*r_M(:,1));
end
del_epsi=diag(cov(epsi));

% Single factor covariance 
for i = 1:n;
    for j = 1:n;
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
                                      0,[],[],options);
    SF_std(i,1)=(SF_x(i,:)*Q_sf*SF_x(i,:)')^.5;
    SF_var = SF_var.^2;
    SF_temp(i,1) = (2*fval(i,1))^(1/2);
end

end

