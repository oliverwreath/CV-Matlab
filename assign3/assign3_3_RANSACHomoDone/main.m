function [  ] = main(  )
%MIAN Summary of this function goes here
%   Detailed explanation goes here

begin = tic();
%% Step 1 Load both images, convert to double and to grayscale.
s = 1;
halfPatchWidth = 4;
display = 0;
display2 = 1;
nd = 1;
thresNum = 20;
affine = 1;
numberOfSupsampling = 2;

numberOfImages = 2;%
% fileName = char('100-0023_img.jpg', '100-0024_img.jpg' );
fileName = char( 'uttower_left.jpg', 'uttower_right.jpg' );

for i = 1 : numberOfImages
    if i == 1 
        imgDouble = cell(numberOfImages);
    end
    imgInput = imread( fileName(i, :) );
    if ndims(imgInput) == 3
        imgDouble{i} = im2double(rgb2gray(imgInput));
    else
        imgDouble{i} = im2double(imgInput);
    end
end
descriptor = cell(numberOfImages,1);
newDescriptor = cell(numberOfImages,1);
featurePoint = cell(numberOfImages,1); %zeros( numberOfImages, 2 );
originalXY = cell(numberOfImages,1);
toc(begin);

%% Step 2 Detect feature points in both images. 
tic23 = tic();
for i = 1 : numberOfImages
    scale = cell(numberOfSupsampling,1);
    scale{1} = 1;
    cim = cell(numberOfSupsampling,1);
    r = cell(numberOfSupsampling,1);
    c = cell(numberOfSupsampling,1);
    descriptor{i} = cell(numberOfSupsampling,1);
    for j = 1 : numberOfSupsampling
        if j == 1 
        	scale{j} = 1;
        else 
            scale{j} = scale{j-1} * 2;
        end
        tempSupImage = imresize(imgDouble{i}, 1/ scale{j});
        [ cim{j} ] = harrisPlusSuppression( tempSupImage, 1, size(imgDouble{i}), 0.06, 3, 0 );
    end
%     for j = 1 : numberOfSupsampling
%         cim{j}
%     end
    for j = 1 : numberOfSupsampling - 2
        A1 = cim{j+1} > cim{j+2};
        A2 = cim{j} < cim{j+1};
        cim{j+1} = cim{j+1} .* A1 .* A2;
    end
    j = 1;
    A1 = cim{j} > cim{j+1};
    cim{j} = cim{j} .* A1;
    j = numberOfSupsampling;
    A1 = cim{j} > cim{j-1};
    cim{j} = cim{j} .* A1;
    %
    for j = 1 : numberOfSupsampling
%         cim{j} = imresize(cim{j}, 0.5);
        cim{j}(:, 1: s * scale{j} * halfPatchWidth - 1 ) = 0;
        cim{j}(:, size(imgDouble{i}, 2) - s * scale{j} * halfPatchWidth : end) = 0;
        cim{j}(1: s * scale{j} * halfPatchWidth - 1, :) = 0;
        cim{j}(size(imgDouble{i}, 1) - s * scale{j} * halfPatchWidth : end, :) = 0;
        [ r{j}, c{j} ] = find( cim{j} );
%         display
        if display == 1
            figure, imagesc(imgDouble{i}), axis image, colormap(gray), hold on
    %         plot(c{j}, r{j}, 'ys'), title('corners detected');
            for k = 1 : size(r{j}, 1)
                [ X Y ] = calcSquare( c{j}(k), r{j}(k), s * scale{j} / sqrt(2), 0 );
                line( X, Y, 'Color', 'y', 'LineWidth', 1 );
            end
        end
        %% Step 3 Extract fixed-size patches around every keypoint in both images, 
        % and form descriptors simply by "flattening" the pixel values in each patch to one-dimensional vectors. 
        % Experiment with different patch sizes to see which one works the best.
        numOfFeatures = size(r{j}, 1);
        for k = 1 : numOfFeatures
            descriptor{i}{j}( numOfFeatures, 4 * halfPatchWidth * halfPatchWidth ) = 0;
%             [ X Y ] = calcSquare( c{j}(k), r{j}(k), s * scale{j} / sqrt(2), 0 );
            halfWidth = halfPatchWidth * s * scale{j};
            sampleImage = imgDouble{i}( r{j}(k) - halfWidth + 1 : r{j}(k) + halfWidth, c{j}(k) - halfWidth + 1 : c{j}(k) + halfWidth );
            sampleImage = imresize( sampleImage, 1 / scale{j} );
            % flattening 
            descriptor{i}{j}( k, : ) = reshape(sampleImage, [], 1);
        end
%         newDescriptor = descriptor{i}{j};
    end

    newDescriptor{i} = descriptor{i}{1};
