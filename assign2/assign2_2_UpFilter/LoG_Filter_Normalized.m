function [ h, r ] = LoG_Filter_Normalized(  )
%LoG_Filter_Normalized with Blobing
%   Detailed explanation goes here

sigma = 1; 

r = sqrt(2) * sigma;

h = fspecial('log', 10 * sigma + 1, sigma);

h = h * sigma * sigma;

end

