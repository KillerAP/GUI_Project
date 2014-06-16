function [MVO_x, MVO_var, portfolio_returns, portfolio_price] = ...
    multiperiod_MVO(data, min_days, end_pred, initial_wealth, R_range,n_assets);


%THe first line takes in the historical data and return the expected return into mu and the covariance matrix into Q
%The second line does the same but for the market index

[mu, Q] = param_data(data, end_pred);

% time horizon over which we are 'predicting'
diff_days = min_days - end_pred; 

% the vector of days in the time horizon
pred_days = 1:diff_days;

% calculate the actual returns of the portfolio and market over the
% prediction region

for i = 1:diff_days;
    new_end_pred = end_pred + i - 1;
    [mu, Q] = param_data(data, new_end_pred);
    [MVO_x(i,:), MVO_var(i)] = sMVO(n_assets, R_range, mu, Q);
    
end

projection = data(end_pred:min_days, :)';
projected_returns = projection(:, 2:end)./projection(:, 1:end-1) - 1;
portfolio_price(1) = initial_wealth;

for i = 1:size(projected_returns,2);
    portfolio_returns(i) = MVO_x(i,:) * projected_returns(:,i); 
    portfolio_price(i+1) = portfolio_price(i) * (1 + portfolio_returns(i));
end
end
