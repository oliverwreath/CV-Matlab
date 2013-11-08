function [  ] = main( inputPath, outputPath )
%MAIN Summary of this function goes here
%   Detailed explanation goes here
flag = 0
if flag == 1
    %% Decreases Image Size
    ScaleFactor = 1.2
    scale = 1 ;
    ReNumber = 0;

    imname = inputPath;
    % suffix = inputPath(:,size(inputPath,2) - 3 : size(inputPath,2));
    % inputPath = inputPath(:,1:size(inputPath,2) - 4);

    imgA = imread(imname);
    imgA_Copy = imgA;
    imgA = rgb2gray(imgA);
    imgA = im2double(imgA);

    mainTic = tic ;
    %%
    [ h, r ] = LoG_Filter ;

    %% Multi-scale Blobing
    sqrt_Size = sqrt(size(imgA, 1) * size(imgA, 2));
    [ cx, cy, rad, ReNumber ] = Blobing( imgA, sqrt_Size, h, r, scale, ScaleFactor, ReNumber );

    %% Eigenvalues
    [ cx, cy, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber ] = get_Eigens( imgA, cx, cy, rad, ReNumber );

    %% Result Eclipses Coloumn Array Generating
    show_all_ellipses(imgA_Copy, cy, cx, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber);
    %%
    % [inputPath '-result' suffix]
    % imwrite( show_Results( im2double(imgA_Copy), cat(3,imgB,imgB,imgB), cat(3,imgA,imgA,imgA) ), [inputPath '-result' suffix] )
    toc(mainTic);
else

    %% Increases Filter Size
    ScaleFactor = 1.2
    scale = 1 ;
    ReNumber = 0;

    imname = inputPath;
    % suffix = inputPath(:,size(inputPath,2) - 3 : size(inputPath,2));
    % inputPath = inputPath(:,1:size(inputPath,2) - 4);

    imgA = imread(imname);
    imgA_Copy = imgA;
    imgA = rgb2gray(imgA);
    imgA = im2double(imgA);

    mainTic = tic ;
    %% 
    [ h, r ] = LoG_Filter_Normalized_Scale( 1 ) ;

    %% Multi-scale Blobing
    sqrt_Size = sqrt(size(imgA, 1) * size(imgA, 2));
    [ cx, cy, rad, ReNumber ] = Blobing_FilterScale( imgA, sqrt_Size, h, r, scale, ScaleFactor, ReNumber );

    %% Eigenvalues
    [ cx, cy, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber ] = get_Eigens( imgA, cx, cy, rad, ReNumber );

    %% Result Eclipses Coloumn Array Generating
    show_all_ellipses(imgA_Copy, cy, cx, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber);
    %%
    % [inputPath '-result' suffix]
    % imwrite( show_Results( im2double(imgA_Copy), cat(3,imgB,imgB,imgB), cat(3,imgA,imgA,imgA) ), [inputPath '-result' suffix] )

    toc(mainTic);
end

end

