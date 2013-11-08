function [ x, y, rs, k ] = resulting_Circles( imgB, r )
%RESULTING_CIRCLES  Summary of this function goes here
%   Detailed explanation goes here

m = size(imgB, 1);
n = size(imgB, 2);
k = 1 ;

sumValue = sum(sum(imgB));
minValue = min(min(imgB));
meanValue = sumValue / m / n ;

threshold = meanValue - ( meanValue - minValue ) * 2 / 3 ;

length = 100 ;
x(length, 1) = 0;
y(length, 1) = 0;
rs(length, 1) = 0;

for i = 1 : m 
    for j = 1 : n
        if imgB(i, j) < threshold
           x(k, 1) = i ;
           y(k, 1) = j ;
           rs(k, 1) = r ;
           k = k + 1; 
        end
    end
end

if k ~= 1
    if k < length
        x(k:size(x,1),1) = [];
        y(k:size(y,1),1) = [];
        rs(k:size(rs,1),1) = [];
    end
end

end

