function [ y ] = ndSuppressionMinimum( x )
%NDSUPPRESSION non-distinctive suppression for minimum
%   row

tempx = x(x~=0);
first = min( tempx );
second = min( tempx(tempx~=first) );
% first not exist
if size(first, 1) == 0
    y = x;
elseif size(second, 1) == 0 % first exist, but second not exist
    y = x;
elseif first == 0 || second == 0 
    y = x;
elseif first / second < 0.8 % first
    y = x .* (x == first);
else % none 
    y = x .* 0;
end

end