%     newr{i} = r{1};
%     newc{i} = c{1};
    
%     featurePoint(i, 1) = r{1};
%     featurePoint(i, 2) = c{1};
    featurePoint{i} = [r{1}, c{1}];
    for j = 2 : numberOfSupsampling
        newDescriptor{i} = [ newDescriptor{i}; descriptor{i}{j} ];
        featurePoint{i} = [ featurePoint{i}; [r{j}, c{j}] ];
%         featurePoint(i, 2) = [ featurePoint(i, 2);  ];
    end
    
    % matrixization
%     newr{1}(l(j1)) newc{1}(l(j1))
end
toc(tic23);
clear r;
clear c;


%% Step 4
tic4 = tic;
% Compute distances between every descriptor in one image and every descriptor in the other image. 
% You can use this code for fast computation of Euclidean distance.
% n2 = dist2( newDescriptor{1}, newDescriptor{2});
n2 = pdist2( newDescriptor{1}, newDescriptor{2}, 'correlation' );
toc(tic4);

%% Step 5
tic5 = tic;
if nd == 1
    B = zeros( size(n2) );
    % non-distinctive suppression
    for i = 1 : size(n2, 1)
        B( i, : ) = ndSuppression( n2( i, : ) );
    end
    for i = 1 : size(n2, 2)
        B( :, i ) = ndSuppression( B( :, i ) );
    end
    n2 = B;
else
    B = n2;
end
% thresholding suppression
%  select the top few hundred descriptor pairs with the smallest pairwise distances.
B = B( B ~= 0 );
B = sort( B(:), 'ascend' );
threshold = B( min( thresNum, size(B, 1)) );
% [r,c,v] = find(X>2)
% [ l r ] = find( n2 < threshold );
n2 = (n2 > 0) .* (n2 < threshold);
[ l r ] = find( n2 );
numOfFeatures = size( l, 1 );

% feature reduction
for i = 1 : numberOfImages
    tempMatrix = zeros( size(featurePoint{i}, 1), 1 );
    tempLeft = featurePoint{i}( :, 1 );
    tempRight = featurePoint{i}( :, 2 );
    for j = 1 : numOfFeatures 
        if i == 1
            tempMatrix( l(j), 1 ) = 1;
        else
            tempMatrix( r(j), 1 ) = 1;
        end
%         featurePoint{1}(l(j));
    end
    tempLeft = tempMatrix .* tempLeft;
    tempRight = tempMatrix .* tempRight;
%     featurePoint{i}( :, 1 ) = tempLeft(tempLeft ~= 0) ;
%     featurePoint{i}( :, 2 ) = tempRight(tempRight ~= 0) ;
    featurePoint{i} = [tempLeft(tempLeft ~= 0), tempRight(tempRight ~= 0)] ;
end
numOfFeatures = size( featurePoint{1}, 1 );
clear tempMatrix;
clear l;
clear r;

if display2 == 1
    for i = 1 : numberOfImages
        figure, imagesc(imgDouble{i}), axis image, colormap(gray), hold on
        for j = 1 : numOfFeatures 
%             if i == 1
% %                 plot(c,r,'ys'), title('corners detected');
%                 [ X Y ] = calcSquare( newc{i}(l(j)), newr{i}(l(j)), s / sqrt(2), 0 );
%             else
%                 [ X Y ] = calcSquare( newc{i}(r(j)), newr{i}(r(j)), s / sqrt(2), 0 );
%             end
%             line( X, Y, 'Color', 'y', 'LineWidth', 1 );
            if i == 1
                plot( featurePoint{i}(j, 2), featurePoint{i}(j, 1), 'ys'), title('corners detected');
            else
                plot( featurePoint{i}(j, 2), featurePoint{i}(j, 1), 'ys'), title('corners detected');
            end
        end
        hold off
    end
end
toc(tic5);

%% Step 6
tic6 = tic;
% RANSAC (1) an affine transformation and (2) a homography
% RANSAC affine
if affine == 1 % affine
    for i = 1 : 1 % numberOfImages
        H = zeros(6, 1);
