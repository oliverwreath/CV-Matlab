function [ ret ] = Ismin( imgA )
%ISMAX Summary of this function goes here
%   Detailed explanation goes here

% m = size(imgA, 1);
% n = size(imgA, 2);
% 
% 
% coordinate = ceil(([m n] + 1 )/ 2)

m = size(imgA, 1);
n = size(imgA, 2);
x = ceil((m + 1 )/ 2);
y = ceil((n + 1 )/ 2);

for i = 1 : n
    minValue = min(imgA(:));

    if minValue < 0 && imgA(x, y) == minValue
        ret = minValue;
    else
        ret = 0;
    end
end



end

