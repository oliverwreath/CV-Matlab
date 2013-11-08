function [ h, r ] = LoG_Filter_Normalized_Scale( Scale )
%LoG_Filter_Normalized_Scale with Blobing_FilterScale
%   Detailed explanation goes here

sigma = 1; 

if nargin > 0
    sigma = sigma * Scale ;
end

r = sqrt(2) * sigma;

h = fspecial('log', 10 * sigma + 1, sigma);

h = h * sigma * sigma;

end

