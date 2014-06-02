function [MVO_x, MVO_var, portfolio_returns, portfolio_price] = ...
    one_period_MVO(data, min_days, end_pred, initial_wealth, R_range);

[mu, Q, r_it] = param_data(data, end_pred);

[MVO_x, MVO_var] = sMVO(10, R_range , mu, Q);

% time horizon over which we are 'predicting'
diff_days = min_days - end_pred; 

% the vector of days in the time horizon
pred_days = 1:diff_days;

% calculate the actual returns of the portfolio and market over the
% prediction region
projection = data(end_pred:min_days, :)';
projected_returns = projection(:, 2:end)./projection(:, 1:end-1) - 1; 
portfolio_returns = MVO_x * projected_returns;

portfolio_price(1) = initial_wealth;

%initial_wealth = W; Given by user

for i = 1:length(portfolio_returns);
    portfolio_price(i+1) = portfolio_price(i) * (1 + portfolio_returns(i));
end
end
