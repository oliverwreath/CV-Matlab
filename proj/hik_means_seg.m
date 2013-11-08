
% Parameters
K = 5;
nleaves  = 100 ;
% data = uint8(rand(2, 1000) * 255) ;
% datat = uint8(rand(2, 1000) * 255) ;

I = imread('12003.jpg');
I = imresize(I, [255 255]);
% I = im2double(I);


[r, c, depth] = size(I);
data(5, r * c ) = 0;

for i = 1: r 
    for j = 1: c
%         data(1, (i-1)* c + j) = i;
%         data(2, (i-1)* c + j) = j;
%         data(3:5, (i-1)* c + j) = I(i, j);
        data( :, (i-1)* c + j) = [i j I(i, j, 1) I(i, j, 2) I(i, j, 3)];
    end
end


% [C,A] = vl_ikmeans(data,K, 'method', 'elkan') ;
% AT = vl_ikmeanspush( datat, C ) ;

[tree, A] = vl_hikmeans(uint8(data), K, nleaves) ;
% AT       = vl_hikmeanspush(tree, datat) ;

cl = get( gca, 'ColorOrder' ) ;
ncl = size(cl,1) ;

hierarchy = 1;

% Output
hold on, 
for k = 1 : K
  sel  = find(A( hierarchy, : ) == k) ;
%   selt = find(AT( hierarchy, : ) == k) ;
  plot( data(2, sel), -data(1, sel),  '.', 'Color', cl( mod( k, ncl ) +1, : ) ) ;
%   plot( datat(1, selt), datat(2, selt), '+', 'Color', cl( mod( k, ncl ) +1, : ) ) ;  
end
title('k-means'),
hold off;

