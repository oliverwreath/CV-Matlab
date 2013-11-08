function [ cx, cy, rad, ReNumber ] = Blobing_FilterScale( imgA, sqrt_Size, h, r, scale, ScaleFactor, ReNumber )
%BLOBING Summary of this function goes here
%   Detailed explanation goes here

%% Times to Scale 
d = r * 2;
times = 0;
[ times, scale ] = get_Times( times, d, scale, ScaleFactor, sqrt_Size / 60, sqrt_Size / 9 );
r = r * scale;
rSpace(1, times) = 0;
for i = 1 : times
    if i == 1
        rSpace(1, i) = r;
    else
        rSpace(1, i) = rSpace(1, i-1) * ScaleFactor;
    end
end
times_To_Delete = zeros(1, times);

%% Generate imgB Stack
imgB_SingleSupStack(size(imgA, 1), size(imgA, 2), times) = 0;
imgB_OriginalStack(size(imgA, 1), size(imgA, 2), times) = 0;
sizeX = size(imgA, 1);
sizeY = size(imgA, 2);

SingleSuppression = tic;
for i = 1 : times
    % First Scale
    [ h, ~ ] = LoG_Filter_Normalized_Scale( scale ) ;
    %% Filtering
    imgB = Filter_Without_Scale( imgA, h);
    %% Single Layer nonMaxima Suppression
    % Resize Back
    imgB = imresize(imgB, [sizeX sizeY], 'lanczos3' );

    % Square for parallel local maxima accepting
    imgB = imgB .^ 2;
    % threshold
    maxValue = max(imgB(:));
    B = sort(imgB(:), 'descend');
    thresholdValue = B( min( 9999, ceil( size(B, 1) ) ) );
    if thresholdValue + 0.000000001 < maxValue
        % threshold Suppression
        imgB = imgB.*(imgB > thresholdValue);
        %% single layer nonMaxima suppression
%         width = ceil( 1.8 * rSpace(1, i) ) + 1;  %1.7725
%         if mod(width, 2) == 0
%             width = width + 1;
%         end
        % Accelerating
        %% Take in the stack
        width = 3;
        imgB_SingleSupStack(:,:,i) = ordfilt2(imgB, width * width, ones(width,width));
        imgB_OriginalStack(:,:,i) = imgB;
        imgB_SingleSupStack(:,:,i) = imgB_OriginalStack(:,:,i) .* (imgB_OriginalStack(:,:,i) == imgB_SingleSupStack(:,:,i));
    else
        times_To_Delete(1, i) = 1;
    end
    %% Para Adjust 
    scale = scale * ScaleFactor;
end

%% Delete any layer that need to 
temp_times = times;
for i = 1 : times
    if times_To_Delete(1, i) == 1;
        imgB_SingleSupStack(:,:,i) = [];
        imgB_OriginalStack(:,:,i) = [];
        rSpace(1, i) = [];
        temp_times = temp_times - 1;
    end
end
times = temp_times;
circleNum1 = sum(sum(sum( imgB_SingleSupStack > 0 )))
toc(SingleSuppression);

%% Multi-layer nonMaxima Suppression
MultiSuppression = tic;
% experiment
for i = 1 : times - 2
    A1 = imgB_SingleSupStack(:,:,i) > imgB_SingleSupStack(:,:,i+1);
    A2 = imgB_SingleSupStack(:,:,i+1) > imgB_SingleSupStack(:,:,i+2);
    A3 = imgB_SingleSupStack(:,:,i) > imgB_SingleSupStack(:,:,i+2);
    A4 = imgB_SingleSupStack(:,:,i) < imgB_SingleSupStack(:,:,i+1);
    A5 = imgB_SingleSupStack(:,:,i+1) < imgB_SingleSupStack(:,:,i+2);
    A6 = imgB_SingleSupStack(:,:,i) < imgB_SingleSupStack(:,:,i+2);
    imgB_SingleSupStack(:,:,i) = imgB_SingleSupStack(:,:,i) .* A1 .* A3;
    imgB_SingleSupStack(:,:,i+1) = imgB_SingleSupStack(:,:,i+1) .* A2 .* A4;
    imgB_SingleSupStack(:,:,i+2) = imgB_SingleSupStack(:,:,i+2) .* A5 .* A6;
end
circleNum2 = sum(sum(sum( imgB_SingleSupStack > 0 )))
diffNumMultiSuppression = circleNum1 - circleNum2
ReNumber = ReNumber + diffNumMultiSuppression;
toc(MultiSuppression);

%% Result Circles Coloumn Array Generating
for i = 1 : times
    if exist('cx', 'var')
        [ cxx, cyy, ~ ] = find( imgB_SingleSupStack(:,:,i) > 0 );
        cx( size(cx, 1) + 1: size(cx, 1) + size(cxx, 1), 1 ) = cxx;
        cy( size(cy, 1) + 1: size(cy, 1) + size(cyy, 1), 1 ) = cyy;
    else
        [ cx, cy, ~ ] = find( imgB_SingleSupStack(:,:,i) > 0 );
    end
    if i == 1
        rad( 1: size(cx, 1), 1 ) = rSpace(1, i);
    else
        rad( size(rad, 1) + 1: size(rad, 1) + size(cxx, 1), 1 ) = rSpace(1, i);
    end
end

%% Debugging Para
times
clear imgB_OriginalStack
clear imgB_SingleSupStack
clear imgB_LogicMultiSupStack
clear imgA
clear imgB
% clear imgA_Copy
clear times
clear times_To_Delete
clear cxx
clear cyy
clear rSpace
clear d 
clear scale


end

