function [  ] = main( inputPath, outputPath )
%MAIN Summary of this function goes here
%   Detailed explanation goes here

%% Decreases Image Size
ScaleFactor = 2 ;
scale = 1 ;

imname = inputPath;
suffix = inputPath(:,size(inputPath,2) - 3 : size(inputPath,2));
inputPath = inputPath(:,1:size(inputPath,2) - 4);

imgA = imread(imname);
imgRet = rgb2gray(imgA);
imgRet = im2double(imgRet);
imgA = imgRet;

mainTic = tic ;
%%
[ h, r ] = LoG_Filter_Normalized ;

%% Recursive Blobing
k = 1 ;
sqrt_Size = sqrt(size(imgA, 1) * size(imgA, 2));
[ cx, cy, rad, k, imgB ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor, k );


%% Drawing Results
if k > 1 
    show_all_circles(imgRet, cy, cx, rad);
end

%%
[inputPath '-result' suffix]
imwrite( show_Results( imgA, imgB, imgRet ), [inputPath '-result' suffix] )

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

