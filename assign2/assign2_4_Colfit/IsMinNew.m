function [ ret ] = IsMinNew( imgA )
%ISMAX Summary of this function goes here
%   Detailed explanation goes here

% m = size(imgA, 1);
% n = size(imgA, 2);
% 
% 
% coordinate = ceil(([m n] + 1 )/ 2)

[m n] = size(imgA);
x = ceil(m / 2);
ret = zeros(1, n);

for i = 1 : n
    minValue = min(imgA(:,i));

    if minValue < 0 && imgA(x, i) == minValue
        ret(1, i) = minValue;
    else
        ret(1, i) = 0;
    end
end

end

