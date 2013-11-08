function [ imgB_Stack ] = Plane2Stack( imgB_Plane, t )
%PLANE2STACK Summary of this function goes here
%   Detailed explanation goes here

[ m n ] = size(imgB_Plane);
m = m / t;
imgB_Stack( m, n, t ) = 0;

for x = 1 : m 
    for y = 1 : n
        for z = 1 : t
            imgB_Stack(x, y, z) = imgB_Plane( x * t - (t - z), y );
        end
    end
end

clear imgB_Plane

end