%         A = zeros(6, 6);
%         B = zeros(6, 6);
        inlier_number = 0;
        residual_avg = realmax('double');
        threshold = 3;
        for j1 = 1 : numOfFeatures
            for j2 = j1 + 1 : numOfFeatures
                for j3 = j2 + 1 : numOfFeatures 
                % get H 
                    A = [ ...
                    	featurePoint{i}(j1, 1) featurePoint{i}(j1, 2) 0 0 1 0; ...
                    	0 0 featurePoint{i}(j1, 1) featurePoint{i}(j1, 2) 0 1; ...
                    	featurePoint{i}(j2, 1) featurePoint{i}(j2, 2) 0 0 1 0; ...
                    	0 0 featurePoint{i}(j2, 1) featurePoint{i}(j2, 2) 0 1; ...
                    	featurePoint{i}(j3, 1) featurePoint{i}(j3, 2) 0 0 1 0; ...
                    	0 0 featurePoint{i}(j3, 1) featurePoint{i}(j3, 2) 0 1 ...
                    	];
                    B = [ featurePoint{2}(j1, 1); featurePoint{2}(j1, 2); featurePoint{2}(j2, 1); featurePoint{2}(j2, 2); featurePoint{2}(j3, 1); featurePoint{2}(j3, 2) ];
                    tempH = A\B;
                    % get inlier number and residual sum
                    hypoXY = zeros( numOfFeatures, 2 );
                    for jj = 1 : numOfFeatures 
                    	hypoA = [ ...
                    	featurePoint{1}(jj, 1) featurePoint{1}(jj, 2) 0 0 1 0; ...
                     	0 0 featurePoint{i}(jj, 1) featurePoint{i}(jj, 2) 0 1 ...
                     	];
                    	hypoXY( jj, : ) = hypoA * tempH; 
                    end
                    % distance Matrix
                    n2 = dist2( featurePoint{2}, hypoXY );
%                     n2 = pdist2( featurePoint{2}, hypoXY, 'euclidean' );
                    n2 = diag(n2);
%                     n3 = diag(n3);
%                     n4 = diag(n4);
                    % inlier calculation
                    inlierIndex = n2 < threshold;
                    temp_inlier_number = sum( inlierIndex(:) );
                    % better or discard 
                    if temp_inlier_number > inlier_number
                        inlier_number = temp_inlier_number;
                        point1x = featurePoint{i}( :, 1 );
                        point1y = featurePoint{i}( :, 2 );
                        point2x = featurePoint{2}( :, 1 );
                        point2y = featurePoint{2}( :, 2 );
                        inlier_array = [ point1x(inlierIndex), point1y(inlierIndex) ];
                        dest_array = [ point2x(inlierIndex), point2y(inlierIndex) ];
                        residual_avg = sum(sum( n2 )) / size( n2, 1 );
                        H = tempH;
                    elseif temp_inlier_number == inlier_number
                    	temp_residual_avg = sum(sum( n2 )) / size( n2, 1 );
                    	if temp_residual_avg < residual_avg
                            inlier_number = temp_inlier_number;
                            point1x = featurePoint{i}( :, 1 );
                            point1y = featurePoint{i}( :, 2 );
                            point2x = featurePoint{2}( :, 1 );
                            point2y = featurePoint{2}( :, 2 );
                            inlier_array = [ point1x(inlierIndex), point1y(inlierIndex) ];
                            dest_array = [ point2x(inlierIndex), point2y(inlierIndex) ];
                            residual_avg = temp_residual_avg;
                            H = tempH;
                    	end
                    end
                end
            end
        end
    end
else % homography
    for i = 1 : 1 % numberOfImages
        H = zeros( 3, 3 );
