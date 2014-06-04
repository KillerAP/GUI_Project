function [MAD_x, MAD_var, portfolio_returns, portfolio_price] = ...
    one_period_MAD(data, min_days, end_pred, initial_wealth, R_range);

[mu, Q, r_it] = param_data(data, end_pred);

[MAD_x, MAD_var] = sMAD(r_it, R_range, mu);

% time horizon over which we are 'predicting'
diff_days = min_days - end_pred; 

% the vector of days in the time horizon
pred_days = 1:diff_days;

% calculate the actual returns of the portfolio and market over the
% prediction region
projection = data(end_pred:min_days, :)';
projected_returns = projection(:, 2:end)./projection(:, 1:end-1) - 1; 
portfolio_returns = MAD_x * projected_returns;



%initial_wealth = W; Given by user

portfolio_price(1) = initial_wealth;

for i = 1:size(portfolio_returns,2);
    portfolio_price(i+1) = portfolio_price(i) * (1 + portfolio_returns(i));
end

end

