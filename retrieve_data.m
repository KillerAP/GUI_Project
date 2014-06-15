function [asset_data assets_with_marketcaps market_data market_caps etf_data min_days] = retrieve_data(assets, market, etf, start_date, end_date);
%% ACQUIRE DATA FROM YAHOO FINANCE
% Collect relevant asset data from Yahoo Finance
Connect = yahoo;

min_days = intmax;


%This for loop does two things
%1. It retrieves Market Capitalization information for all stocks in the TSX
%   and converts it to a number.
%2. It keeps track of min_days of data available for any asset 
for i = 1:8
  	data{i}=getStockInformation({assets{i}});
	disp(data{i});

	market_cap_string{i}=data{i}.MarketCapitalization;
	market_caps{i}=marketcap_string_to_num(market_cap_string{i});
  	temp{i} = fetch(Connect, assets{i}, 'Close',start_date,end_date);

    

    disp(i);
    min_days = min(size(temp{i},1), min_days);    
end
 

% S&P/TX market data
market_temp=fetch(Connect, market, 'Close', start_date, end_date);
etf_temp = fetch(Connect, etf, 'Close', start_date, end_date);

min_days = min(min_days, size(market_temp,1));
min_days = min(min_days, size(etf_temp,1));

market_data(:,1) = flipud(market_temp(1:min_days,2));
etf_data(:,1) = flipud(etf_temp(1:min_days,2));


%count represents current position in the asset_data array
%that we should assign to (as we may skip elements)

count=1;

%assets_with_marketcaps keeps track of the assets who have market caps
assets_with_marketcaps=[];

for i = 1:8
	if  (market_caps{i}~='NaN')
	    asset_data(:,count) = temp{i}(1:min_days,2);
	    date_data(:,count) = cellstr(datestr(temp{i}(1:min_days,1))); 
	    count=count+1;
	    assets_with_marketcaps=[assets_with_marketcaps; i];
	end
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
