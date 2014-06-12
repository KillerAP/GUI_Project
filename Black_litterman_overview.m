%{ 

IMPLIED MARKET RETURNS:

Risk Aversion Coefficient = RAC
Implied covariance matrix = ICV
Market Cap Weights = x_mkt

--> Using inverse optimization with these three, acquire:

Implied Equilibrium Return Vector = mu_eq

Results in N(mu_eq, t * ICV)

t arbitrary small parameter, but we'll figure something good to do with
this

+++++++++++++++++++++++++++++++++++++++++

USER'S VIEWS

View Matrix = Q_v
Uncertainty of Views = VU

Results in N(Q_v, VU)

=========================================

Combine the above two distributions to get:

N(mu_bl, inv[inv(t*ICV) + P'*inv(VU)*P])

The latter is irrelevant, only require mu_bl. Once mu_bl is acquired, use
it in the Markowitz MVO model to optimize your portfolio weights.

Specifics found in Black_litterman_specifics.m

%}


