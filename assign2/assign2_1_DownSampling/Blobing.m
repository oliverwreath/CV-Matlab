function [ cx, cy, rad, k, imgB ] = Blobing( imgA, h, r, scale, ScaleFactor, k, cx, cy, rad  )
%BLOBING Summary of this function goes here
%   Detailed explanation goes here

%%
    imgB = Filter_Without_Scale( imgA, h);

%%
if r > sqrt(size(imgA, 1) * size(imgA, 2)) / 100 ;
    %%
    if nargin < 7
        [ cx, cy, rad, k ] = resulting_Circles_Scale( imgB, scale, r, k );
    else
        [ cx, cy, rad, k ] = resulting_Circles_Scale( imgB, scale, r, k, cx, cy, rad );
    end
    
    %%
    if sqrt(size(imgA, 1) * size(imgA, 2)) > 25
        imgA = imresize(imgA, 1/ScaleFactor );
        r = r * ScaleFactor;
        scale = scale * ScaleFactor;
        [ cx, cy, rad, k ] = Blobing( imgA, h, r, scale, ScaleFactor, k, cx, cy, rad );
    end
else
    %%
    if sqrt(size(imgA, 1) * size(imgA, 2)) > 25
        imgA = imresize(imgA, 1/ScaleFactor );
        r = r * ScaleFactor;
        scale = scale * ScaleFactor;
        [ cx, cy, rad, k ] = Blobing( imgA, h, r, scale, ScaleFactor, k );
    end
    
end

end

