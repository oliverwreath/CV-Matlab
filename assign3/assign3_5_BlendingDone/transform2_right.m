function [ imgDouble, tform, tform2, xdata, ydata ] = transform2_right( fileName )
%TRANSFORM2 Match transform between two pictures
%   between two pictures

%% Parameters.
s = 4;
halfPatchWidth = 4;
display = 0;
display2 = 0;
display3 = 1;
nd = 1;
thresNum = 70;
affine = 0;
numberOfSupsampling = 1;
newRANSAC = 1;
RANSACrounds = 11000;
tolerance = 0.5;
numberOfImages = 2;

%% Step 1 Load both images, convert to double and to grayscale.
begin = tic();
for i = 1 : numberOfImages
    if i == 1 
        imgDouble = cell( numberOfImages, 1 );
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
        [ cim{j} ] = harrisPlusSuppression( tempSupImage, 1, size(imgDouble{i}), 0.05, 1, 0 );
    end
%     for j = 1 : numberOfSupsampling
%         cim{j}
%     end
    for j = 1 : numberOfSupsampling - 2
        A1 = cim{j+1} > cim{j+2};
        A2 = cim{j} < cim{j+1};
        cim{j+1} = cim{j+1} .* A1 .* A2;
    end
    if numberOfSupsampling > 1
        j = 1;
        A1 = cim{j} > cim{j+1};
        cim{j} = cim{j} .* A1;
        j = numberOfSupsampling;
        A1 = cim{j} > cim{j-1};
        cim{j} = cim{j} .* A1;
    end
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
            sampleImage = imresize( sampleImage, [halfPatchWidth * 2, halfPatchWidth * 2] );
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
clear descriptor ;


%% Step 4
tic4 = tic;
% Compute distances between every descriptor in one image and every descriptor in the other image. 
a = newDescriptor{1};
b = newDescriptor{2};
% You can use this code for fast computation of Euclidean distance.
% method 1
% dist2 after normalizing all descriptors to have zero mean and unit standard deviation. 
% for i = 1 : size( a, 1 )
%     a(i, :) = ( a(i, :) - mean(a(i, :)) ) ./ std(a(i, :));
% end
% for i = 1 : size( b, 1 )
%     b(i, :) = ( b(i, :) - mean(b(i, :)) ) ./ std(b(i, :));
% end
% n2 = dist2( a, b );
% method 2
n2 = pdist2( a, b, 'correlation' );
% method 3
% for i = 1 : size( a, 1 )
%     a(i, :) = ( a(i, :) - mean(a(i, :)) ) ./ std(a(i, :));
% end
% for i = 1 : size( b, 1 )
%     b(i, :) = ( b(i, :) - mean(b(i, :)) ) ./ std(b(i, :));
% end
% n2 = pdist2( a, b, 'correlation' );
% method 4
% Euclidean distance after normalizing all descriptors to have zero mean and unit standard deviation. 
% for i = 1 : size( a, 1 )
%     a(i, :) = ( a(i, :) - mean(a(i, :)) ) ./ std(a(i, :));
% end
% for i = 1 : size( b, 1 )
%     b(i, :) = ( b(i, :) - mean(b(i, :)) ) ./ std(b(i, :));
% end
% n2 = pdist2( a, b, 'euclidean' );
toc(tic4);
clear newDescriptor;
clear a;
clear b;

%% Step 5
tic5 = tic;
if nd == 1
    B = zeros( size(n2) );
    % non-distinctive suppression
    for i = 1 : size(n2, 1)
        B( i, : ) = ndSuppressionMinimum( n2( i, : ) );
    end
    for i = 1 : size(n2, 2)
        B( :, i ) = ndSuppressionMinimum( B( :, i ) );
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
numOfFeatures = size( featurePoint{1}, 1 )
clear tempMatrix;
clear l;
clear r;

