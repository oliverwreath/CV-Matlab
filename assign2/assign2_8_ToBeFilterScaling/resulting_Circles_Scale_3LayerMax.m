function [ cx, cy, rad, k ] = resulting_Circles_Scale_3LayerMax( imgB, scale, r, k, cx, cy, rad )
%RESULTING_CIRCLES  with Blobing
%   Detailed explanation goes here
    
m = size(imgB, 1);
n = size(imgB, 2);

length = 100 ;
if nargin < 5
    cx(length, 1) = 0;
    cy(length, 1) = 0;
    rad(length, 1) = 0;
end

for i = 1 : m 
    for j = 1 : n
%         if imgB(i, j) < threshold
        if imgB(i, j) ~= 0;
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

