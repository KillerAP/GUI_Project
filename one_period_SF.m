function [SF_x, SF_var, portfolio_returns, portfolio_price] = ...
    one_period_SF(data, market, min_days, end_pred, initial_wealth, R_range);

[mu, Q, r_it] = param_data(data, end_pred);
[mu_M, Q_M, r_M] = param_data(market, end_pred);

[SF_x SF_var] = sSF(r_it, r_M, R_range, mu, mu_M);

diff_days = min_days - end_pred; 

% the vector of days in the time horizon
pred_days = 1:diff_days;

% calculate the actual returns of the portfolio and market over the
% prediction region
projection = data(end_pred:min_days, :)';
projected_returns = projection(:, 2:end)./projection(:, 1:end-1) - 1; 
portfolio_returns = SF_x * projected_returns;

portfolio_price(1) = initial_wealth;

%initial_wealth = W; Given by user

for i = 1:1:size(portfolio_returns,2);
    portfolio_price(i+1) = portfolio_price(i) * (1 + portfolio_returns(i));
end
end
