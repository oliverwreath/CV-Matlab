function [ ] = tri(  )
%TRIANGULATION Summary of this function goes here
%   Detailed explanation goes here

I1 = imread('house1.jpg');
I2 = imread('house2.jpg');
P1 = load('house1_camera.txt');
P2 = load('house2_camera.txt');
matches = load('house_matches.txt');

% I1 = imread('library1.jpg');
% I2 = imread('library2.jpg');
% P1 = load('library1_camera.txt');
% P2 = load('library2_camera.txt');
% matches = load('library_matches.txt');


% Step 1 get Camera Center
[ ~,~,V ] = svd(P1);
center1 = V(:,end);
center1 = center1(1:3) ./ center1(4)

[ ~,~,V ] = svd(P2);
center2 = V(:,end);
center2 = center2(1:3) ./ center2(4)

% Step 2 Use linear least squares to triangulate the position of each matching pair of points given the two cameras
numOfFeatures = size(matches, 1)
points = zeros( numOfFeatures, 3 );
for i = 1 : numOfFeatures
    X1x = [ 0,              -1,     matches(i, 2); ...
            1               0,      -matches(i, 1); ...
            -matches(i, 2), matches(i, 1),  0  ];
    X2x = [ 0,              -1,     matches(i, 4); ...
            1,              0,      -matches(i, 3); ...
            -matches(i, 4), matches(i, 3),  0  ];
    [ ~, ~,V ] = svd( [X1x * P1; ...
                        X2x * P2]);
    X = V( :, end );
    X = X(1:3) ./ X(4);
    points(i, :) = X;
%     residuals(i) = dist2(camera1_point(i), projection1_point(i)) + dist2(camera2_point(i), projection2_point(i));
end
% avg_residuals = avg(residuals)
% figure, axis([ -6 2 -3 3 -10 -2]), hold on, 
% plot3( points(:,1), points(:,2), points(:,3), 'ob' ),
% plot3( center1(1), center1(2), center1(3), 'or','MarkerFaceColor', 'r', 'MarkerSize',10 ),
% plot3( center2(1), center2(2), center2(3), 'og','MarkerFaceColor', 'g', 'MarkerSize',10 ),
% axis equal, grid on, 
% xlabel('x'),
% ylabel('y'),
% zlabel('z'), hold off;
%, view(35,40)
    

% 
D1 = zeros(numOfFeatures, 3);
for i = 1 : numOfFeatures
    D1(i, :) = P1 * [points(i, :), 1]';
    D2(i, :) = P2 * [points(i, :), 1]';
end
for i = 1 : numOfFeatures
    D3(i, :) = D1(i, 1:2) ./ D1(i, 3);
    D4(i, :) = D2(i, 1:2) ./ D2(i, 3);
end

figure, imshow(I1), hold on,
plot( matches(:, 1), matches(:, 2), 'ob' ),
plot( D3(:, 1), D3(:, 2), 'or' ),
axis equal, grid on, 
hold off,

figure, imshow(I2), hold on,
plot( matches(:, 3), matches(:, 4), 'ob' ),
plot( D4(:, 1), D4(:, 2), 'or' ),
axis equal, grid on, 
hold off,

per_frame_residual = zeros(2, 1);

    per_frame_residual(1,:) = sum( ( matches(:, 1) - D3(:, 1) ) .^ 2 );
    per_frame_residual(1,:) = per_frame_residual(1,:) + sum( ( matches(:, 2) - D3(:, 2) ) .^ 2 );
    per_frame_residual(2,:) = sum( ( matches(:, 3) - D4(:, 1) ) .^ 2 );
    per_frame_residual(2,:) = per_frame_residual(2,:) + sum( ( matches(:, 4) - D4(:, 2) ) .^ 2 );

per_frame_residual


end

