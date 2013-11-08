function [ cx, cy, rad, k, imgB ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor, k, cx, cy, rad  )
%BLOBING Summary of this function goes here
%   Detailed explanation goes here

%% Filtering
    imgB = Filter_Without_Scale( imgA, h);

%%
sqrt_Size
d = r * 2

if d > sqrt_Size / 200 ;
    %%
    if nargin < 8
        [ cx, cy, rad, k ] = resulting_Circles_Scale( imgB, scale, r, k );
    else
        [ cx, cy, rad, k ] = resulting_Circles_Scale( imgB, scale, r, k, cx, cy, rad );
    end
    
    %%
    if d < sqrt_Size / 5 
        scale = scale * ScaleFactor;
        imgA = imresize(imgA, 1/ ScaleFactor );
        r = r * ScaleFactor;
        [ cx, cy, rad, k ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor, k, cx, cy, rad );
    end
else
    %%
    if d < sqrt_Size / 5
        scale = scale * ScaleFactor;
        imgA = imresize(imgA, 1/ ScaleFactor );
        r = r * ScaleFactor;
        [ cx, cy, rad, k ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor, k );
    end
    
end

end

