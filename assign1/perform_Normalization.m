function [ N_B ] = perform_Normalization( G, B )
%PERFORM_NORMALIZATION Summary of this function goes here
%   Detailed explanation goes here

B_Prime = B ./ (B + G + 0.00001);

N_B = B - B_Prime ;

% figure,imshow(B);
% figure,imshow(B_Prime);
% figure,imshow(N_B);

end

