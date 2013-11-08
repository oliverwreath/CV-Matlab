function [  ] = main( inputPath, outputPath )
%MAIN Summary of this function goes here
%   Detailed explanation goes here

%% Decreases Image Size
ScaleFactor = 1.2
scale = 1 ;
ReNumber = 0;

imname = inputPath;
suffix = inputPath(:,size(inputPath,2) - 3 : size(inputPath,2));
inputPath = inputPath(:,1:size(inputPath,2) - 4);

imgA = imread(imname);
imgA_Copy = imgA;
imgA = rgb2gray(imgA);
imgA = im2double(imgA);

mainTic = tic ;
%%
[ h, r ] = LoG_Filter_Normalized ;

%% Multi-scale Blobing
sqrt_Size = sqrt(size(imgA, 1) * size(imgA, 2));
[ cx, cy, rad, ReNumber ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor, ReNumber );

%% Drawing Circular Results
% for ii = 1 : 3
%     imgA_Copy(:, :, ii) = imadjust(imgA_Copy(:, :, ii));
% end
% if exist('cx', 'var') 
%     show_all_circles(imgA_Copy, cy, cx, rad);
% end

%% Eigenvalues

[ cx, cy, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber ] = get_Eigens( imgA, cx, cy, rad, ReNumber );

%% Result Eclipses Coloumn Array Generating
% for ii = 1 : 3
%     imgA_Copy(:, :, ii) = imadjust(imgA_Copy(:, :, ii));
% end
	show_all_ellipses(imgA_Copy, cy, cx, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber);
%%
% [inputPath '-result' suffix]
% imwrite( show_Results( im2double(imgA_Copy), cat(3,imgB,imgB,imgB), cat(3,imgA,imgA,imgA) ), [inputPath '-result' suffix] )

toc(mainTic);

% %% Increases Filter Size
% ScaleFactor = 2 ;
% scale = 1 ;
% 
% imname = inputPath;
% suffix = inputPath(:,size(inputPath,2) - 3 : size(inputPath,2));
% inputPath = inputPath(:,1:size(inputPath,2) - 4);
% 
% imgA = imread(imname);
% imgRet = rgb2gray(imgA);
% imgRet = im2double(imgRet);
% imgA = imgRet;
% 
% mainTic = tic ;
% %% Recursive Blobing With Filter Scale
% [ h, r ] = LoG_Filter_Normalized_Scale( ) ;
% 
% k = 1 ;
% sqrt_Size = sqrt(size(imgA, 1) * size(imgA, 2));
% [ cx, cy, rad, k, imgB ] = Blobing_FilterScale( imgA, sqrt_Size, h, r, scale, ScaleFactor, k );
% 
% pointS(:,1) = cx;
% pointS(:,2) = cy;
% pointS(:,3) = rad;
% 
% %% Drawing Results
% if k > 1 
%     show_all_circles(imgRet, cy, cx, rad);
% end
% 
% %%
% [inputPath '-result' suffix]
% imwrite( show_Results( imgA, imgB, imgRet ), [inputPath '-result' suffix] )
% 
% toc(mainTic);

end

