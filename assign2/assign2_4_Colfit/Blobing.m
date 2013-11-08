function [ cx, cy, rad, imgB ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor )
%BLOBING Summary of this function goes here
%   Detailed explanation goes here

%% Times to Scale 
d = r * 2;
times = 0;
[ times, scale ] = get_Times( times, d, scale, ScaleFactor, sqrt_Size / 100, sqrt_Size / 7 );
r = r * scale;
rSpace(1, times) = 0;
for i = 1 : times
    if i == 1
        rSpace(1, i) = r;
    else
        rSpace(1, i) = rSpace(1, i-1) * ScaleFactor;
    end
end
imgA_Copy = imgA;
times_To_Delete = zeros(1, times);

%% Generate imgB Stack
imgB_Stack(size(imgA, 1), size(imgA, 2), times) = 0;
sizeX = size(imgA, 1);
sizeY = size(imgA, 2);
% scaleArray
% scaleArray = [ 0.9 0.9 0.98 0.98 0.9 0.9 0.9 0.9 0.9];

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
    minValue = min(imgB(:));
    maxValue = max(imgB(:));
    if minValue + 0.0000001 < maxValue
%         thresHold = minValue + (maxValue - minValue) * scaleArray(1, i);
% 
%         for ii = 1 : m 
%             for jj = 1 : n
%                 if imgB(ii, jj) > thresHold && imgB(ii, jj) < 0
%                     imgB(ii, jj) = 0;
%                 end
%             end
%         end

        % single layer suppression
        % width = max( round( sqrt(pi * r * r) / 2 ), 1);
        width = floor( 2 * rSpace(1, i) ) + 1;
        if mod(width, 2) == 0
            width = width + 1;
        end
        % Accelerating
%         imgB = nlfilter(imgB, [width width], @Ismin);
        imgB = colfilt(imgB, [width width], 'sliding', @IsMinNew);
        %% Take in the stack
%         [ imgB ] = Harris_Edge_Remover( imgB, imgA, scale, [sizeX sizeY] );
        imgB_Stack(:,:,i) = imgB;
    else
        times_To_Delete(1, i) = 1;
    end
    %% Para Adjust 
    scale = scale * ScaleFactor;
end

% Delete anything that need to 
temp_times = times;
for i = 1 : times
    if times_To_Delete(1, i) == 1;
        imgB_Stack(:,:,i) = [];
        rSpace(1, i) = [];
        temp_times = temp_times - 1;
    end
end
times = temp_times;
sum(sum(sum( imgB_Stack < 0 )))

%% Multiple Layer nonMaxima Suppression
% for x = 1 : sizeX
%     for y = 1 : sizeY
%         flag = 0;
%         for i = 1 : times
%             if imgB_Stack(x,y,i) >= 0
%                 flag = 1;
%                 break;
%             end
%         end
%         if flag == 1
%             for i = 1 : times 
%                 imgB_Stack(x,y,i) = 0;
%             end
%         else
%             found = 0;
%             for i = times: -1: 1 
%                 if found == 0 
%                     if imgB_Stack(x,y,i) < 0
%                         found = 1;
%                         continue ;
%                     end
%                 else
%                     imgB_Stack(x,y,i) = 0;
%                 end
%             end
%         end
%     end
% end


% for i = 1 : times - 1
%     for x = 1 : sizeX
%         for y = 1 : sizeY
%             if imgB_Stack(x, y, i) >= 0
%                 imgB_Stack(x, y, i+1) = 0;
%             end
%             if imgB_Stack(x, y, i+1) >= 0
%                 imgB_Stack(x, y, i) = 0;
%             end
%         end
%     end
% end

sum(sum(sum( imgB_Stack < 0 )))

%% Harris_Edge_Remover
[ imgB_Stack ] = Harris_Edge_Remover_Plus( imgB_Stack, imgA_Copy, times );
sum(sum(sum( imgB_Stack < 0 )))
sum(sum( imgB_Stack < 0 ))

%% Result Circles Coloumn Array Generating
for i = 1 : times
    if exist('cx', 'var')
        [ cxx, cyy, ~ ] = find( imgB_Stack(:,:,i) < 0 );
        cx( size(cx, 1) + 1: size(cx, 1) + size(cxx, 1), 1 ) = cxx;
        cy( size(cy, 1) + 1: size(cy, 1) + size(cyy, 1), 1 ) = cyy;
    else
        [ cx, cy, ~ ] = find( imgB_Stack(:,:,i) < 0 );
    end
    if i == 1
        rad( 1: size(cx, 1), 1 ) = rSpace(1, i);
    else
        rad( size(rad, 1) + 1: size(rad, 1) + size(cxx, 1), 1 ) = rSpace(1, i);
    end
end

% Debugging Para
times

clear imgB_Stack
clear imgA
clear imgA_Copy
clear times
clear times_To_Delete
clear cxx
clear cyy
clear rSpace
clear d 
clear scale

end

