clear all
clc 

% assume you use 25 days of histroical data to optimize portfolio and then 
% compare actual returns for the next 10 days with that optimized portfolio
% min days would be 35 and end_pred would be 25 (assuming we use the first 71.4%(=25/35) of days for parameter estimation)
%diff_days = min days - end_pred = 10 is the amount of time where we analyze the returns of the optimized portfolio


% Create cell array of asset names
assets = {'DOL.TO', 'FFH.TO', 'HBC.TO', 'BA.TO', 'BB.TO', 'AC-B.TO', ...
    'RON.TO', 'PGF.TO', 'MFC.TO', 'IMO.TO'};

%Dollarama, , Hudson Bay company, Bell, blackberry, aircanada
%RONA, pengrove

market_name = '^GSPTSE';

start_date = '15-April-2013';
end_date = '12-April-2014';

%retrieve data function takes in array of stock symbols, an index and a timeline and 
%returns asset data, market data and a vairable called min days (defined above)

[data, market, min_days] = retrieve_data(assets, market_name, start_date,...
    end_date);


end_pred = round(min_days * 0.75); % use the first 75% of days for parameter estimation

%THe first line takes in the historical data and return the expected return into mu and the covariance matrix into Q
%The second line does the same but for the market index

[mu, Q, r_it] = param_data(data, end_pred);
[mu_M, Q_M, r_M] = param_data(market, end_pred);

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
    SF_temp(i,1) = (2*fval(i,1))^(1/2);
end