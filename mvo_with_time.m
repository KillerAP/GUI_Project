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

[mu, Q] = param_data(data, end_pred);
[mu_M, Q_M] = param_data(market, end_pred);



% time horizon over which we are 'predicting'
diff_days = min_days - end_pred; 

% the vector of days in the time horizon
pred_days = 1:diff_days;

% calculate the actual returns of the portfolio and market over the
% prediction region

for i = 1:diff_days;
    new_end_pred = end_pred + i - 1;
    [mu, Q] = param_data(data, new_end_pred);
    [MVO_x(i,:), MVO_var(i)] = sMVO(10, 0.0007, mu, Q);
    
end


projection = data(end_pred:min_days, :)';
projected_returns = projection(:, 2:end)./projection(:, 1:end-1) - 1;
portfolio_price(1) = 100000;

for i = 1:length(projected_returns);
    portfolio_returns(i) = MVO_x(i,:) * projected_returns(:,i); 
    portfolio_price(i+1) = portfolio_price(i) * (1 + portfolio_returns(i));
end

market_price = market(end_pred:min_days,:);
market_returns = market_price(2:diff_days + 1,:)./market_price(1:diff_days,:) - 1;

%Portfolio returns is green
plot(pred_days,portfolio_returns, 'g')
hold all
%Market is blue
plot(pred_days,market_returns, 'b')


