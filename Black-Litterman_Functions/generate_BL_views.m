function [ BL_tau BL_P BL_Q ] = generate_BL_views(n_assets)
%BLACK-LITTERMAN SPECIFIC CODE

%Set the value of BL_tau(1x1), which represents the uncertainy of the CAPM distribution
%to equal and arbitrary value(normally chosen between 0.025 and 0.05)
BL_tau=0.0375;

%{
%example: stating that asset 1 will outperform all others by 5%,
%asset 4 will outpeform asset 5 by 2%
%and asset 3 will outpeform asset 7 by 10%
BL_P = [1 0 0 0 0 0 0 0;
        0 0 0 1 -1 0 0 0;
        0 0 1 0 0 0 -1 0;
        0 1 0 0 0 0 0 0];
%}

%Dynamically generating BL_P so that the dimensions match up with number of assets retrieved
%(next add random generation of 1 & -1)
BL_P=[1 0 0; 1 -1 0; 1 0 -1]
while (size(BL_P,2)<n_assets)
  BL_P=[BL_P zeros(3,1)];
end

 
%Set the value of BL_Q(kx1), which represents expected returns of portfolios %corresponding $to the matrix views stored in BL_P, to an arbitrary value
BL_Q = [0.05; 0.02; 0.01;];

end

