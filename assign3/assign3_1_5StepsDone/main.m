function [  ] = main(  )
%MIAN Summary of this function goes here
%   Detailed explanation goes here

begin = tic();
%% Step 1 Load both images, convert to double and to grayscale.
s = 1;
halfPatchWidth = 4;
display = 0;

numberOfImages = 2;%
fileName = char('100-0023_img.jpg', '100-0024_img.jpg' );

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

%% Step 2 Detect feature points in both images. 
for i = 1 : numberOfImages
    numberOfSupsampling = 3;%
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
    for j = 2 : numberOfSupsampling
        newDescriptor{i} = [ newDescriptor{i}; descriptor{i}{j} ];
    end
end
toc(begin);

%% Step 4
% Compute distances between every descriptor in one image and every descriptor in the other image. 
% You can use this code for fast computation of Euclidean distance.
n2 = dist2( newDescriptor{1}, newDescriptor{2});



%% Step 5
%  select the top few hundred descriptor pairs with the smallest pairwise distances.
B = sort( n2(:), 'ascend' );
threshold = B( min( 200, size(B, 1)) );
% [r,c,v] = find(X>2)
[ r c ] = find( n2 < threshold );

%% Step 6
% RANSAC (1) an affine transformation and (2) a homography




toc(begin);

end

