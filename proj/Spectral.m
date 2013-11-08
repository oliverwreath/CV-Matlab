function [  ] = Spectral(  )
%SPECTRAL Summary of this function goes here
%   Detailed explanation goes here

% Parameters
k = 3;
theta = 0.5;

% input 
inputImage = imread('12003.jpg');
% inputImage = imread('317080.jpg');
% inputImage = im2double(inputImage);
% inputImage = impyramid(inputImage, 'reduce');
% inputImage = impyramid(inputImage, 'reduce');
% inputImage = impyramid(inputImage, 'reduce');
% inputImage = impyramid(inputImage, 'reduce');
inputImage = imresize(inputImage, 0.07);
% inputImage2 = rgb2gray(inputImage);

% Step 1 Projection to CIELAB
% colorTransform = makecform( 'srgb2lab' );
% inputImage3 = applycform( inputImage, colorTransform );
inputImage3 = im2double(inputImage);
% inputImage3 = inputImage;

% Test
% inputImage, inputImage2 grey, inputImage3 CIELAB.
% figure, imshow(inputImage);
% figure, imshow(inputImage2);
% figure, imshow(inputImage3(:, :, 1));
% figure, imshow(inputImage3(:, :, 2));
% figure, imshow(inputImage3(:, :, 3));
% figure, imshow(inputImage3);

% Similarity Matrix
[r, c, depth] = size(inputImage);
A = reshape( inputImage3(:, :, 1), 1, []  );
% A(2, :) = reshape( inputImage3(:, :, 2), 1, [] );
% A(3, :)  = reshape( inputImage3(:, :, 3), 1, [] );

A = A';
W = pdist2(A, A, 'euclidean');
W = W ./ theta ^ 2;
W = exp(W);
Dp = sum(W, 2) ;
D(size(Dp,1), size(Dp,1)) = 0;
for i = 1: size(Dp,1)
    D(i, i) = Dp(i);
end
A = D ^ (-1/2) * W * D ^ (-1/2);

% Get eigenvector - matrix D of A's six largest magnitude eigenvalues and a matrix V whose columns are the corresponding eigenvectors.
L = del2(A);
[V D] = eigs(L, 2, 'sr');
plot(V(:, 2), '.-');
figure, plot(sort(V(:, 2)), '.-');

[ignore p] = sort(V(:,2));
figure, spy(A(p,p));










end

