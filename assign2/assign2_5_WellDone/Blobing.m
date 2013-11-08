function [ cx, cy, rad, ReNumber ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor, ReNumber )
%BLOBING Summary of this function goes here
%   Detailed explanation goes here

%% Times to Scale 
d = r * 2;
times = 0;
[ times, scale ] = get_Times( times, d, scale, ScaleFactor, sqrt_Size / 70, sqrt_Size / 7 );
r = r * scale;
rSpace(1, times) = 0;
for i = 1 : times
    if i == 1
        rSpace(1, i) = r;
    else
        rSpace(1, i) = rSpace(1, i-1) * ScaleFactor;
    end
end
% imgA_Copy = imgA;
times_To_Delete = zeros(1, times);

%% Generate imgB Stack
imgB_MinimaSuppressionStack(size(imgA, 1), size(imgA, 2), times) = 0;
imgB_MaximaSuppressionStack(size(imgA, 1), size(imgA, 2), times) = 0;
imgB_OriginalStack(size(imgA, 1), size(imgA, 2), times) = 0;
sizeX = size(imgA, 1);
sizeY = size(imgA, 2);
% thresholdArray
% thresholdArray = [ 1 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 ];

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
    imgB = imresize(imgB, [sizeX sizeY] );

    % threshold
%     m = size(imgB, 1);
%     n = size(imgB, 2);
%     meanValue = mean(imgB(:));
    minValue = min(imgB(:));
    maxValue = max(imgB(:));
    if minValue + 0.0000001 < maxValue
%         thresHold = minValue + (maxValue - minValue) * thresholdArray(1, 1);
%         for ii = 1 : m 
%             for jj = 1 : n
%                 if imgB(ii, jj) > thresHold && imgB(ii, jj) < 0
%                     imgB(ii, jj) = 0;
%                 end
%             end
%         end

        % single layer suppression
        % width = max( round( sqrt(pi * r * r) / 2 ), 1);
        width = ceil( 2 * rSpace(1, i) ) + 1;
        if mod(width, 2) == 0
            width = width + 1;
        end
        % Accelerating
%           imgB = nlfilter(imgB, [width width], @Ismin);
%          imgB = colfilt(imgB, [width width], 'sliding', @IsMinNew);
%         imgB = imgB .* (imgB == ordfilt2(imgB,1,ones(width,width)) );
        
        %% Take in the stack
%         [ imgB ] = Harris_Edge_Remover( imgB, imgA, scale, [sizeX sizeY] );
        imgB_MinimaSuppressionStack(:,:,i) = ordfilt2(imgB,1,ones(width,width));
        imgB_MaximaSuppressionStack(:,:,i) = ordfilt2(imgB,width * width,ones(width,width));
        imgB_OriginalStack(:,:,i) = imgB;
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
        imgB_MinimaSuppressionStack(:,:,i) = [];
        imgB_MaximaSuppressionStack(:,:,i) = [];
%         imgB_OriginalStack(:,:,i) = [];
        rSpace(1, i) = [];
        temp_times = temp_times - 1;
    end
end
times = temp_times;
% circleNum1 = sum(sum(sum( imgB_MinimaSuppressionStack ~= 0 )))
toc(SingleSuppression);

%% Multiple Layer nonMaxima Suppression
MultiSuppression = tic;
% for x = 1 : sizeX
%     for y = 1 : sizeY
%         flag = 0;
%         for i = 1 : times
%             if imgB_MinimaSuppressionStack(x,y,i) >= 0
%                 flag = 1;
%                 break;
%             end
%         end
%         if flag == 1
%             for i = 1 : times 
%                 imgB_MinimaSuppressionStack(x,y,i) = 0;
%             end
%         else
%             found = 0;
%             for i = times: -1: 1 
%                 if found == 0 
%                     if imgB_MinimaSuppressionStack(x,y,i) < 0
%                         found = 1;
%                         continue ;
%                     end
%                 else
%                     imgB_MinimaSuppressionStack(x,y,i) = 0;
%                 end
%             end
%         end
%     end
% end


