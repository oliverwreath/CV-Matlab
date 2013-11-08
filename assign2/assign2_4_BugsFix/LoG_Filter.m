function [ h ] = LoG_Filter(  )
%LOG_FILTER Summary of this function goes here
%   Detailed explanation goes here


sigma = 0.5; 

h = fspecial('log', 10 * sigma, sigma);


end

