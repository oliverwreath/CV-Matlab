function [ times, scale ] = get_Times( times, d, scale, ScaleFactor, lower, upper )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

while d < upper
    if d > lower
            times = times + 1;
            d = d * ScaleFactor;
    else
        scale = scale * ScaleFactor;
        d = d * ScaleFactor;
    end
end


end

