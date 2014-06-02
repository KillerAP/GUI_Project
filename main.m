clear all
clc 

% assume you use 25 days of histroical data to optimize portfolio and then 
% compare actual returns for the next 10 days with that optimized portfolio
% min days would be 35 and end_pred would be 25 (assuming we use the first 71.4%(=25/35) of days for parameter estimation)
%diff_days = min days - end_pred = 10 is the amount of time where we analyze the returns of the optimized portfolio

%% Temporary Asset information until user input is implemented


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

desired_return_range = 0.0007;
initial_wealth = 100000;

end_pred = round(min_days * 0.75); % use the first 75% of days for parameter estimation

diff_days = min_days - end_pred;

%THe first line takes in the historical data and return the expected return into mu and the covariance matrix into Q
%The second line does the same but for the market index

h = {'MVO_with_time', 'one_period_MAD', 'one_period_MVO', 'Single Factor'};

for i = 1:size(h,2);
    if strcmp(h{1,i}, 'Single Factor')
       [SF_x, SF_var, projected_returns, projected_prices]=...
           one_period_SF(data, market, min_days, end_pred, initial_wealth, desired_return_range);
    end
    if strcmp(h{1,i}, 'one_period_MAD')
       [MAD_x, MAD_var, projected_returns2, projected_prices]=...
           one_period_MAD(data, min_days, end_pred, initial_wealth, desired_return_range);
    end
    if strcmp(h{1,i}, 'one_period_MVO')
       [MAD_x, MAD_var, projected_returns3, projected_prices]=...
           one_period_MVO(data, min_days, end_pred, initial_wealth, desired_return_range);
    end
end

plot(1:length(projected_returns),projected_returns, 'r');
hold all
plot(1:length(projected_returns),projected_returns2, 'b');
hold all
plot(1:length(projected_returns),projected_returns3, 'k');

market_price = market(end_pred:min_days,:);
market_returns = market_price(2:diff_days + 1,:)./market_price(1:diff_days,:) - 1;

hold all
plot(1:length(projected_returns),market_returns, 'g');