% result display
if display2 == 1
    for i = 1 : numberOfImages
        figure, imagesc(imgDouble{i}), axis image, colormap(gray), hold on
        for j = 1 : numOfFeatures 
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
if newRANSAC ~= 1 % old RANSAC
    % RANSAC (1) an affine transformation and (2) a homography
    % RANSAC affine
    if affine == 1 % affine
        for i = 1 : 1 % numberOfImages
            H = zeros(6, 1);
    %         A = zeros(6, 6);
    %         B = zeros(6, 6);
            inlier_number = 0;
            residual_avg = realmax('double');
            
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
%                         n2 = dist2( featurePoint{2}, hypoXY );
                        n2 = pdist2( featurePoint{2}, hypoXY, 'euclidean' );
                        n2 = diag(n2);
    %                     n3 = diag(n3);
    %                     n4 = diag(n4);
                        % inlier calculation
                        inlierIndex = n2 < tolerance;
                        temp_inlier_number = sum( inlierIndex(:) );
                        % better or discard 
                        if temp_inlier_number > inlier_number
                            inlier_number = temp_inlier_number;
                            point1x = featurePoint{i}( :, 1 );
                            point1y = featurePoint{i}( :, 2 );
                            point2x = featurePoint{2}( :, 1 );
                            point2y = featurePoint{2}( :, 2 );
                            input_points = [ featurePoint{i}(j1, :); featurePoint{i}(j2, :); featurePoint{i}(j3, :) ];
                            base_points = [ featurePoint{2}(j1, :); featurePoint{2}(j2, :); featurePoint{2}(j3, :) ];
                            inlier_input_points = [ point1x(inlierIndex), point1y(inlierIndex) ];
                            inlier_base_points = [ point2x(inlierIndex), point2y(inlierIndex) ];
                            n2inliers = n2(inlierIndex);
                            residual_avg = sum( n2 ) / size( n2, 1 );
                            H = tempH;
                        elseif temp_inlier_number == inlier_number
                            temp_residual_avg = sum( n2 ) / size( n2, 1 );
                            if temp_residual_avg < residual_avg
                                inlier_number = temp_inlier_number;
                                point1x = featurePoint{i}( :, 1 );
                                point1y = featurePoint{i}( :, 2 );
                                point2x = featurePoint{2}( :, 1 );
                                point2y = featurePoint{2}( :, 2 );
                                input_points = [ featurePoint{i}(j1, :); featurePoint{i}(j2, :); featurePoint{i}(j3, :) ];
                                base_points = [ featurePoint{2}(j1, :); featurePoint{2}(j2, :); featurePoint{2}(j3, :) ];
                                inlier_input_points = [ point1x(inlierIndex), point1y(inlierIndex) ];
                                inlier_base_points = [ point2x(inlierIndex), point2y(inlierIndex) ];
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
                            tempH = V( :, end );
                            tempH = reshape( tempH, 3, 3 )';
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
%                             n2 = dist2( featurePoint{2}, hypoXY );
                            n2 = pdist2( featurePoint{2}, hypoXY, 'euclidean' );
                            n2 = diag(n2);
                            % inlier calculation
                            inlierIndex = n2 < tolerance;
                            temp_inlier_number = sum( inlierIndex(:) );
                            % better or discard 
                            if temp_inlier_number > inlier_number
                                inlier_number = temp_inlier_number;
                                point1x = featurePoint{i}( :, 1 );
                                point1y = featurePoint{i}( :, 2 );
                                point2x = featurePoint{2}( :, 1 );
                                point2y = featurePoint{2}( :, 2 );
                                input_points = [ featurePoint{i}(j1, :); featurePoint{i}(j2, :); featurePoint{i}(j3, :); featurePoint{i}(j4, :) ];
                                base_points = [ featurePoint{2}(j1, :); featurePoint{2}(j2, :); featurePoint{2}(j3, :); featurePoint{2}(j4, :) ];
                                inlier_input_points = [ point1x(inlierIndex), point1y(inlierIndex) ];
                                inlier_base_points = [ point2x(inlierIndex), point2y(inlierIndex) ];
                                n2inliers = n2(inlierIndex);
                                residual_avg = sum( n2 ) / size( n2, 1 );
                                H = tempH;
                            elseif temp_inlier_number == inlier_number
                                temp_residual_avg = sum( n2 ) / size( n2, 1 );
                                if temp_residual_avg < residual_avg
                                    inlier_number = temp_inlier_number;
                                    point1x = featurePoint{i}( :, 1 );
                                    point1y = featurePoint{i}( :, 2 );
                                    point2x = featurePoint{2}( :, 1 );
                                    point2y = featurePoint{2}( :, 2 );
                                    input_points = [ featurePoint{i}(j1, :); featurePoint{i}(j2, :); featurePoint{i}(j3, :); featurePoint{i}(j4, :) ];
                                    base_points = [ featurePoint{2}(j1, :); featurePoint{2}(j2, :); featurePoint{2}(j3, :); featurePoint{2}(j4, :) ];
                                    inlier_input_points = [ point1x(inlierIndex), point1y(inlierIndex) ];
                                    inlier_base_points = [ point2x(inlierIndex), point2y(inlierIndex) ];
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
else
    % new RANSAC
    % RANSAC (1) an affine transformation and (2) a homography
    % RANSAC affine
    if affine == 1 % affine
        for i = 1 : 1 % numberOfImages
            H = zeros(6, 1);
            inlier_number = 0;
            residual_avg = realmax('double');
            
            flagMatrix = false(numOfFeatures, numOfFeatures, numOfFeatures);
            for rounds = 1 : RANSACrounds
                x = randsample( numOfFeatures, 3 );
                x = sort(x);
                j1 = x(1);
                j2 = x(2);
                j3 = x(3);
                if flagMatrix( j1, j2, j3 ) == true
                    continue;
                else
                    flagMatrix( j1, j2, j3 ) = true;
                end
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
%                 n2 = pdist2( featurePoint{2}, hypoXY, 'euclidean' );
                n2 = diag(n2);
                % inlier calculation
                inlierIndex = n2 < tolerance;
                temp_inlier_number = sum( inlierIndex(:) );
                % better or discard 
                if temp_inlier_number > inlier_number
                    inlier_number = temp_inlier_number;
                    point1x = featurePoint{i}( :, 1 );
                    point1y = featurePoint{i}( :, 2 );
                    point2x = featurePoint{2}( :, 1 );
                    point2y = featurePoint{2}( :, 2 );
                    input_points = [ featurePoint{i}(j1, :); featurePoint{i}(j2, :); featurePoint{i}(j3, :) ];
                    base_points = [ featurePoint{2}(j1, :); featurePoint{2}(j2, :); featurePoint{2}(j3, :) ];
                    inlier_input_points = [ point1x(inlierIndex), point1y(inlierIndex) ];
                    inlier_base_points = [ point2x(inlierIndex), point2y(inlierIndex) ];
                    n2inliers = n2(inlierIndex);
                    residual_avg = sum( n2inliers ) / size( n2inliers, 1 );
                    H = tempH;
                elseif temp_inlier_number == inlier_number
                    temp_residual_avg = sum( n2inliers ) / size( n2inliers, 1 );
                    if temp_residual_avg < residual_avg
                        inlier_number = temp_inlier_number;
                        point1x = featurePoint{i}( :, 1 );
                        point1y = featurePoint{i}( :, 2 );
                        point2x = featurePoint{2}( :, 1 );
                        point2y = featurePoint{2}( :, 2 );
                        input_points = [ featurePoint{i}(j1, :); featurePoint{i}(j2, :); featurePoint{i}(j3, :) ];
                        base_points = [ featurePoint{2}(j1, :); featurePoint{2}(j2, :); featurePoint{2}(j3, :) ];
                        inlier_input_points = [ point1x(inlierIndex), point1y(inlierIndex) ];
                        inlier_base_points = [ point2x(inlierIndex), point2y(inlierIndex) ];
                        residual_avg = temp_residual_avg;
                        H = tempH;
                    end
                end
            end
        end
    else % homography
        for i = 1 : 1 % numberOfImages
            H = zeros( 3, 3 );
            inlier_number = 0;
            residual_avg = realmax('double');

            flagMatrix = false(numOfFeatures, numOfFeatures, numOfFeatures, numOfFeatures);
            for rounds = 1 : RANSACrounds
                x = randsample( numOfFeatures, 4 );
                x = sort(x);
                j1 = x(1);
                j2 = x(2);
                j3 = x(3);
                j4 = x(4);
                if flagMatrix( j1, j2, j3 ) == true
                    continue;
                else
                    flagMatrix( j1, j2, j3 ) = true;
                end
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
                tempH = V( :, end );
                tempH = reshape( tempH, 3, 3 )';
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
%                 n2 = pdist2( featurePoint{2}, hypoXY, 'euclidean' );
                n2 = diag(n2);
                % inlier calculation
                inlierIndex = n2 < tolerance;
                temp_inlier_number = sum( inlierIndex(:) );
                % better or discard 
                if temp_inlier_number > inlier_number
                    inlier_number = temp_inlier_number;
                    point1x = featurePoint{i}( :, 1 );
                    point1y = featurePoint{i}( :, 2 );
                    point2x = featurePoint{2}( :, 1 );
                    point2y = featurePoint{2}( :, 2 );
                    input_points = [ featurePoint{i}(j1, :); featurePoint{i}(j2, :); featurePoint{i}(j3, :); featurePoint{i}(j4, :) ];
                    base_points = [ featurePoint{2}(j1, :); featurePoint{2}(j2, :); featurePoint{2}(j3, :); featurePoint{2}(j4, :) ];
                    inlier_input_points = [ point1x(inlierIndex), point1y(inlierIndex) ];
                    inlier_base_points = [ point2x(inlierIndex), point2y(inlierIndex) ];
                    n2inliers = n2(inlierIndex);
                    residual_avg = sum( n2inliers ) / size( n2inliers, 1 );
                    H = tempH;
                elseif temp_inlier_number == inlier_number
                    temp_residual_avg = sum( n2inliers ) / size( n2inliers, 1 );
                    if temp_residual_avg < residual_avg
                        inlier_number = temp_inlier_number;
                        point1x = featurePoint{i}( :, 1 );
                        point1y = featurePoint{i}( :, 2 );
                        point2x = featurePoint{2}( :, 1 );
                        point2y = featurePoint{2}( :, 2 );
                        input_points = [ featurePoint{i}(j1, :); featurePoint{i}(j2, :); featurePoint{i}(j3, :); featurePoint{i}(j4, :) ];
                        base_points = [ featurePoint{2}(j1, :); featurePoint{2}(j2, :); featurePoint{2}(j3, :); featurePoint{2}(j4, :) ];
                        inlier_input_points = [ point1x(inlierIndex), point1y(inlierIndex) ];
                        inlier_base_points = [ point2x(inlierIndex), point2y(inlierIndex) ];
                        residual_avg = temp_residual_avg;
                        H = tempH;
                    end
                end
            end
        end
    end
