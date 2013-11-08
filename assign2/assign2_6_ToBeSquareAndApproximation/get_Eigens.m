function [ cx, cy, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber ] = get_Eigens( imgA, cx, cy, rad, ReNumber )
%GET_EIGENS Summary of this function goes here
%   Detailed explanation goes here

eigenTic = tic;
[gradX gradY] = gradient(imgA);
[m, n] = size(imgA);
nn = size(cx, 1);
eigD = zeros(nn, 3);
% RColumn = zeros(nn, 1);
MajorColumn = zeros(nn, 1);
MinorColumn = zeros(nn, 1);
angleColumn = zeros(nn, 1);

    A1 = gradX .* gradX;
    A2 = gradX .* gradY;
    A3 = gradY .* gradY;
    
% 	2MMA = [ Ix * Ix    Ix * Iy
%             Ix * Iy   Iy * Iy  ];
for i = 1 : nn
    if i > nn
        break;
    end
    x = cx(i, 1);
    y = cy(i, 1);
    r = rad(i, 1);
    r = round(r * 0.8);
    
    x1 = floor(x - r);
    x2 = ceil(x + r);
    y1 = floor(y - r);
    y2 = ceil(y + r);
    if x1 < 1 || x2 > m || y1 < 1 || y2 > n
        continue ;
    end
%     x1 = max(x1, 1);
%     x2 = min(x2, m);
%     y1 = max(y1, 1);
%     y2 = min(y2, n);
    
%     Ix = sum(sum(2MMA (x1:x2, y1:y2) ));
%     Iy = sum(sum(2MMA (x1:x2, y1:y2) ));
    
    M = [ sum(sum( A1(x1:x2, y1:y2) )) sum(sum( A2(x1:x2, y1:y2) )); sum(sum( A2(x1:x2, y1:y2) )) sum(sum( A3(x1:x2, y1:y2) )) ];
    
	D = eig(M);
    Eig1 = D(1,1);
    Eig2 = D(2,1);
    R = Eig1 * Eig2 - 0.15 * (Eig1 + Eig2) .^2;
%     R = det(M) - 0.1 * trace(M) .^ 2;
%         k = 0.0001;
%         if R < 0 || (eigD(ii, 1) ) < k || (eigD(ii, 2) ) < k
%             line( x, y, 'Color', color, 'LineWidth', 1);
%             rad(ii, 1) = 0.5;
%             diffNumberR = diffNumberR + 1;
%             continue;
%         end

	if R < 0 %|| Eig1 < k || Eig2 < k
        cx(i) = [];
        cy(i) = [];
        rad(i) = [];
        MajorColumn(i) = [];
        MinorColumn(i) = [];
        angleColumn(i) = [];
        nn = nn - 1;
        ReNumber = ReNumber + 1;
        continue ;
	end
%     RColumn(i, 1) = R;
    eigD(i, :) = [ D(1,1) D(2,1) D(1,1)+D(2,1) ];
    gradXSum = sum(sum( gradX(x1:x2, y1:y2) ));
    gradYSum = sum(sum( gradY(x1:x2, y1:y2) ));
    tanGent = -gradXSum / gradYSum;
    theta = atan(tanGent);
%     if gradYSum < 0 
%         theta = theta + pi;
%     end
    theta = theta * 360 / 2 / pi + pi / 2;
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

end

clear M
% clear eigD
% clear RColumn
toc(eigenTic);

end

