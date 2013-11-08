function [ imgB ] = Filter_Without_Scale( imgA, h )
%FILTER_WITH_SCALE Summary of this function goes here
%   Detailed explanation goes here


imgB = conv2(imgA, h, 'same');


end

