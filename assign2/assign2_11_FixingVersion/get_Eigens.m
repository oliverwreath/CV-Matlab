function [ cx, cy, rad, MajorColumn, MinorColumn, angleColumn, ReNumber, alpha ] = get_Eigens( imgA, cx, cy, rad, ReNumber )
%GET_EIGENS Summary of this function goes here
%   Detailed explanation goes here

eigenTic = tic;

[m, n] = size(imgA);
nn = size(cx, 1);
% RColumn = zeros(nn, 1);
MajorColumn = zeros(nn, 1);
MinorColumn = zeros(nn, 1);
angleColumn = zeros(nn, 1);

tempTimes = 0;
tempRad = 0;

alpha = 0.1
i = 1;
while i <= size(cx, 1)
    x = cx(i, 1);
    y = cy(i, 1);
    r = rad(i, 1);
    if tempRad < r
        tempRad = r;
        tempTimes = tempTimes + 1;
        offset = round(r * 0.9);  %0.8862
        % Gaussian Window
        hsize = max( round(1.5 * r), 1);
        hsize = hsize + 1 - mod(hsize, 2);
        g = fspecial('gaussian', hsize, hsize/6);
        [Ix Iy] = gradient(imgA);
        Ix2 = conv2(Ix .^ 2, g, 'same');
        Ixy = conv2(Ix .* Iy, g, 'same');
        Iy2 = conv2(Iy .^ 2, g, 'same');
%         h = h( hsize + 1 - floor(hsize/2) : hsize + 1 + floor(hsize/2) , hsize + 1 - floor(hsize/2) : hsize + 1 + floor(hsize/2) );
    end

    x1 = floor(x - offset);
    x2 = ceil(x + offset);
    y1 = floor(y - offset);
    y2 = ceil(y + offset);
    if x1 < 1 || x2 > m || y1 < 1 || y2 > n
        cx(i) = [];
        cy(i) = [];
        rad(i) = [];
        MajorColumn(i) = [];
        MinorColumn(i) = [];
        angleColumn(i) = [];
        ReNumber = ReNumber + 1;
        continue ;
    end

    M = [ Ix2(x, y) Ixy(x, y); Ixy(x, y) Iy2(x, y) ];

	[V, D] = eig(M);
    Eig1 = D(1,1);
    Eig2 = D(2,2);
    R = det(M) - alpha * trace(M)^2;

	if R < 0
        cx(i) = [];
        cy(i) = [];
        rad(i) = [];
        MajorColumn(i) = [];
        MinorColumn(i) = [];
        angleColumn(i) = [];
        ReNumber = ReNumber + 1;
        continue ;
	end
    
%     eigD(i, :) = [ D(1,1) D(2,2) D(1,1)+D(2,2) ];

    if Eig1 == 0
        MajorColumn(i) = rad(i);
        MinorColumn(i) = rad(i);
        angleColumn(i) = 0;
        i = i + 1;
        continue ;
    elseif Eig1 < Eig2
        IxSum = V(1,1);
        IySum = V(2,1);
    else
        IxSum = V(1,2);
        IySum = V(2,2);
    end
    if IxSum == 0
        if IySum == 0
            theta = 0;
        elseif IySum > 0
            theta = pi / 2;
        elseif IySum < 0
            theta = - pi / 2;
        end
    elseif IySum == 0
        if IxSum > 0
            theta = 0 ;
        elseif IxSum < 0
            theta = pi;
        end
    else
        tanGent = abs(IySum) / abs(IxSum) ;
        theta = atan(tanGent);
        % theta calibration
%         if (IxSum < 0 && IySum > 0) || (IxSum > 0 && IySum < 0)
%             theta = pi - theta;
%         end
        if IxSum < 0 && IySum < 0
            theta = pi - theta;
        end 
    end

    theta = theta * 360 / 2 / pi;
    theta = mod((theta + 360), 360);
    angleColumn(i, 1) = theta;
    Major = 1 / (Eig1 .^ (1/2));
    Minor = 1 / (Eig2 .^ (1/2));
    if Major < Minor
        temp = Major ;
        Major = Minor ;
        Minor = temp;
    end
    ratio = 1.7 * r / (Major + Minor) ;
    MajorColumn(i, 1) = Major * ratio;
    MinorColumn(i, 1) = Minor * ratio;

    i = i + 1;
end

clear M
clear Ix2
clear Ixy
clear Iy2
toc(eigenTic);

end

