function [ cx, cy, rad, k, imgB ] = Blobing_FilterScale( imgA, sqrt_Size, h, r, scale, ScaleFactor, k, cx, cy, rad  )
%Blobing_FilterScale Summary of this function goes here
%   Detailed explanation goes here

%% Filtering
    imgB = Filter_Without_Scale( imgA, h);

%%
sqrt_Size
d = r * 2
    
if d > sqrt_Size / 200 ;
    %%
    if nargin < 8
        [ cx, cy, rad, k ] = resulting_Circles( imgB, r, k );
    else
        [ cx, cy, rad, k ] = resulting_Circles( imgB, r, k, cx, cy, rad );
    end
    
    %%
    if d < sqrt_Size / 5
        scale = scale * ScaleFactor;
        [ h, r ] = LoG_Filter_Normalized_Scale( scale) ;
%         r = r * ScaleFactor;
        [ cx, cy, rad, k ] = Blobing_FilterScale( imgA, sqrt_Size, h, r, scale, ScaleFactor, k, cx, cy, rad );
    end
else
    %%
    if d < sqrt_Size / 5
        scale = scale * ScaleFactor;
        [ h, r ] = LoG_Filter_Normalized_Scale( scale ) ;
%         r = r * ScaleFactor;
        [ cx, cy, rad, k ] = Blobing_FilterScale( imgA, sqrt_Size, h, r, scale, ScaleFactor, k );
    end
    
end

end

