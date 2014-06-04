
%{
market_price = market(end_pred:min_days,:);
market_returns = market_price(2:diff_days + 1,:)./market_price(1:diff_days,:) - 1;

%Portfolio returns is green
plot(pred_days,portfolio_returns, 'g')
hold all
%Market is blue
plot(pred_days,market_returns, 'b')

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
%}
