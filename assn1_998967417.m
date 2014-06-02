
close all;
clear all;
clc;

%% ACQUIRE DATA FROM YAHOO FINANCE

% Create cell array of asset names
assets = {'BMO', 'TD.TO', 'RBC', 'RY.TO', 'CM.TO', 'WWE', 'MSFT', ...
    'RCI-B.TO', 'DIS', 'WMT'};

% Collect relevant asset data from Yahoo Finance
Connect = yahoo;

for i = 1:length(assets);
    temp = fetch(Connect, assets{i}, 'Close', '20-Dec-2013', '12-Feb-2014');
    data(:,i) = temp(1:35,2);
end

% S&P/TX market data
market_temp =...
fetch(Connect, '^GSPTSE', 'Close', '20-Dec-2013', '12-Feb-2014');
market(:,1) = market_temp(1:35,2);
data = flipud(data);
%% DETERMINE PARAMETERS FOR ASSETS


r_it = (data(2:end,:)./data(1:end-1,:)) - 1;
[T, n] = size(r_it); %time periods, assets
mu = prod(1+r_it).^(1/T) - 1;
Q = cov(r_it);

r_M = (market(2:end,:)./market(1:end-1,:)) - 1;
mu_M = prod(1+r_M).^(1/T) - 1;

%% STANDARD MVO VIA QUADPROG
disp('MVO')

% Set quadprog parameters
c = [zeros(10,1);];
Aeq = [ones(1,10);];
beq = [1;];
lb = [zeros(10,1);];
ub = [];
R = 0:0.00005:max(mu);

% Set quadprog options
options = optimset('Algorithm', 'active-set', 'TolFun', 1/10^8, 'MaxFunEvals', 100, 'MaxIter', 100);

%Solve MVO and store SD values for plotting

for i = 1:length(R);
    A = -mu;
    b = -R(i);
    
    [MVO_x(i,:), MVO_var(i,1)] = quadprog(Q, c, A, b,Aeq, beq, lb, ub, [], options);
    MVO_std(i,1) = (2 * MVO_var(i,1)).^.5;
end
   
%% MAD VIA LINPROG

disp('MAD')

% Set quadprog parameters
c = [zeros(n,1); ones(T,1); ones(T,1)]; %[x_i, y_t, z_t]
Aeq = [r_it - repmat(mu,T,1) -eye(T) eye(T);
        ones(1,n) zeros(1, 2*T);];
beq = [zeros(T,1); 1;];
lb = zeros(n+T+T,1);


% Solve MAD and store SD values for plotting
for a = 1:length(R);
    A = -[mu zeros(1,2*T);];
    b = -R(a);
    [MAD_x(:,a), fval(a,1)] = linprog(c, A, b, Aeq, beq, ...
                                        lb, ub, [], options);
end

fval = fval / T;
MAD_std = (pi/2)^(1/2) * fval;

%% SINGLE FACTOR VIA QUADPROG
disp('SF')

del_M=sum((r_M(:,1) - mu_M(1)).^2)/T; % Factor variance
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
                                      lb,ub,[],options);
    SF_std(i,1)=(SF_x(i,:)*Q_sf*SF_x(i,:)')^.5;
end

% Plot the efficient frontiers of the three
plot(MVO_std, R, '-r');
hold all;
plot(MAD_std, R, '-b');
hold all;
plot(SF_std, R, '-g');
xlabel('Volatility \sigma');
ylabel('Expected return R');
legend('MVO','MAD','SF',0);
title('Comparision between the efficient frontiers of MVO, MAD, and SF');