end

% result display
if display3 == 1
    imgDisplay = [ imgDouble{1} imgDouble{2} ];
    offset = size( imgDouble{1}, 2 );
    figure, imagesc( imgDisplay ), axis image, colormap(gray), hold on
    numOfFeaturesA = size( featurePoint{i}, 1 )
    numOfFeaturesI = size( inlier_input_points, 1 )
    for i = 1 : numberOfImages
        for j = 1 : numOfFeaturesA 
            if i == 1
                plot( featurePoint{1}(j, 2), featurePoint{1}(j, 1), 'ys'), title('corners detected');
            else
                plot( featurePoint{2}(j, 2) + offset, featurePoint{2}(j, 1), 'ys'), title('corners detected');
            end
        end
        for j = 1 : numOfFeaturesI 
            if i == 1
                plot( inlier_input_points(j, 2), inlier_input_points(j, 1), 'rs'), title('corners detected');
            else
                plot( inlier_base_points(j, 2) + offset, inlier_base_points(j, 1), 'rs'), title('corners detected');
            end
        end
    end
    for j = 1 : numOfFeaturesA 
        plot( [featurePoint{1}(j, 2), featurePoint{2}(j, 2) + offset], [featurePoint{1}(j, 1), featurePoint{2}(j, 1)], 'y'), title('corners detected');
    end
    for j = 1 : numOfFeaturesI 
        plot( [ inlier_input_points(j, 2), inlier_base_points(j, 2) + offset], [inlier_input_points(j, 1), inlier_base_points(j, 1)], 'r'), title('corners detected');
    end
    hold off
