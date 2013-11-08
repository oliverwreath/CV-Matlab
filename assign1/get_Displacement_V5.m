function [ displacement_G, displacement_R ] = get_Displacement_V5( imgG, imgR, imgB, displacement_G, displacement_R, thresholdScale, distance_Measure_Selection, pyramid_DrillDown_Threshold )
%GET_DISPLACEMENT get the displacement from imageA to B, 
%%%   Copyright (c) <2013>, Yanliang Han
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
% 3. Neither the name of the University of Illinois at Urbana-Champaign nor the
%    names of its contributors may be used to endorse or promote products
%    derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY Yanliang Han ''AS IS'' AND ANY
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL Yanliang Han BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% %

%% Assuming A, B Share the same size !!

original_Threshold = ceil( size(imgG,1) / thresholdScale );
temp_x = sqrt( size(imgG, 1) * size(imgG, 2) );
if  temp_x > pyramid_DrillDown_Threshold 
    [ displacement_G, displacement_R ] = get_Displacement_V5( impyramid(imgG,'reduce'), impyramid(imgR,'reduce'), impyramid(imgB,'reduce'), displacement_G, displacement_R, thresholdScale, distance_Measure_Selection, pyramid_DrillDown_Threshold );
    x_gb = displacement_G(1, 1);
    y_gb = displacement_G(1, 2);
    x_rb = displacement_R(1, 1);
    y_rb = displacement_R(1, 2);
    x_gb = x_gb * 2 ;
    y_gb = y_gb * 2 ;
    x_rb = x_rb * 2 ;
    y_rb = y_rb * 2 ;
    threshold = 2;
else
    %action = 'don t drill';
    x_gb = displacement_G(1, 1);
    y_gb = displacement_G(1, 2);
    x_rb = displacement_R(1, 1);
    y_rb = displacement_R(1, 2);
    threshold = original_Threshold;
end


% 0.8 scalable scale
if temp_x <= 350
    searching_Area_Scale = 0.9;
else
    k = (0.09 - 0.9) / (3500 - 350);
    b = 0.9 - k * 350;
    searching_Area_Scale = k * ( temp_x ) + b;
end
if searching_Area_Scale < 0.01
    searching_Area_Scale = 0.01;
end
height = ceil( size(imgG,1) * searching_Area_Scale );
width = ceil( size(imgG,2) * searching_Area_Scale );
imgG = imgG( floor( (size(imgG,1) - height) / 2 ) + 1 : height + floor( (size(imgG,1) - height) / 2 ), floor( (size(imgG,2) - width) / 2 ) + 1 : width + floor( (size(imgG,2) - width) / 2 ));
imgR = imgR( floor( (size(imgR,1) - height) / 2 ) + 1 : height + floor( (size(imgR,1) - height) / 2 ), floor( (size(imgR,2) - width) / 2 ) + 1 : width + floor( (size(imgR,2) - width) / 2 ));
imgB = imgB( floor( (size(imgB,1) - height) / 2 ) + 1 : height + floor( (size(imgB,1) - height) / 2 ), floor( (size(imgB,2) - width) / 2 ) + 1 : width + floor( (size(imgB,2) - width) / 2 ));
% 0.8 scale done

% upperleftX - th = 1 ;
% upperleftX + th = h ;
% lowerightY - th = 1 ;
% lowerightY + th = w ;
upperleftX = original_Threshold + 1;
upperleftY = original_Threshold + 1;

% upperleftX + windowHeight = 
% Comparison Window Defined
windowHeight = height - 2 * original_Threshold - 1;
windowWidth = width - 2 * original_Threshold - 1;

% Searching Window Parameters Init
minDistance_G = 9999999999999999;
maxCorrelation_G = -9999999999999999;
minDistance_R = 9999999999999999;
maxCorrelation_R = -9999999999999999;