% for i = 1 : times - 1
%     for x = 1 : sizeX
%         for y = 1 : sizeY
%             if imgB_MinimaSuppressionStack(x, y, i) >= 0
%                 imgB_MinimaSuppressionStack(x, y, i+1) = 0;
%             end
%             if imgB_MinimaSuppressionStack(x, y, i+1) >= 0
%                 imgB_MinimaSuppressionStack(x, y, i) = 0;
%             end
%         end
%     end
% end


% if 1 %times < 3
%     for i = 1 : times - 1
%         width = floor( 2 * rSpace(1, i + 1) ) + 1;
%         imgB_Plane = Stack2Plane( imgB_MinimaSuppressionStack(:,:,i:i+1) );
%         imgB_Plane = colfilt(imgB_Plane, [width * 2 width], 'sliding', @IsMinNew);
%         imgB_MinimaSuppressionStack(:,:,i:i+1) = Plane2Stack( imgB_Plane, 2);
%     end
% else
%     for i = 2 : times - 1
%         width = floor( 2 * rSpace(1, i + 1) ) + 1;
%         imgB_Plane = Stack2Plane( imgB_MinimaSuppressionStack(:,:,i-1:i+1) );
%         imgB_Plane = colfilt(imgB_Plane, [width * 3 width], 'sliding', @IsMinNew);
%         imgB_MinimaSuppressionStack(:,:,i-1:i+1) = Plane2Stack( imgB_Plane, 3);
%     end
% end
% Minima
for i = 1 : times - 1 
     % Minima
     imgB_MinimaSuppressionStack(:,:,i+1) = imgB_MinimaSuppressionStack(:,:,i+1) .* ( imgB_MinimaSuppressionStack(:,:,i) > imgB_MinimaSuppressionStack(:,:,i+1) );
     imgB_MinimaSuppressionStack(:,:,i) = imgB_MinimaSuppressionStack(:,:,i) .* ( imgB_MinimaSuppressionStack(:,:,i) < imgB_MinimaSuppressionStack(:,:,i+1) );
     % Maxima
     imgB_MaximaSuppressionStack(:,:,i+1) = imgB_MaximaSuppressionStack(:,:,i+1) .* ( imgB_MaximaSuppressionStack(:,:,i) < imgB_MaximaSuppressionStack(:,:,i+1) );
     imgB_MaximaSuppressionStack(:,:,i) = imgB_MaximaSuppressionStack(:,:,i) .* ( imgB_MaximaSuppressionStack(:,:,i) > imgB_MaximaSuppressionStack(:,:,i+1) );
end
for i = 1 : times
    imgB_MinimaSuppressionStack(:,:,i) = imgB_OriginalStack(:,:,i) == imgB_MinimaSuppressionStack(:,:,i);
    imgB_MaximaSuppressionStack(:,:,i) = imgB_OriginalStack(:,:,i) == imgB_MaximaSuppressionStack(:,:,i);
    imgB_MinimaSuppressionStack = imgB_MinimaSuppressionStack + imgB_MaximaSuppressionStack;
end
circleNum2 = sum(sum(sum( imgB_MinimaSuppressionStack ~= 0 )))
% diffNumMultiSuppression = circleNum1 - circleNum2
% ReNumber = ReNumber + diffNumMultiSuppression;
toc(MultiSuppression);


%% Result Circles Coloumn Array Generating
for i = 1 : times
    if exist('cx', 'var')
        [ cxx, cyy, ~ ] = find( imgB_MinimaSuppressionStack(:,:,i) ~= 0 );
        cx( size(cx, 1) + 1: size(cx, 1) + size(cxx, 1), 1 ) = cxx;
        cy( size(cy, 1) + 1: size(cy, 1) + size(cyy, 1), 1 ) = cyy;
    else
        [ cx, cy, ~ ] = find( imgB_MinimaSuppressionStack(:,:,i) ~= 0 );
    end
    if i == 1
        rad( 1: size(cx, 1), 1 ) = rSpace(1, i);
    else
        rad( size(rad, 1) + 1: size(rad, 1) + size(cxx, 1), 1 ) = rSpace(1, i);
    end
end



% Debugging Para
times

clear imgB_OriginalStack
clear imgB_MinimaSuppressionStack
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

