function [ imgB ] = Filter_With_Scale( imgA, h, scale, ScaleFactor )
%FILTER_WITH_SCALE Summary of this function goes here
%   Detailed explanation goes here

imgB = imfilter(imgA, h);


end

