function [ ] = colorizing( imname, directoryPath, outputDirectory, distance_Measure_Selection )
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

% name of the input file
imname = imname

% parameters to adjust
[ thresholdScale, sum_up_Window, search_Window, search_Window_x1_x4, search_Window_y1_y2, pyramid_DrillDown_Threshold, search_Window_For_Cropping, search_Window_For_Cropping2, scale_of_average, mode_Decision ] = get_Parameters(  );

% read in the image
img_negative_from_input = imread([directoryPath imname]);

% convert to double matrix (might want to do this later on to same memory)
img_negative_from_input = im2double(img_negative_from_input);

% suffix = imname(:, size(imname,2)-3 : size(imname,2));

imname = imname(:, 1:size(imname,2) - 4 );

suffix = '.jpg';

%% WITHOUT PreProcessing - Compute the height of each part (just 1/3 of total)
 
%  height = floor(size(img_negative_from_input,1)/3);
%  B = img_negative_from_input(1:height,:);
%  G = img_negative_from_input(height+1:height*2,:);
%  R = img_negative_from_input(height*2+1:height*3,:);

%  blank_Matrix = R .* 0;
%  rgb_Image_Temp = cat(3, R, blank_Matrix, blank_Matrix);
%  imwrite( rgb_Image_Temp, [ outputDirectory 'result_1_Before_Pre_R-D' num2str(distance_Measure_Selection) '-' imname suffix ] );
%   
%  rgb_Image_Temp = cat(3, blank_Matrix, G, blank_Matrix);
%  imwrite( rgb_Image_Temp, [ outputDirectory 'result_1_Before_Pre_G-D' num2str(distance_Measure_Selection) '-' imname suffix ] );
%   
%  rgb_Image_Temp = cat(3, blank_Matrix, blank_Matrix, B);
%  imwrite( rgb_Image_Temp, [ outputDirectory 'result_1_Before_Pre_B-D' num2str(distance_Measure_Selection) '-' imname suffix ] );
%  

%% PreProcessing 
[ B, G, R, x1, x2, x3, x4, y1, y2, x11, x22, x33, x44, y11, y22, slide_y1, slide_y2, slide_x1, slide_x4 ] = preProcessing( img_negative_from_input, sum_up_Window, search_Window, search_Window_x1_x4, search_Window_y1_y2 );

% x1, x2, x3, x4, y1, y2
 B1 = img_negative_from_input .* 0 + 1;
 B1 = img_negative_from_input .* 2;
 G1 = B1;
 R1 = G1;
 B1(x11:x44, y11:y22) = 0;
 G1(x11:x44, y11:y22) = 0;
 R1(x11:x44, y11:y22) = 0;
 B1(x11:x22, y11:y22) = img_negative_from_input(x11:x22, y11:y22);
 G1(x22+1:x33, y11:y22) = img_negative_from_input(x22+1:x33, y11:y22);
 R1(x33+1:x44, y11:y22) = img_negative_from_input(x33+1:x44, y11:y22);

 R1(:,y1,:) = 1;
 R1(:,y2,:) = 1;
 R1(x1,:,:) = 1;
 R1(x4,:,:) = 1;
 R1(x2,:,:) = 1;
 R1(x3,:,:) = 1;
 rgb_Image_Temp = cat(3, R1, G1, B1);
 imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_2_After_Pre_RGB-D' num2str(distance_Measure_Selection) '-' num2str(slide_y1) '_' num2str(slide_y2) '_' num2str(slide_x1) '_' num2str(slide_x4) suffix ] );

 B = img_negative_from_input(x11:x22, y11:y22);
 G = img_negative_from_input(x22+1:x33, y11:y22);
 R = img_negative_from_input(x33+1:x44, y11:y22);

 % separate color channels
[ G, R, B ] = resize( G, R, B );
[ R, G, B ] = boarder_Effect_Cropping2( R, G, B, sum_up_Window, search_Window_For_Cropping, 1/4, 25 / 100 );
[ G, R, B ] = resize( G, R, B );

