function [ X Y ] = calculateCircle( x, y, r )
%CALCULATECIRCLE Summary of this function goes here
%   Detailed explanation goes here

steps = 30;

theta = linspace(0,2* pi+ 0.1, steps);
X = x + cos(theta) .* r;
Y = y + sin(theta) .* r;

end

