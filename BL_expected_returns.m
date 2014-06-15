function [BL_Er, BL_sigma] = BL_expected_returns(data, market, market_caps,...
									   BL_tau, BL_P, BL_Q, BL_omega,end_pred)

	%obtain the covariance of expected retursn of the data (BL_sigma)
	r_it = (data(2:end_pred,:)./data(1:end_pred-1,:)) - 1;
	BL_sigma=cov(r_it);

	%Calculating Risk aversion coefficient
	risk_aversion_coefficient=...
	comp_risk_aversion_coefficient(mean(market),0,cov(market));	

	%calculating portion investmen in each asset, weighted by market capitalization
	[cap_weights,available_market_caps]=capweights(market_caps);

	%Calculate the implied excess equilibrium return vector (BL_Pi)
	BL_pi=risk_aversion_coefficient.*BL_sigma*cap_weights';

	%Use the below equation to computer E[R], which
	%represents the new combined return vector
	BL_Er=(inv(BL_tau*BL_sigma)+BL_P'*inv(BL_omega)*BL_P) * ...
	      (inv(BL_tau.*BL_sigma)*BL_pi+BL_P'*BL_omega*BL_Q);


end

