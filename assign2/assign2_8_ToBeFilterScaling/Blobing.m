function [ cx, cy, rad, ReNumber ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor, ReNumber )
%BLOBING Summary of this function goes here
%   Detailed explanation goes here

%% Times to Scale 
d = r * 2;
times = 0;
[ times, scale ] = get_Times( times, d, scale, ScaleFactor, sqrt_Size / 70, sqrt_Size / 12 );
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
imgB_MaximaSuppressionStack(size(imgA, 1), size(imgA, 2), times) = 0;
imgB_OriginalStack(size(imgA, 1), size(imgA, 2), times) = 0;
sizeX = size(imgA, 1);
sizeY = size(imgA, 2);

SingleSuppression = tic;
for i = 1 : times
    % First Scale
    if i == 1
        imgA = imresize(imgA, 1/ scale );
    else
        imgA = imresize(imgA, 1/ ScaleFactor );
    end
    %% Filtering
    imgB = Filter_Without_Scale( imgA, h);
    %% Single Layer nonMaxima Suppression
    % Resize Back
    imgB = imresize(imgB, [sizeX sizeY], 'lanczos3' );

    % threshold
    minValue = min(imgB(:));
    maxValue = max(imgB(:));
    % Square for parallel local maxima accepting
    imgB = imgB .^ 2;
    if minValue + 0.000000001 < maxValue
        % single layer nonMaxima suppression
        width = ceil( 1.8 * rSpace(1, i) ) + 1;  %1.7725
        if mod(width, 2) == 0
            width = width + 1;
        end
        % Accelerating
        %% Take in the stack
        imgB_MaximaSuppressionStack(:,:,i) = ordfilt2(imgB, width * width, ones(width,width));
        imgB_OriginalStack(:,:,i) = imgB;
        imgB_MaximaSuppressionStack(:,:,i) = imgB_OriginalStack(:,:,i) .* (imgB_OriginalStack(:,:,i) == imgB_MaximaSuppressionStack(:,:,i));
    else
        times_To_Delete(1, i) = 1;
    end
    %% Para Adjust 
    scale = scale * ScaleFactor;
end

% Delete any layer that need to 
temp_times = times;
for i = 1 : times
    if times_To_Delete(1, i) == 1;
        imgB_MaximaSuppressionStack(:,:,i) = [];
        imgB_OriginalStack(:,:,i) = [];
        rSpace(1, i) = [];
        temp_times = temp_times - 1;
    end
end
times = temp_times;
circleNum1 = sum(sum(sum( imgB_MaximaSuppressionStack > 0 )))
toc(SingleSuppression);

%% Multiple Layer nonMaxima Suppression
% MultiSuppression = tic;
% for i = 1 : times - 1 
%      % Maxima
% 	imgB_MaximaSuppressionStack(:,:,i+1) = imgB_MaximaSuppressionStack(:,:,i+1) .* ( imgB_MaximaSuppressionStack(:,:,i) < imgB_MaximaSuppressionStack(:,:,i+1) );
% 	imgB_MaximaSuppressionStack(:,:,i) = imgB_MaximaSuppressionStack(:,:,i) .* ( imgB_MaximaSuppressionStack(:,:,i) > imgB_MaximaSuppressionStack(:,:,i+1) );
% end
% for i = 1 : times
% 	imgB_MaximaSuppressionStack(:,:,i) = imgB_OriginalStack(:,:,i) == imgB_MaximaSuppressionStack(:,:,i);
% end
% circleNum2 = sum(sum(sum( imgB_MaximaSuppressionStack > 0 )))
% % diffNumMultiSuppression = circleNum1 - circleNum2
% % ReNumber = ReNumber + diffNumMultiSuppression;

%Experiment
MultiSuppression = tic;
for i = 1 : times - 1 
     % Maxima
	imgB_MaximaSuppressionStack(:,:,i+1) = imgB_MaximaSuppressionStack(:,:,i+1) .* ( imgB_MaximaSuppressionStack(:,:,i) < imgB_MaximaSuppressionStack(:,:,i+1) );
	imgB_MaximaSuppressionStack(:,:,i) = imgB_MaximaSuppressionStack(:,:,i) .* ( imgB_MaximaSuppressionStack(:,:,i) > imgB_MaximaSuppressionStack(:,:,i+1) );
end
circleNum2 = sum(sum(sum( imgB_MaximaSuppressionStack > 0 )))
for i = 1 : times - 2
	imgB_MaximaSuppressionStack(:,:,i+2) = imgB_MaximaSuppressionStack(:,:,i+2) .* ( imgB_MaximaSuppressionStack(:,:,i) < imgB_MaximaSuppressionStack(:,:,i+2) );
	imgB_MaximaSuppressionStack(:,:,i) = imgB_MaximaSuppressionStack(:,:,i) .* ( imgB_MaximaSuppressionStack(:,:,i) > imgB_MaximaSuppressionStack(:,:,i+2) );
end
% for i = 1 : times
% 	imgB_MaximaSuppressionStack(:,:,i) = imgB_OriginalStack(:,:,i) == imgB_MaximaSuppressionStack(:,:,i);
% end
circleNum3 = sum(sum(sum( imgB_MaximaSuppressionStack > 0 )))
diffNumMultiSuppression = circleNum1 - circleNum3
ReNumber = ReNumber + diffNumMultiSuppression;

toc(MultiSuppression);

%% Result Circles Coloumn Array Generating
for i = 1 : times
    if exist('cx', 'var')
        [ cxx, cyy, ~ ] = find( imgB_MaximaSuppressionStack(:,:,i) > 0 );
        cx( size(cx, 1) + 1: size(cx, 1) + size(cxx, 1), 1 ) = cxx;
        cy( size(cy, 1) + 1: size(cy, 1) + size(cyy, 1), 1 ) = cyy;
    else
        [ cx, cy, ~ ] = find( imgB_MaximaSuppressionStack(:,:,i) > 0 );
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
clear imgB_MaximaSuppressionStack
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

