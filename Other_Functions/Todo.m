%{
%Put a (CHECK) next to the task when completed	

(CHECK) -when fetching data, don't fetch data for assets that don't have market caps 
(CHECK) -Create an array that holds the names of the assets that contain           
-Set assets equal to 10 assets who have market caps available


(CHECK)-Do inverse optimization
(CHECk)-follow through with expected reutrn equation
(CHECK)-generate arbitrary view matrices (P , Q & omega(uncertainty))
(CHECK)parametrize Black-Litterman and use a function

(CHECK)(initially do MVO with the solved for E[R])
-Solve for Black-Litterman weights using rigourous mathematical method
 instead of linear optimization
-Apply one investment technique to autonomously generate matrices P,Q and omega

-store all yahoo finance data in sql database for preprocessing
-Make Modules/libraries for functions and reorganize them
-Create new Rails repository and try the following two things
1. Store MATLAB asset data in CSV file and save in Heroku
2. CAll Matlab functions in Ruby

-Create Ruby script that imports yahoo finance data(should be faster)

-Output table figure that outputs key figures associated with each figure
namely: 
  ->BL_P(Identifying which assets are associated with which views)
  ->BL_Q(identifying the excess returns above market-cap weighted for each view)
  ->MVO_X(the weights attained when optimizing using standard Markowitz MVO
  ->BL_X(the portoflio weights attained when optimizing using Black-Litterman)
-Create a script that will automatically save the .png figures into 
the image folder and label the file appropriately.

}