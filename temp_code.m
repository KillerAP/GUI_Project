


market_price = market(end_pred:min_days,:);
market_returns = market_price(2:diff_days + 1,:)./market_price(1:diff_days,:) - 1;

%------------------------------------------------------------
%Code for plotting with colors and labelling them appropriately

%Portfolio returns is green
plot(pred_days,portfolio_returns, 'g')
hold all
%Market is blue
plot(pred_days,market_returns, 'b')
%-----------------------------------------------------------------
%array for whic models to run
h = h = {'Single Factor', 'One Period MAD', 'One Period MVO', 'Market', 'ETF' 'MVO with Time'};


count = 1;
for i = 1:size(MAD_x,2)
if MAD_x(1,i) > 0.00001
chosen_assets{count,1} = assets{i};
chosen_assets{count,2} = MAD_x(i);
count = count+1;
end
end


weights = cell2mat(chosen_assets(:,2));

sum(weights)


%-----------------------------------------------------------------------------
%FOR LOOP FOR DECIDING WHICH MODELS TO EXECUTE

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
        plot(1:length(oneperiod_MVO_returns),oneperiod_MVO_returns, '-k');
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
        [BLx,BLvar,BL_returns,BL_returns,BL_prices]=...
          BL(data,min_days,end_pred,initial_wealth,R_range,n_assets,...
             desired_return_range,n_assets,marketcaps,tau,P_viewasset,...
             Q_viewreturns,sigma_viewvar);
          plot(1:length(BL_returns),BL_returns,'-o');
          hold all
    end

end

%-----------------------------------------------------------------
%code used in retrieve_data.m for market caps

%[temp{i},market_caps{i}] = fetch(Connect, assets{i}, 'Close', ...
%							      'MarketCapitalization' start_date, end_date); 

%-----------------------------------------------------------------
%shortend expression by including flipud in the assignment and removing 
% these two lines
market_data = flipud(market_data);
etf_data = flipud(etf_data);

%-----------------------------------------------------------------
%parameters to be used for Black-Litterman
min_days,end_pred,initial_wealth,desired_return_range,n_assets)
R_range,n_assets,marketcaps,tau,
P_viewassets,Q_viewreturns,sigma_viewvar);