%         A = zeros(6, 6);
%         B = zeros(6, 6);
        inlier_number = 0;
        residual_avg = realmax('double');
        threshold = 3;
        for j1 = 1 : numOfFeatures 
        	for j2 = j1 + 1 : numOfFeatures 
            	for j3 = j2 + 1 : numOfFeatures 
                	for j4 = j3 + 1 : numOfFeatures 
                        % get X from AX=0
                        A = [ ...
                            featurePoint{i}(j1, 1) featurePoint{i}(j1, 2) 1 0 0 0 -featurePoint{i}(j1, 1)*featurePoint{2}(j1, 1) -featurePoint{i}(j1, 2)*featurePoint{2}(j1, 1) -featurePoint{2}(j1, 1); ...
                            0 0 0 featurePoint{i}(j1, 1) featurePoint{i}(j1, 2) 1 -featurePoint{i}(j1, 1)*featurePoint{2}(j1, 2) -featurePoint{i}(j1, 2)*featurePoint{2}(j1, 2) -featurePoint{2}(j1, 2); ...
                            featurePoint{i}(j2, 1) featurePoint{i}(j2, 2) 1 0 0 0 -featurePoint{i}(j2, 1)*featurePoint{2}(j2, 1) -featurePoint{i}(j2, 2)*featurePoint{2}(j2, 1) -featurePoint{2}(j2, 1); ...
                            0 0 0 featurePoint{i}(j2, 1) featurePoint{i}(j2, 2) 1 -featurePoint{i}(j2, 1)*featurePoint{2}(j2, 2) -featurePoint{i}(j2, 2)*featurePoint{2}(j2, 2) -featurePoint{2}(j2, 2); ...
                            featurePoint{i}(j3, 1) featurePoint{i}(j3, 2) 1 0 0 0 -featurePoint{i}(j3, 1)*featurePoint{2}(j3, 1) -featurePoint{i}(j3, 2)*featurePoint{2}(j3, 1) -featurePoint{2}(j3, 1); ...
                            0 0 0 featurePoint{i}(j3, 1) featurePoint{i}(j3, 2) 1 -featurePoint{i}(j3, 1)*featurePoint{2}(j3, 2) -featurePoint{i}(j3, 2)*featurePoint{2}(j3, 2) -featurePoint{2}(j3, 2); ...
                            featurePoint{i}(j4, 1) featurePoint{i}(j4, 2) 1 0 0 0 -featurePoint{i}(j4, 1)*featurePoint{2}(j4, 1) -featurePoint{i}(j4, 2)*featurePoint{2}(j4, 1) -featurePoint{2}(j4, 1); ...
                            0 0 0 featurePoint{i}(j4, 1) featurePoint{i}(j4, 2) 1 -featurePoint{i}(j4, 1)*featurePoint{2}(j4, 2) -featurePoint{i}(j4, 2)*featurePoint{2}(j4, 2) -featurePoint{2}(j4, 2) ...
                            ];
                        [ ~, ~, V ] = svd(A);
                        tempX = V( :,end );
                        tempH = [...
                            tempX(1) tempX(2) tempX(3); ...
                            tempX(4) tempX(5) tempX(6); ...
                            tempX(7) tempX(8) tempX(9)  ...
                            ];
                        clear tempX;
                        % get inlier number and residual sum
                        hypoXY = zeros( numOfFeatures, 2 );
                        for jj = 1 : numOfFeatures 
                            hypoA = [ ...
                            featurePoint{i}(jj, 1); ...
                            featurePoint{i}(jj, 2); ...
                            1 ...
                            ];
                            tempX = tempH * hypoA; 
                            hypoXY( jj, : ) = tempX( 1:2, 1 ) / tempX(3, 1);
                            clear tempX;
                        end
                        % distance Matrix
                        n2 = dist2( featurePoint{2}, hypoXY );
    %                     n2 = pdist2( featurePoint{2}, hypoXY, 'euclidean' );
                        n2 = diag(n2);
                        % inlier calculation
                        inlierIndex = n2 < threshold;
                        temp_inlier_number = sum( inlierIndex(:) );
                        % better or discard 
                        if temp_inlier_number > inlier_number
                            inlier_number = temp_inlier_number;
                            point1x = featurePoint{i}( :, 1 );
                            point1y = featurePoint{i}( :, 2 );
                            point2x = featurePoint{2}( :, 1 );
                            point2y = featurePoint{2}( :, 2 );
                            inlier_array = [ point1x(inlierIndex), point1y(inlierIndex) ];
                            dest_array = [ point2x(inlierIndex), point2y(inlierIndex) ];
                            residual_avg = sum(sum( n2 )) / size( n2, 1 );
                            H = tempH;
                        elseif temp_inlier_number == inlier_number
                            temp_residual_avg = sum(sum( n2 )) / size( n2, 1 );
                            if temp_residual_avg < residual_avg
                                inlier_number = temp_inlier_number;
                                point1x = featurePoint{i}( :, 1 );
                                point1y = featurePoint{i}( :, 2 );
                                point2x = featurePoint{2}( :, 1 );
                                point2y = featurePoint{2}( :, 2 );
                                inlier_array = [ point1x(inlierIndex), point1y(inlierIndex) ];
                                dest_array = [ point2x(inlierIndex), point2y(inlierIndex) ];
                                residual_avg = temp_residual_avg;
                                H = tempH;
                            end
                        end
                    end
                end
            end
        end
    end
end
toc(tic6);

%% Step 7
tic7 = tic;
% Warp one image onto the other 
if affine == 1 % affine
    xform = [ H(1)  H(2)  0; ...
        H(3)  H(4)  0; ...
        H(5) H(6)  1 ];
    tform = maketform( 'affine', xform );
% t = cp2tform(input_points,base_points,'nonreflective similarity');
%     tform = cp2tform( inlier_array, dest_array, 'affine' );
else % homogeneous
% 	xform = H';
%     tform = maketform( 'projective', xform );
    tform = cp2tform( inlier_array, dest_array, 'projective' );
end
%     xform = [ 1  1  0; ...
%         0  1  0; ...
%         0 0  1 ];
% 	maketform( 'affine', xform );
    I = imgDouble{1};
	J = imtransform( I, tform );
	figure, imshow(J);

toc(tic7);

end

