clear all
clc 

% assume you use 25 days of histroical data to optimize portfolio and then 
% compare actual returns for the next 10 days with that optimized portfolio
% min days would be 35 and end_pred would be 25 (assuming we use the first 71.4%(=25/35) of days for parameter estimation)
%diff_days = min days - end_pred = 10 is the amount of time where we analyze the returns of the optimized portfolio

%% Temporary Asset information until user input is implemented

% Create cell array of asset names
assets = {'DOL.TO', 'FFH.TO', 'HBC.TO', 'BA.TO', 'BB.TO', 'AC-B.TO', ...
    'RON.TO', 'PGF.TO', 'MFC.TO', 'IMO.TO','ARX.TO'};
  n_assets=length(assets);

%Dollarama, , Hudson Bay company, Bell, blackberry, aircanada
%RONA, pengrove

market_name = '^GSPTSE'; %S&P/TSX Capped Composite
etf_name = 'XIC.TO'; %tracks the S&P/TSX Capped Composite Index

start_date = '15-April-2013';
end_date = '12-April-2014';

%retrieve data function takes in array of stock symbols, an index and a timeline and 
%returns asset data, market data and a vairable called min days (defined above)

[data, market, etf, min_days] = retrieve_data(assets, market_name, etf_name, start_date,...
    end_date);

desired_return_range = 0.0007;
initial_wealth = 100000;

end_pred = round(min_days * 0.75); % use the first 75% of days for parameter estimation

diff_days = min_days - end_pred;

%THe first line takes in the historical data and return the expected return into mu and the covariance matrix into Q
%The second line does the same but for the market index

h = { 'One Period MVO', 'MVO with Time'};

for i = 1:size(h,2);
    if strcmp(h{1,i}, 'Single Factor')
       [SF_x, SF_var, singlefactor_returns, SF_prices]=...
           one_period_SF(data, market, min_days, end_pred, initial_wealth, desired_return_range);
        plot(1:length(singlefactor_returns),singlefactor_returns, '-r');
        hold all
    end
    if strcmp(h{1,i}, 'One Period MAD')
       [MAD_x, MAD_var, oneperiod_MAD_returns, oneperiod_MAD_prices]=...
           one_period_MAD(data, min_days, end_pred, initial_wealth, desired_return_range);
        plot(1:length(oneperiod_MAD_returns),oneperiod_MAD_returns, '-b');
        hold all
    end
    if strcmp(h{1,i}, 'One Period MVO')
       [MVO_x, MVO_var, oneperiod_MVO_returns, oneperiod_MVO_prices]=...
           one_period_MVO(data, min_days, end_pred, initial_wealth, desired_return_range,n_assets);
        plot(1:length(oneperiod_MVO_returns),oneperiod_MVO_returns, '-b');
        hold all
    end
    if strcmp(h{1,i}, 'Market')
      market_price = market(end_pred:min_days,:);
      market_returns = market_price(2:diff_days + 1,:)./market_price(1:diff_days,:) - 1;
      plot(1:length(market_returns),market_returns, '-g');
      hold all
    end
    if strcmp(h{1,i}, 'ETF')
      etf_price = etf(end_pred:min_days,:);
      etf_returns = etf_price(2:diff_days + 1, :)./etf_price(1:diff_days,:)-1;
      plot(1:length(etf_returns),etf_returns, '-m');
    end
    if strcmp(h{1,i},'MVO with Time')
        [MVOx_t,MVOvar_t,multiperiod_MVO_returns,multiperiod_MVO_prices]=...
           multiperiod_MVO(data,min_days,end_pred,initial_wealth,desired_return_range,n_assets);
        plot(1:length(multiperiod_MVO_returns),multiperiod_MVO_returns,'-g');
        hold all          
    end
end
grid on;
h=legend(h);
%h = legend('Single Factor MVO', 'One period MAD','One period MVO', 'Market Return','ETF return');




