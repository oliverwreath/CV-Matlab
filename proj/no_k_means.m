
K = 3 ;
data = uint8(rand(2, 1000) * 255) ;
datat = uint8(rand(2, 1000) * 255) ;

[C,A] = vl_ikmeans(data,K, 'method', 'elkan') ;
AT = vl_ikmeanspush( datat, C ) ;

cl = get( gca, 'ColorOrder' ) ;
ncl = size(cl,1) ;

hold on, 
for k = 1 : K
  sel  = find(A  == k) ;
  selt = find(AT == k) ;
  plot( data(1, sel),  data(2, sel),  '.', 'Color', cl( mod( k, ncl ) +1, : ) ) ;
  plot( datat(1, selt), datat(2, selt), '+', 'Color', cl( mod( k, ncl ) +1, : ) ) ;  
end
title('k-means'),
hold off;