if x_gb == x_gb
    
    % Searching Window Start Coordinate Defined
    displacement_G_X = x_gb - threshold;
    displacement_G_Y = y_gb - threshold;

    t_start_G = max( (x_gb - threshold), 0 - original_Threshold );
    t_end_G = min( (x_gb + threshold), 0 + original_Threshold );
    t2_start_G = max( (y_gb - threshold), 0 - original_Threshold );
    t2_end_G = min( (y_gb + threshold), 0 + original_Threshold );
    
    displacement_R_X = x_rb - threshold;
    displacement_R_Y = y_rb - threshold;

    t_start_R = max( (x_rb - threshold), 0 - original_Threshold );
    t_end_R = min( (x_rb + threshold), 0 + original_Threshold );
    t2_start_R = max( (y_rb - threshold), 0 - original_Threshold );
    t2_end_R = min( (y_rb + threshold), 0 + original_Threshold );


    if distance_Measure_Selection == 1
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D1_Sum_of_Differences( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 2
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D2_Sum_of_Squared_Differences( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 3
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D3_Normalized_Cross_Correlation( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance > maxCorrelation_G
                    maxCorrelation_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 4
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D4_Sum_of_Gradient_Differences( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 5
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D5_SSD_of_Gradient( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 6
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D6_NCC_of_Gradient( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance > maxCorrelation_G
                    maxCorrelation_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 7
        % Memoization
        grad_of_G = gradient(imgG);
        grad_of_B = gradient(imgB);
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D7_Sum_of_Gradient_Differences_Memo( grad_of_G(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), grad_of_B(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 8
        % Memoization
        grad_of_G = gradient(imgG);
        grad_of_R = gradient(imgR);
        grad_of_B = gradient(imgB);
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D8_Sum_of_Gradient_Differences_V3( grad_of_G(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), grad_of_B(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
        for t = t_start_R : t_end_R
            for t2 = t2_start_R : t2_end_R
                tempDistance = D8_Sum_of_Gradient_Differences_V3( grad_of_R(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), grad_of_B(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_R
                    minDistance_R = tempDistance;
                    displacement_R_X = t;
                    displacement_R_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 9
        % Memoization
        [ grad_G, grad_G_y ] = gradient(imgG);
        [ grad_R, grad_R_y ] = gradient(imgR);
        [ grad_B, grad_B_y ] = gradient(imgB);
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D9_Sum_of_Gradient_Differences_V4( grad_G(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), grad_B(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth), grad_G_y(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), grad_B_y(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
        for t = t_start_R : t_end_R
            for t2 = t2_start_R : t2_end_R
                tempDistance = D9_Sum_of_Gradient_Differences_V4( grad_R(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), grad_B(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth), grad_R_y(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), grad_B_y(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_R
                    minDistance_R = tempDistance;
                    displacement_R_X = t;
                    displacement_R_Y = t2;
                end
            end
        end
    end
else
    % Searching Window Start Coordinate Defined
    displacement_G_X = x_gb;
    displacement_G_Y = y_gb;

    t_start_G = max( (x_gb), 0 - original_Threshold );
    t_end_G = min( (x_gb + threshold), 0 + original_Threshold );
    t2_start_G = max( (y_gb), 0 - original_Threshold );
    t2_end_G = min( (y_gb + threshold), 0 + original_Threshold );

    if distance_Measure_Selection == 1
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D1_Sum_of_Differences( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 2
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D2_Sum_of_Squared_Differences( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 3
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D3_Normalized_Cross_Correlation( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance > maxCorrelation_G
                    maxCorrelation_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
        D4_Sum_of_Gradient_Differences_Memo
    elseif distance_Measure_Selection == 4
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D4_Sum_of_Gradient_Differences( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 5
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D5_SSD_of_Gradient( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 6
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D6_NCC_of_Gradient( imgG(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), imgB(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance > maxCorrelation_G
                    maxCorrelation_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    elseif distance_Measure_Selection == 7
        % Memoization
        grad_G = gradient(imgG);
        grad_B = gradient(imgB);
        for t = t_start_G : t_end_G
            for t2 = t2_start_G : t2_end_G
                tempDistance = D7_Sum_of_Gradient_Differences_Memo( grad_G(upperleftX + t : upperleftX + windowHeight + t, upperleftY + t2 : upperleftY + windowWidth + t2), grad_B(upperleftX : upperleftX + windowHeight, upperleftY : upperleftY + windowWidth) );
                if tempDistance < minDistance_G
                    minDistance_G = tempDistance;
                    displacement_G_X = t;
                    displacement_G_Y = t2;
                end
            end
        end
    end   
end

displacement_G = [displacement_G_X, displacement_G_Y];
displacement_R = [displacement_R_X, displacement_R_Y];

end

