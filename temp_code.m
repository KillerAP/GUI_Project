
%{
market_price = market(end_pred:min_days,:);
market_returns = market_price(2:diff_days + 1,:)./market_price(1:diff_days,:) - 1;

%Portfolio returns is green
plot(pred_days,portfolio_returns, 'g')
hold all
%Market is blue
plot(pred_days,market_returns, 'b')

h = legend('One period MAD', 'Market Return');

%}