end

toc(tic6);

%% Step 7
tic7 = tic;
% Warp one image onto the other 

% test
input_points = [ input_points( :, 2 ), input_points( :, 1 ) ];
base_points = [ base_points( :, 2 ), base_points( :, 1 ) ];
inlier_input_points = [ inlier_input_points( :, 2 ), inlier_input_points( :, 1 ) ];
inlier_base_points = [ inlier_base_points( :, 2 ), inlier_base_points( :, 1 ) ];


if affine == 1 % affine
    % standard
%     tform = cp2tform( featurePoint{2}, featurePoint{1}, 'affine' );
	% method 1.1
%     xform = [ H(1)  H(3)  0; ...
%         H(2)  H(4)  0; ...
%         H(5)  H(6)  1 ];
%     tform = maketform( 'affine', xform );
    % method 1.2
    tform = maketform( 'affine', input_points, base_points );
    % method 2
%     tform = maketform('affine', inlier_input_points( 1: 3, : ), inlier_base_points( 1: 3, : ) );
    % method 3
%     tform = cp2tform( inlier_input_points, inlier_base_points, 'affine' );
else % homogeneous
    % standard
%     tform = cp2tform( featurePoint{2}, featurePoint{1}, 'projective' );
    % method 1.1
%     aa = H';
%     aa = aa ./ aa(3,3);
%     tform = maketform( 'projective', aa );
%     tform = fliptform( tform );
    % method 1.2
