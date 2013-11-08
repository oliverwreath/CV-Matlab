function [ h, r ] = LoG_Filter_Normalized_Scale( Scale )
%LoG_Filter_Normalized_Scale with Blobing_FilterScale
%   Detailed explanation goes here

sigma = 2; 

if nargin > 0
    sigma = sigma * Scale ;
end

r = sqrt(2) * sigma;

width = ceil(10 * sigma);

if mod(width, 2) == 0;
    width = width + 1;
end

h = fspecial('log', width, sigma);

h = h * sigma * sigma;

end

