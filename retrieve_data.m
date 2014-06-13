function [asset_data market_data market_caps etf_data min_days] = retrieve_data(assets, market,...
                                        etf, start_date, end_date);
%% ACQUIRE DATA FROM YAHOO FINANCE
% Collect relevant asset data from Yahoo Finance
Connect = yahoo;

min_days = intmax;

count=0;
for i = 1:length(assets)
  	
	data{i}=getStockInformation({assets{i}});
	%disp(data{i});
	market_cap_string{i}=data{i}.MarketCapitalization;
	market_caps{i}=marketcap_string_to_num(market_cap_string{i});
  	
  	temp{i} = fetch(Connect, assets{i}, 'Close',start_date,end_date);

    %[temp{i},market_caps{i}] = fetch(Connect, assets{i}, 'Close', ...
    %							'MarketCapitalization' start_date, end_date); 

    disp(i);
    min_days = min(size(temp{i},1), min_days);    
end
 
%market_caps_temp={getStockINfomr}
%collecting market caps

% S&P/TX market data
market_temp =...
fetch(Connect, market, 'Close', start_date, end_date);
min_days = min(min_days, size(market_temp,1));
market_data(:,1) = market_temp(1:min_days,2);
market_data = flipud(market_data);

etf_temp = ...
fetch(Connect, etf, 'Close', start_date, end_date);
min_days = min(min_days, size(etf_temp,1));
etf_data(:,1) = etf_temp(1:min_days,2);
etf_data = flipud(etf_data);

for i = 1:length(assets)
    asset_data(:,i) = temp{i}(1:min_days,2);
    date_data(:,i) = cellstr(datestr(temp{i}(1:min_days,1))); 
end
    asset_data = flipud(asset_data);
    date_data = flipud(date_data);


%{
for i = 1:size(date_data,2);
date_nums(:,i) = datenum(date_data(:,i));
end

So check the date we want, and decrement/increment to find a date that
works in the desired range, and then use that to find the portfolio prices
for sake of uniformity.

Let me type some arbitrary sentence. It requires the use of various random
things that don't actually contribute to what we're doing right now so we
should probably stop doing whatever we're doing right now and get back to
work. Or we could call it a day and eat.
end
%}