scale_times = sqrt(size(B,1) * size(B,2))/ sqrt(350 * 290);
% 
% %  B = impyramid( B, 'reduce' );
% %  B = impyramid( B, 'reduce' );
% %  G = impyramid( G, 'reduce' );
% %  G = impyramid( G, 'reduce' );
% %  R = impyramid( R, 'reduce' );
% %  R = impyramid( R, 'reduce' );
%  
%  % figure, bar3(B), view(-30,50);
%  % figure, mesh(B), view(150,50);
%  % figure, ribbon(B), view(150,60);
%   
% %  figure, surfc(B), view(150,60);title('Blue Channel');
% %  figure, surfc(G), view(150,60);title('Green Channel');
% %  figure, surfc(R), view(150,60);title('Red Channel');
%  
% % % normalization
% % B = B - min(B(:)); 
% % G = G - min(G(:)); 
% % R = R - min(R(:)); 
% % B = B / (max(B(:)));
% % G = G / (max(G(:)));
% % R = R / (max(R(:)));
%  
% %  [X, Y] = gradient(B);
% %  figure, quiver( X, Y ), view(140,110);title('Blue Channel');
% %  hold on
% %  contour(B);
% %  colormap hsv
% %  axis ([-3 26 -3 25 -1 1])
% %  hold off
% %   
% %   [X, Y] = gradient(G);
% %  figure, quiver( X, Y ), view(140,110);title('Green Channel');
% %  hold on
% %  contour(G);
% %  colormap hsv
% %  axis ([-3 26 -3 25 -1 1])
% %  hold off
% %  
% %   [X, Y] = gradient(R);
% %  figure, quiver( X, Y ), view(140,110);title('Red Channel');
% %  hold on
% %  contour(R);
% %  colormap hsv
% %  axis ([-3 26 -3 25 -1 1])
% %  hold off
% %  [X, Y] = gradient(B);
% %  [U,V,W] = surfnorm(X,Y,B);
% %  figure, quiver3(B,U,V,W), view(130,50);title('Blue Channel');
% %     hold on
% %     surfc(B);
% %     colormap hsv
% %     axis ([0 25 -5 25 -1 2])
% %     hold off
% %  
% %  [X, Y] = gradient(G);
% %  [U,V,W] = surfnorm(X,Y,G);
% %  figure, quiver3(G,U,V,W), view(130,50);title('Green Channel');
% %      hold on
% %     surfc(G);
% %     colormap hsv
% %     axis ([0 25 -5 25 -1 2])
% %     hold off
% %  
% %  [X, Y] = gradient(R);
% %  [U,V,W] = surfnorm(X,Y,R);
% %  figure, quiver3(R,U,V,W), view(130,50);title('Red Channel');
% %     hold on
% %     surfc(R);
% %     colormap hsv
% %     axis ([0 25 -5 25 -1 2])
% %     hold off
% 
% %  hold on 
% %  surfc(X, Y, B), view(150,60);
% %  hold off
%  
% %  figure
% %     [X,Y] = meshgrid(-2:0.25:2,-1:0.2:1);
% %     Z = X.* exp(-X.^2 - Y.^2);
% %     [U,V,W] = surfnorm(X,Y,Z);
% %     quiver3(X,Y,Z,U,V,W,0.5);
% %     hold on
% %     surf(X,Y,Z);
% %     colormap hsv
% %     view(-35,45)
% %     axis ([-2 2 -1 1 -.6 .6])
% %     hold off
%  
% %  blank_Matrix = R .* 0;
% %  rgb_Image_Temp = cat(3, R, blank_Matrix, blank_Matrix);
% %  imwrite( rgb_Image_Temp, [ outputDirectory 'result_2_After_Pre_R-D' num2str(distance_Measure_Selection) '-' imname suffix ] );
% %  
% %  blank_Matrix = G .* 0;
% %  rgb_Image_Temp = cat(3, blank_Matrix, G, blank_Matrix);
% %  imwrite( rgb_Image_Temp, [ outputDirectory 'result_2_After_Pre_G-D' num2str(distance_Measure_Selection) '-' imname suffix ] );
% %   
% %  blank_Matrix = B .* 0;
% %  rgb_Image_Temp = cat(3, blank_Matrix, blank_Matrix, B);
% %  imwrite( rgb_Image_Temp, [ outputDirectory 'result_2_After_Pre_B-D' num2str(distance_Measure_Selection) '-' imname suffix ] );
% 
% %  
% %  % analyzing with graphs
% %  
% % 
% % % Statistical Bars
% % % figure, bar( sum(R) );
% % % figure, bar( sum(G) );
% % % figure, bar( sum(B) );
% % % 
% % % figure, bar( sum(R') );
% % % figure, bar( sum(G') );
% % % figure, bar( sum(B') );

%% Gaussian Filtering

% H = fspecial('gaussian', [3, 3], 0.3);
% % H = fspecial('log', 5, 1);
% R = imfilter(R, H, 'circular');
% G = imfilter(G, H, 'circular');
% B = imfilter(B, H, 'circular');

 blank_Matrix = R .* 0;
 rgb_Image_Temp = cat(3, R, blank_Matrix, blank_Matrix);
 imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_3_GaussianF_R-D' num2str(distance_Measure_Selection) suffix ] );
 
 blank_Matrix = G .* 0;
 rgb_Image_Temp = cat(3, blank_Matrix, G, blank_Matrix);
 imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_3_GaussianF_G-D' num2str(distance_Measure_Selection) suffix ] );
  
 blank_Matrix = B .* 0;
 rgb_Image_Temp = cat(3, blank_Matrix, blank_Matrix, B);
 imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_3_GaussianF_B-D' num2str(distance_Measure_Selection) suffix ] );


%% Displacement Calculation
mode_Decision = 0 ;
if mode_Decision == -1  % Fastest Mode
    distance_Measure_Selection = 4;
    [ displacementX_Y_G ] = get_Displacement_V5_Pair( G, B, [0, 0], thresholdScale, distance_Measure_Selection, 100 )  
    [ displacementX_Y_R ] = get_Displacement_V5_Pair( R, B, [0, 0], thresholdScale, distance_Measure_Selection, 100 )
    x_gb = displacementX_Y_G(1, 1);
    y_gb = displacementX_Y_G(1, 2);
    x_rb = displacementX_Y_R(1, 1);
    y_rb = displacementX_Y_R(1, 2);
    % displacementX_Y_G = displacementX_Y_G
    % displacementX_Y_R = displacementX_Y_R

    [ G ] = perform_Displacement( G, B, x_gb, y_gb );
    [ R ] = perform_Displacement( R, B, x_rb, y_rb );

    % Cropping Step One - result_4_Cropping_Boarder_Effect
    [ R, G, B ] = boarder_Effect_Cropping( R, G, B, x_gb, y_gb, x_rb, y_rb );
    % % result_3_Displacement

     rgb_Image_Temp = cat(3, R, G, B);
     imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_4_Displacement-D' num2str(distance_Measure_Selection) '_' num2str(x_gb) '_' num2str(y_gb) '_' num2str(x_rb) '_' num2str(y_rb) suffix ] );
elseif mode_Decision == 0    % Optimized Normal
    a = 'mode_Optimized Normal'
    scale_times
    distance_Measure_Selection = 9;
    %[ displacementX_Y_G ] = get_displacement( G, B, [x_gb, y_gb], thresholdScale, distance_Measure_Selection, pyramid_DrillDown_Threshold );
    %[ displacementX_Y_R ] = get_displacement( R, B, [x_rb, y_rb], thresholdScale, distance_Measure_Selection, pyramid_DrillDown_Threshold );
    [ displacementX_Y_G, displacementX_Y_R ] = get_Displacement_V4( G, R, B, [0, 0], [0, 0], scale_times, thresholdScale, distance_Measure_Selection, 250 )
    % displacementX_Y_G = displacementX_Y_G
    % displacementX_Y_R = displacementX_Y_R
    x_gb = displacementX_Y_G(1, 1);
    y_gb = displacementX_Y_G(1, 2);
    x_rb = displacementX_Y_R(1, 1);
    y_rb = displacementX_Y_R(1, 2);

    [ G ] = perform_Displacement( G, B, x_gb, y_gb );
    [ R ] = perform_Displacement( R, B, x_rb, y_rb );

    % Cropping Step One - result_4_Cropping_Boarder_Effect
    [ R, G, B ] = boarder_Effect_Cropping( R, G, B, x_gb, y_gb, x_rb, y_rb );
    % % result_3_Displacement

     rgb_Image_Temp = cat(3, R, G, B);
     imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_4_Displacement-D' num2str(distance_Measure_Selection) '_' num2str(x_gb) '_' num2str(y_gb) '_' num2str(x_rb) '_' num2str(y_rb) suffix ] );
else    % Best Quality 
    distance_Measure_Selection = 9;
    %[ displacementX_Y_G ] = get_displacement( G, B, [x_gb, y_gb], thresholdScale, distance_Measure_Selection, pyramid_DrillDown_Threshold );
    %[ displacementX_Y_R ] = get_displacement( R, B, [x_rb, y_rb], thresholdScale, distance_Measure_Selection, pyramid_DrillDown_Threshold );
    [ displacementX_Y_G ] = get_Displacement_V5_Pair( G, B, [0, 0], thresholdScale, distance_Measure_Selection, pyramid_DrillDown_Threshold )
    x_gb = displacementX_Y_G(1, 1);
    y_gb = displacementX_Y_G(1, 2);
    [ G ] = perform_Displacement( G, B, x_gb, y_gb );
    [ R, G, B ] = boarder_Effect_Cropping( R, G, B, x_gb, y_gb, 0, 0 );
    [ N_B ] = perform_Normalization( G, B );

    [ displacementX_Y_R ] = get_Displacement_V5_Pair( R, N_B, [0, 0], thresholdScale, distance_Measure_Selection, pyramid_DrillDown_Threshold )
    % displacementX_Y_G = displacementX_Y_G
    % displacementX_Y_R = displacementX_Y_R
    x_rb = displacementX_Y_R(1, 1);
    y_rb = displacementX_Y_R(1, 2);

    [ R ] = perform_Displacement( R, B, x_rb, y_rb );

    % Cropping Step One - result_4_Cropping_Boarder_Effect
    [ R, G, B ] = boarder_Effect_Cropping( R, G, B, 0, 0, x_rb, y_rb );
    % % result_3_Displacement

     rgb_Image_Temp = cat(3, R, G, B);
     imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_4_Displacement-D' num2str(distance_Measure_Selection) '_' num2str(x_gb) '_' num2str(y_gb) '_' num2str(x_rb) '_' num2str(y_rb) suffix ] );
end

    

%% Cropping Step Two - result_4_Cropping_Boarder_Effect_2 boarder_Effect_Cropping3

 [ R, G, B ] = boarder_Effect_Cropping3( R, G, B, sum_up_Window, search_Window_For_Cropping2, 0.04138, 24 / 100 );

 rgb_Image_Temp = cat(3, R, G, B);
 imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_5_Cropping_Boarder_Effect_2-D' num2str(distance_Measure_Selection) '_'  suffix ] );
% figure, imshow(rgb_Image_Temp_5 );

%% result_6_Enhencement

 rgb_Image_Temp = cat(3, imadjust(R), imadjust(G), imadjust(B));
 imwrite( rgb_Image_Temp, [ outputDirectory imname '_result_6_Enhenced-D' num2str(distance_Measure_Selection) '_' num2str(x_gb) '_' num2str(y_gb) '_' num2str(x_rb) '_' num2str(y_rb) suffix  ] );
% figure, imshow(rgb_Image_Temp );

end

