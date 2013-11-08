function [X Y] = calcSquare( x, y, a, angle, steps )
    %# This functions returns points to draw an ellipse
    %#
    %#  @param x     X coordinate
    %#  @param y     Y coordinate
    %#  @param a     Semimajor axis
    %#  @param b     Semiminor axis
    %#  @param angle Angle of the ellipse (in degrees)
    %#

    narginchk(4, 5);
    if nargin < 5, steps = 5; end
    
    theta = linspace( -45 + angle, 315 + angle, steps );
    X = x + cosd(theta) .* a;
    Y = y + sind(theta) .* a;

    if nargout==1, X = [X Y]; end
end