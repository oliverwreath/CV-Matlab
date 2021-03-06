function [ cx, cy, rad, k ] = resulting_Circles_Scale( imgB, scale, r, k, cx, cy, rad )
%RESULTING_CIRCLES  with Blobing
%   Detailed explanation goes here
    
m = size(imgB, 1);
n = size(imgB, 2);

minValue = min(min(imgB));
meanValue = mean(mean(imgB));

threshold = meanValue - ( meanValue - minValue ) * 1 / 3 ;

length = 100 ;
if nargin < 5
    cx(length, 1) = 0;
    cy(length, 1) = 0;
    rad(length, 1) = 0;
end

for i = 1 : m 
    for j = 1 : n
        if imgB(i, j) < threshold
           cx(k, 1) = i * scale;
           cy(k, 1) = j * scale;
           rad(k, 1) = r;
           k = k + 1; 
        end
    end
end

if k ~= 1
    if k <= length
        cx(k:length,1) = [];
        cy(k:length,1) = [];
        rad(k:length,1) = [];
    end
end

end

