function [SF_x, SF_var, portfolio_returns, portfolio_price] = ...
    one_period_SF(data, market, min_days, end_pred, initial_wealth, R_range);

[mu, Q, r_it] = param_data(data, end_pred);
[mu_M, Q_M, r_M] = param_data(market, end_pred);



