function [ imgA ] = show_Results( imgA, imgB, imgRet )
%DISPLAY Summary of this function goes here
%   Detailed explanation goes here

m = size(imgA,1);
n = size(imgA,2);

imgA(:, n+1: 2 * n , :) = imgRet;
% imgA(m+1:2* m, 1: n, :) = img_C;
% 
imgA(m+1:2* m, 1: 1 * n , :) = imgB;
% imgA(m+1:2* m, n+1: 2 * n , 1) = imgB;
% figure, imshow(imgA);

end

