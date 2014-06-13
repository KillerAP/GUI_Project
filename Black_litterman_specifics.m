%{ 

A coded run through of the Black Litterman black box. As of yet does not
implement any user input; arbitrary base values will be chosen for any 
subjective elements, and can then be changed at will. There will be some 
pseudocode, but it will be easily transformable into real code or extra.


IMPLIED MARKET RETURNS:

Risk Aversion Coefficient = RAC
Implied covariance matrix = ICV
Market Cap Weights = x_mkt
Implied Equilibrium Returns = mu_eq

VIEWS: 

View Vector = Q_v
    -> K x 1 view vector, k being the number of views
    -> each of the k views is a percentage, representing either percentage
    difference between assets, or performance of a single asset

Uncertainty of Views (Covariance matrix) = VU
    -> diagonal K x K matrix of uncertainties associated with each view
    -> greater magnitudes correspond directly with greater uncertainties
        -> DETERMINING THIS UNCERTAINTY IS ONE OF THE THINGS WE'LL NEED TO
        DISCUSS PROPERLY AND WILL LIKELY REQUIRE ANOTHER ALGORITHM AND
        FUNCTION IN AND OF ITSELF. Until then, the code below will use
        placeholders of sorts.

Asset linking matrix for the views = P
    -> K x N matrix assigning values to each of the nth elements in the kth
    row representing the relative importances of the assets associated with
    each of the views
    -> This part will also need deliberation as to which method of
    assigning values we'll use. I (Anojan) personally very much like the
    Market Capmethod presented on page 13. It seems natural given that almost
    everything done here is gonna be based on Market Caps.

Scaling factor = t
    -> Arbitrary small scaling factor, but the Idzorek paper covers this
    too. On the other hand, if you've been reading the Meucci paper, then
    maybe you can compare this methodology to the one in that and see if
    there are any major differences. Ideally we want to make everything as
    cohesive to Meucci as possible unless Kwon OKs this approach. This
    applies to the rest of the code and such as well.
%}

% Calculating equilibrium returns given market capitalization weights, risk 
% aversion coefficient, and asset implied covariance matrix.
% These values are the only ones that are not arbitrary which haven't
% specified. 

%calculating risk averision coefficient
%RAC = [E(r)-rf]/(market_var);
mu_eq = RAC * ICV * x_mkt;


% Calculating covariance matrix for views
for i = 1:size(P,1)
    VU(i) = P(i,:)*ICV*P(i,:)';
end

VU = diag(t*VU);


mu_bl = inv(inv(t*ICV) + P'*inv(VU)*P)*(inv(t*ICV)*mu_eq + P'*inv(VU)*ICV);

% Calculating new weights according to the paper I'm using, though this can
% be ignored and we could just do Black Litterman like Kwon said.

x_bl = inv(RAC*ICV) * mu_bl; 