%     tform = maketform( 'projective', input_points, base_points );
    % method 2
%     tform = maketform('projective', inlier_input_points( 1: 4, : ), inlier_base_points( 1: 4, : ) );
    % method 3
    tform = cp2tform( inlier_input_points, inlier_base_points, 'projective' );
end
tform2 = fliptform( tform );
tform = maketform( 'projective', base_points, base_points );
[ ~, xdata, ydata ] = imtransform( imgDouble{2}, tform2 );


% % test
% if affine == 1 % affine
%     xdata(1) = min( xdata(1), 1 );
%     ydata(1) = min( ydata(1), 1 );
%     xdata(2) = max( xdata(2), size( imgDouble{2}, 2 ) );
%     ydata(2) = max( ydata(2), size( imgDouble{2}, 1 ) );
% 
%     xdata(2) = xdata(2) - xdata(1) + 1;
%     ydata(2) = ydata(2) - ydata(1) + 1;
%     xdata(1) = 1;
%     ydata(1) = 1;
% 
%     [ output1, ybound, xbound ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
%     figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;
% 
%     [ output2, ybound, xbound ] = imtransform( imgDouble{2}, maketform( 'affine', base_points, base_points ), 'XData', xdata, 'YData', ydata );
%     figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
% 
%     merge_output = output1 .* 0.5 + output2 .* 0.5;
%     figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
% else % homogeneous
%     xdata(1) = min( xdata(1), 1 );
%     ydata(1) = min( ydata(1), 1 );
%     xdata(2) = max( xdata(2), size( imgDouble{2}, 2 ) );
%     ydata(2) = max( ydata(2), size( imgDouble{2}, 1 ) );
% 
%     xdata2(2) = xdata(2) - xdata(1) + 1;
%     ydata2(2) = ydata(2) - ydata(1) + 1;
%     xdata2(1) = 1;
%     ydata2(1) = 1;
% 
% 
%     [ output1, ybound, xbound ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
%     figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;
% 
% %     [ output2, ybound, xbound ] = imtransform( imgDouble{2}, maketform( 'projective', base_points, base_points ), 'XData', xdata, 'YData', ydata );
%     output2 = imgDouble{2};
%     clear imgDouble;
%     figure, imshow( output2, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;
% 
%     output1( ydata(2), xdata(2) ) = 0;
%     output1 = output1 * 0.5;
%     output1( ydata(2) - size(output2, 1): ydata(2), ydata(2) - size(output2, 2): xdata(2) ) = output1( ydata(2) - size(output2, 1): ydata(2), ydata(2) - size(output2, 2): xdata(2) ) + output2 .* 0.5;
%     figure, imshow( output1, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
% end
% % end of test






% good piece
% find outer bounds 
xdata(1) = min( xdata(1), 1 );
ydata(1) = min( ydata(1), 1 );
xdata(2) = max( xdata(2), size( imgDouble{1}, 2 ) );
ydata(2) = max( ydata(2), size( imgDouble{1}, 1 ) );

% [ output1, xdata1, ydata1 ] = imtransform( imgDouble{1}, tform2, 'XData', xdata, 'YData', ydata );
% figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;


% [ output2, xdata2, ydata2 ] = imtransform( imgDouble{2}, tform, 'XData', xdata, 'YData', ydata );
% figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

% merge_output = output1 .* 0.5 + output2 .* 0.5;
% figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

% end of test



toc(tic7);

end

