function [ cx, cy, rad, imgB ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor )
%BLOBING Summary of this function goes here
%   Detailed explanation goes here

%% Times to Scale 
d = r * 2;
times = 0;
[ times, rrr, scale ] = get_Times( times, d, scale, ScaleFactor, sqrt_Size / 100, sqrt_Size / 5 );
imgA_Copy = imgA;
times_Copy = times;

%% Generate imgB Stack
imgB_Stack(size(imgA, 1), size(imgA, 2), times) = 0;
sizeX = size(imgA, 1);
sizeY = size(imgA, 2);
% scaleArray
scaleArray = [ 0.5 0.8 0.98 0.98 0.7 0.9 0.3];

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
    m = size(imgB, 1);
    n = size(imgB, 2);
    minValue = min(imgB(:));
    maxValue = max(imgB(:));
    if minValue + 0.0000001 < maxValue
        thresHold = minValue + (maxValue - minValue) * scaleArray(1, i);

        for ii = 1 : m 
            for jj = 1 : n
                if imgB(ii, jj) > thresHold && imgB(ii, jj) < 0
                    imgB(ii, jj) = 0;
                end
            end
        end
        % single layer suppression
        % width = max( round( sqrt(pi * r * r) / 2 ), 1);
        width = ceil( 2 * r ) + 1;
        imgB = imgB - 1;
        imgB = nlfilter(imgB, [width width], @Ismin);
        imgB = imgB + 1;
        %% Take in the stack
        [ imgB ] = Harris_Edge_Remover( imgB, imgA, scale, [sizeX sizeY] );
        imgB_Stack(:,:,i) = imgB;
    else
        times_Copy = times_Copy - 1 ;
    end
    %% Para Adjust 
    scale = scale * ScaleFactor;
    r = r * ScaleFactor;
end
sum(sum(sum( imgB_Stack < 0 )))

%% Multiple Layer nonMaxima Suppression
for x = 1 : size(imgA,1)
    for y = 1 : size(imgA,2)
        minValue = 0;
        for i = 1 : times
            if minValue > imgB_Stack(x,y,i)
                minValue = imgB_Stack(x,y,i);
            end
        end
        if minValue == 0
            for i = 1 : times 
                imgB_Stack(x,y,i) = 0;
            end
        else
            found = 0;
            for i = times: -1: 1 
                if found == 0 
                    if imgB_Stack(x,y,i) < 0 -0.00001
                        found = 1;
                        continue ;
                    end
                else
                    imgB_Stack(x,y,i) = 0;
                end
            end
        end
    end
end
sum(sum(sum( imgB_Stack < 0 )))

% %% Harris_Edge_Remover
% [ imgB_Stack ] = Harris_Edge_Remover_Plus( imgB_Stack, imgA_Copy, times );
% sum(sum(sum( imgB_Stack < 0 )))
% sum(sum( imgB_Stack < 0 ))
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
        rad( 1: size(cx, 1), 1 ) = rrr;
    else
        rad( size(rad, 1) + 1: size(rad, 1) + size(cxx, 1), 1 ) = rrr;
    end
    rrr = rrr * ScaleFactor;
end


clear imgB_Stack
clear imgA
clear imgA_Copy
clear times
clear times_Copy
clear cxx
clear cyy

end

