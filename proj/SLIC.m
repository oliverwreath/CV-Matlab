function [  ] = SLIC(  )
%SLIC Summary of this function goes here
%   Detailed explanation goes here


I2 = imread('12003.jpg');
% I2 = impyramid(I2, 'reduce');
% I2 = impyramid(I2, 'reduce');
% I = im2double(I2);
% figure, imshow(I);

colorTransform = makecform( 'srgb2lab' );
I = applycform( I2, colorTransform );

% I = vl_xyz2lab(vl_rgb2xyz(I)); 

% im contains the input RGB image as a SINGLE array
regionSize = 20 ;
regularizer = 0.1 ;
segments = vl_slic( im2single(I), regionSize, regularizer ) ;

% cl = get( gca, 'ColorOrder' ) ;
% ncl = size(cl,1) ;
% 
% 
% % Output
% figure, hold on, 
% K = max(segments(:))
% for k = 1 : K
%   [row, col] = find( segments == k ) ;
% 
% %   selt = find(AT( hierarchy, : ) == k) ;
%   plot( col, -row, '.', 'Color', cl( mod( k, ncl ) +1, : ) ) ;
% %   plot( datat(1, selt), datat(2, selt), '+', 'Color', cl( mod( k, ncl ) +1, : ) ) ;  
% end
% title('k-means'),
% hold off;

[row col] = size(segments);
for i = 1: row - 1
    for j = 1: col - 1
        if ( segments(i, j) ~= segments(i+1, j+1) ) || ( segments(i, j) ~= segments(i+1, j) ) || ( segments(i, j) ~= segments(i, j+1) ) 
            I2(i, j , :) = [255 255 255];
        end
    end
end



figure, hold on, 
imshow(I2),
title('SLIC'),
hold off;


end

