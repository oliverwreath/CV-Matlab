function [ y ] = ndSuppressionMaximum( x )
%NDSUPPRESSION non-distinctive suppression for minimum
%   row

first = max( x );
if first == 0
    second = 0;
else
    second = min( x(x~=first) );
end
% first not exist
if second / (first + eps) < 0.8 % first
    y = x .* (x == first);
else % none 
    y = x .* 0;
end

end

