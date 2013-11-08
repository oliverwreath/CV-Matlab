function [ imgB_Plane ] = Stack2Plane( imgB_Stack )
%STACK2PLANE Summary of this function goes here
%   Detailed explanation goes here

[ m n t ] = size(imgB_Stack);
imgB_Plane(m * t, n) = 0;

for x = 1 : m 
    for y = 1 : n
        for z = 1 : t
            imgB_Plane( x * t - (t - z), y ) = imgB_Stack(x, y, z);
        end
    end
end

clear imgB_Stack

end

