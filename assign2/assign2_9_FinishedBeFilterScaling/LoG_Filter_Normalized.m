function [ h, r ] = LoG_Filter_Normalized(  )
%LoG_Filter_Normalized with Blobing
%   Detailed explanation goes here

sigma = 2; 

r = sqrt(2) * sigma;

width = ceil(10 * sigma);

if mod(width, 2) == 0;
    width = width + 1;
end

h = fspecial('log', width, sigma);

h = h * sigma * sigma;

end

