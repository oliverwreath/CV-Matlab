function [ cx, cy, rad, k ] = resulting_Circles_Scale( imgB, scale, r, k, cx, cy, rad )
%RESULTING_CIRCLES  Summary of this function goes here
%   Detailed explanation goes here
    
m = size(imgB, 1);
n = size(imgB, 2);

sumValue = sum(sum(imgB));
minValue = min(min(imgB));
meanValue = sumValue / m / n ;

threshold = meanValue - ( meanValue - minValue ) * 1 / 3 ;

length = 100 ;
if nargin > 5
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
    if k < length
        cx(k:size(cx,1),1) = [];
        cy(k:size(cy,1),1) = [];
        rad(k:size(rad,1),1) = [];
    end
end

end

