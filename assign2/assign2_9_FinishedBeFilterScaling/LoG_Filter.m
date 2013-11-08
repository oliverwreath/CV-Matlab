function [ h, r ] = LoG_Filter(  )
%LOG_FILTER Summary of this function goes here
%   Detailed explanation goes here

sigma = 2; 

r = sqrt(2) * sigma;

width = ceil(10 * sigma);

if mod(width, 2) == 0;
    width = width + 1;
end

h = fspecial('log', width, sigma);


end

