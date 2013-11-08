function [ imgB ] = Harris_Edge_Remover( imgB, imgA_Copy, scale, Original_size )
%% Harries Edge Remover

    dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
    dy = dx';
    
    Ix = conv2(imgA_Copy, dx, 'same');    % Image derivatives
    Iy = conv2(imgA_Copy, dy, 'same');    

    % Generate Gaussian filter of size 6*sigma (+/- 3sigma) and of
    % minimum size 1x1.
    sigma = 1;
    sigma = sigma * scale;
    g = fspecial('gaussian', max(1,fix(6*sigma)), sigma);
    
    Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g, 'same');
    k = 0.04;
    cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2; 
    cim = imresize(cim, Original_size );
	cim = (cim<0);       % Find maxima.
	
	[ r, c ] = find(cim);                  % Find row,col coords.
    

    for kk = 1 : size(r, 1)
        imgB(r(kk, 1), c(kk, 1)) = 0;
    end

end
