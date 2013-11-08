
% Parameters
maxdist = 20;
ratio = 0.5; %% larger values give more importance to color
kernelsize = 2;

% Input


% I = imread('66075.jpg');
% I = imread('198004.jpg');
% I = imread('317080.jpg');
I = imread('12003.jpg');
I = im2double(I);
I = impyramid(I, 'reduce');
I = impyramid(I, 'reduce');
I = impyramid(I, 'reduce');


Iseg = vl_quickseg(I, ratio, kernelsize, maxdist);
[row, col, depth] = size(I);

I( :, col+1: 2 * col, :) = Iseg;


% Output
imshow(I), hold on,
title('Mean Shift'),
hold off;

% maxdist = 50;
% ndists = 10;
% Iedge = vl_quickvis(I, ratio, kernelsize, maxdist, ndists);
% imagesc(Iedge);
% axis equal off tight;
% colormap gray;