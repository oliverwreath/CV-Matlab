function [ ] = part2( )
%PART3 Summary of this function goes here
%   Detailed explanation goes here

D = load('measurement_matrix.txt');

% Step 1 Normalizing.
mean_of_D = mean(D, 2);
for i = 1: 202
    D(i, :) = ( D(i, :) - mean_of_D(i, :) );
end

% Step 2 Getting M S.
[ U, S, V ] = svd(D);

U = U(:,1:3);
W = S(1:3, 1:3);
V = V(:,1:3)';

M = U * sqrtm(W);
S = (sqrtm(W) * V);
size_of_Matrix_M = size(M)
size_of_Matrix_S = size(S)

% Step 3 Plotting.
% unNormalize
Dp = M * S;
for i = 1: 202
    D(i, :) = ( D(i, :) + mean_of_D(i) );
    Dp(i, :) = ( Dp(i, :) + mean_of_D(i) );
end
% unN end
figure, axis([ -6 2 -3 3 -10 -2]), 
hold on, 
plot3( S(1,:)', S(2,:)', S(3,:)', 'ob' ),
% plot3( center1(1), center1(2), center1(3), 'or','MarkerFaceColor', 'r', 'MarkerSize',10 ),
% plot3( center2(1), center2(2), center2(3), 'og','MarkerFaceColor', 'g', 'MarkerSize',10 ),
axis equal, grid on, 
xlabel('x'),
ylabel('y'),
zlabel('z'), hold off;

% Step 4 Display three frames with both the observed feature points and the estimated projected 3D points overlayed. 
I = imread('frame00000001.jpg');
I2 = imread('frame00000072.jpg');
I3 = imread('frame00000101.jpg');
number_of_frame = 1;
figure, imshow(I), hold on,
plot( D( 2*number_of_frame - 1, : )', D( 2*number_of_frame, : )', 'ob' ),
plot( Dp( 2*number_of_frame - 1, : )', Dp( 2*number_of_frame, : )', 'or' ),
axis equal, grid on, 
hold off,
number_of_frame = 72;
figure, imshow(I2), hold on,
plot( D( 2*number_of_frame - 1, : )', D( 2*number_of_frame, : )', 'ob' ),
plot( Dp( 2*number_of_frame - 1, : )', Dp( 2*number_of_frame, : )', 'or' ),
axis equal, grid on, 
hold off,
number_of_frame = 101;
figure, imshow(I3), hold on,
plot( D( 2*number_of_frame - 1, : )', D( 2*number_of_frame, : )', 'ob' ),
plot( Dp( 2*number_of_frame - 1, : )', Dp( 2*number_of_frame, : )', 'or' ),
axis equal, grid on, 
hold off,


per_frame_residual = zeros(101, 1);
for i = 1 : 101
    per_frame_residual(i,:) = per_frame_residual(i,:) + sum( ( D(2*i - 1,:) - Dp(2*i - 1,:) ) .^ 2 );
    per_frame_residual(i,:) = per_frame_residual(i,:) + sum( ( D(2*i,:) - Dp(2*i,:) ) .^ 2 );
end
per_frame_residual

total_frame_residual = sum(per_frame_residual)

figure, hold on,
plot( per_frame_residual, 'ob' ),
axis equal, grid on, 
hold off,



end

