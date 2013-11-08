function [ h, r ] = LoG_Filter(  )
%LOG_FILTER Summary of this function goes here
%   Detailed explanation goes here

sigma = 2; 

r = sqrt(2) * sigma;

h = fspecial('log', 10 * sigma + 1, sigma);


end

