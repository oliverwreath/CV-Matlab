function [ cx, cy, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber ] = get_Eigens( imgA, cx, cy, rad, ReNumber )
%GET_EIGENS Summary of this function goes here
%   Detailed explanation goes here

eigenTic = tic;

[m, n] = size(imgA);
nn = size(cx, 1);
eigD = zeros(nn, 3);
% RColumn = zeros(nn, 1);
MajorColumn = zeros(nn, 1);
MinorColumn = zeros(nn, 1);
angleColumn = zeros(nn, 1);

[gradX gradY] = gradient(imgA);
A1 = gradX .* gradX;
A2 = gradX .* gradY;
A3 = gradY .* gradY;

tempTimes = 0;
tempRad = 0;

alpha = 0.07
i = 1;
while i <= size(cx, 1)
    x = cx(i, 1);
    y = cy(i, 1);
    r = rad(i, 1);
    if tempRad < r
        tempRad = r;
        tempTimes = tempTimes + 1;
        offset = round(r * 1.5);  %0.8862
        % Gaussian Window
        hsize = 2 * offset + 1;
        h = fspecial('gaussian', 2 * hsize + 1, hsize/6);
        h = h( hsize + 1 - floor(hsize/2) : hsize + 1 + floor(hsize/2) , hsize + 1 - floor(hsize/2) : hsize + 1 + floor(hsize/2) );
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
        eigD(i, :) = [];
        ReNumber = ReNumber + 1;
        continue ;
    end

    M = [ sum(sum( A1(x1:x2, y1:y2) .* h )) sum(sum( A2(x1:x2, y1:y2) .* h )); sum(sum( A2(x1:x2, y1:y2) .* h )) sum(sum( A3(x1:x2, y1:y2) .* h )) ];
    
	[V, D] = eig(M);
    Eig1 = D(1,1);
    Eig2 = D(2,2);
    R = Eig1 * Eig2 - alpha * (Eig1 + Eig2) .^2;

	if R < 0 %|| Eig1 < k || Eig2 < k
        cx(i) = [];
        cy(i) = [];
        rad(i) = [];
        MajorColumn(i) = [];
        MinorColumn(i) = [];
        angleColumn(i) = [];
        eigD(i, :) = [];
        ReNumber = ReNumber + 1;
        continue ;
	end
    
%     RColumn(i, 1) = R;
    eigD(i, :) = [ D(1,1) D(2,2) D(1,1)+D(2,2) ];

    if Eig1 == 0
        MajorColumn(i) = rad(i);
        MinorColumn(i) = rad(i);
        angleColumn(i) = 0;
        i = i + 1;
        continue ;
    elseif Eig1 < Eig2
        gradXSum = V(1,1);
        gradYSum = V(2,1);
    else
        gradXSum = V(1,2);
        gradYSum = V(2,2);
    end
    if gradXSum == 0
        if gradYSum == 0
            theta = 0;
        elseif gradYSum > 0
            theta = pi / 2;
        elseif gradYSum < 0
            theta = - pi / 2;
        end
    elseif gradYSum == 0
        if gradXSum > 0
            theta = 0 ;
        elseif gradXSum < 0
            theta = pi;
        end
    else
        tanGent = abs(gradYSum) / abs(gradXSum) ;
        theta = atan(tanGent);
        % theta calibration
%         if (gradXSum < 0 && gradYSum > 0) || (gradXSum > 0 && gradYSum < 0)
%             theta = pi - theta;
%         end
        if gradXSum < 0 && gradYSum < 0
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
    ratio = 2 * r / (Major + Minor) ;
    MajorColumn(i, 1) = Major * ratio;
    MinorColumn(i, 1) = Minor * ratio;

    i = i + 1;
end

clear M
% clear eigD
clear RColumn
toc(eigenTic);

end

