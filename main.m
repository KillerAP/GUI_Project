 clear all
 clc 

% assume you use 25 days of historical data to optimize portfolio and then 
% compare actual returns for the next 10 days with that optimized portfolio
% min days would be 35 and end_pred would be 25 (assuming we use the first 71.4%(=25/35) of days for parameter estimation)
%diff_days = min days - end_pred = 10 is the amount of time where we analyze the returns of the optimized portfolio

%% Temporary Asset information until user input is implemented
%{
% Create cell array of asset names
assets = {'DOL.TO', 'FFH.TO', 'HBC.TO', 'BA.TO', 'BB.TO', 'AC-B.TO', ...
    'RON.TO', 'PGF.TO', 'MFC.TO', 'IMO.TO','ARX.TO'};

%Dollarama, , Hudson Bay company, Bell, blackberry, aircanada
%RONA, pengrove
%}

%% SECTION I - Retrieving data and assigning parameters
tic
load('assets.mat');

%Add the relevant paths

addpath(genpath('MVO_functions\Work'));
%n_assets=length(assets);


market_name = '^GSPTSE'; %S&P/TSX Capped Composite
etf_name = 'XIC.TO'; %tracks the S&P/TSX Capped Composite Index

start_date = '12-August-2013';
end_date = '12-April-2014';

%retrieve data function takes in array of stock symbols, an index and a timeline and 
%returns asset data, market data and a vairable called min days (defined above)

%This function takes in as parameters: the names of the assets/market/etf, and the start shand end date
%It returns: daily returns, numbers of the assets with market caps, the market caps
%            of those respective assets, returns of the etf and min_days
[data, assets_with_market_caps, market, market_caps, etf, min_days, PE_ratios] = ...
retrieve_data(assets, market_name, etf_name, start_date,end_date);

%Now should use assets_with_market_caps to find the appropriate asset names for 
%the data retrieved(which all posesses market caps)
%we call this new array asset_names
asset_names=[];
for i=1:length(assets_with_market_caps)
  asset_names=[asset_names; assets((assets_with_market_caps(i)))];
end

%vector representing the r
desired_return_range = 0.0007;
initial_wealth = 100000;

end_pred = round(min_days * 0.75); % use the first 75% of days for parameter estimation

diff_days = min_days - end_pred;

n_assets=size(data,2);
%---------------------------------------------------------------------------------------


%% SECTION II - Executing Functions for specific models
h = {'One Period MVO','Market','Black-Litterman'};

figure('name','Plot of Daily Portfolio Returns over Time optimized for MVO')
hold on
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
       [MVO_x, MVO_var, oneperiod_MVO_returns, MVO_prices]=...
           one_period_MVO(data, min_days, end_pred, initial_wealth, desired_return_range,n_assets);
        plot(1:length(oneperiod_MVO_returns),oneperiod_MVO_returns, '-m');
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
        plot(1:length(multiperiod_MVO_returns),multiperiod_MVO_returns,'-o');
        hold all          
    end

    if strcmp(h{1,i},'Black-Litterman')
        %Call function to return the Black-Litterman expected returns
         [BL_tau BL_P BL_Q] = generate_BL_views(n_assets)

          [BL_Er, BL_sigma,BL_pi,BL_omega,rac]=...
           BL_expected_returns(data, market, market_caps,...
									   BL_tau, BL_P, BL_Q, end_pred, PE_ratios);

          %The lines below uses the expected returns computed by black-litterman and implement
          %Mean-variance optimization equation by using BL_Er for expected returns

          [BL_x,BL_var,BL_portfolio_returns,BL_portfolio_prices]=...
          Black_Litterman(data,min_days,end_pred,initial_wealth,...
          desired_return_range,BL_Er,BL_sigma,rac);
          plot(1:length(BL_portfolio_returns),BL_portfolio_returns,'-k');
          title('Comparing Returns of Optimal Portfolios created with MVO & Black-Litterman')
          xlabel('Time (in Days)')
          ylabel('Daily Return of Portfolio')
          hold all
    end

end

grid on;

%T= table(MVO_x, BL_x);
h=legend(h);

%This section creates _ tables of important variables
%and creates a second figure showing the table and comparison of
% Table 1. Black- litterman Parameters 
% -> BL_tau (uncertainty),
% -> BL_P   (identifies assets involved in the views)
% -> BL_Q   (matrice giving numerical returns associated with each view)
% -> BL_Er  (expected returns obtained from reverse optimization)
% -> BL_sigma (covariance of expected returns)
% -> RAC    (risk aversion coefficient)
% -> BL_pi  (implied excess equililbrium return vector)
% -> BL_omega (covariance matrix representing uncertainty in each view)

%Table 2. Mean-Variance optimization Vs. Black-Litterman
% Columns are MVO & BLack-Litterman (Rows are shown below)
% -Portfolio Allocation: MVO_x & BL_X
% - Start Date, End date (AT TOP OF TABLE)
% -Portfolio Value at End of Time Period: MVO_prices(diff_days+1) BL_portfolio_prices(diff_days+1)

toc
%h = legend('Single Factor MVO', 'One period MAD','One period MVO', 'Market Return','ETF return');
%}



