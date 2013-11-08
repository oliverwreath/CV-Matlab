function [ Fret, residual_avg ] = fit_fundamental( matches )
%FIT_FUNDAMENTAL Summary of this function goes here
%   Detailed explanation goes here

RANSACrounds = 40000;
normalized = 1
Memoization = 0;
% The normalized eight-point algorithm
if normalized == 1
    mean_of_matches = mean(matches);
    std_of_matches = std(matches);
    
    std_of_matches = std_of_matches ./ 2;
    
    for i = 1: 4
        matches(:,i) = ( matches(:,i) - mean_of_matches(i) );
    end
    for i = 1: 4
        matches(:,i) = matches(:,i) ./ std_of_matches(i);
    end
end

% simplize problem
numOfFeatures = 40;
matches = matches( 1:numOfFeatures, : );
% get F
numOfFeatures = size(matches, 1)
inlier_number = 0;
residual_avg = realmax('double');
if Memoization == 1
    flagMatrix = false(numOfFeatures, numOfFeatures, numOfFeatures, numOfFeatures, numOfFeatures, numOfFeatures, numOfFeatures, numOfFeatures);
end
counter = 1 ;
RANSACrounds = min( RANSACrounds, factorial(numOfFeatures) / factorial(8) / factorial(numOfFeatures - 8) )

while 1 == 1
    x = randsample( numOfFeatures, 8 );
    x = sort(x);
    j1 = x(1);
    j2 = x(2);
    j3 = x(3);
    j4 = x(4);
    j5 = x(5);
    j6 = x(6);
    j7 = x(7);
    j8 = x(8);
    if Memoization == 1
        if counter > RANSACrounds
            break;
        elseif flagMatrix( j1, j2, j3, j4, j5, j6, j7, j8 ) == true
            continue;
        else
            flagMatrix( j1, j2, j3, j4, j5, j6, j7, j8 ) = true;
            counter = counter + 1;
        end
    else
        if counter > RANSACrounds
            break;
        else
            counter = counter + 1;
        end
    end
    
    candidateIndex = [j1 j2 j3 j4 j5 j6 j7 j8 ];
    index =@ (x, y) x(y);
    u = index( matches(:,1), candidateIndex );
    v = index( matches(:,2), candidateIndex );
    up = index( matches(:,3), candidateIndex );
    vp = index( matches(:,4), candidateIndex );
%     x = [u v 1]';
%     xp = [up vp 1];

    A = [ up .* u up .* v up vp .* u vp .* v vp u v ones(8,1) ];
    [ ~,~,V ] = svd(A);
    F = V(:, end);
    F = reshape( F, 3, 3 )';

    % enforce the rank-2 constraint: SVD of F, setting the smallest singular value to zero, and recomputing F.
    [ U,S,V ] = svd(F);
    S(:,end) = S(:,end) .* 0;
    F = U*S*V';
    
%     n2 = pdist2( matches(:,1:2), matches(:,3:4), 'euclidean' );
%     n2 = dist2( matches(:,1:2), matches(:,3:4) );
%     n2 = diag(n2);
    Xp = ones(numOfFeatures, 3);
    X = ones(numOfFeatures, 3);
    Xp(:, 1:2) = [ matches(:,3) matches(:,4) ];
    X(:, 1:2) = [ matches(:,1) matches(:,2) ];
    X = X';
    n2 = diag( Xp * F * X );
    n2 = n2 .^ 2;
    temp_residual_avg = sum( n2 ) / size( n2, 1 );
    if temp_residual_avg < residual_avg
        residual_avg = temp_residual_avg;
        Fret = F;
    end
end

if normalized == 1
    T = [   1 / std_of_matches(1),      0,  - mean_of_matches(1) / std_of_matches(1); ...
            0,      1 / std_of_matches(2),  - mean_of_matches(2) / std_of_matches(2); ...
            0,      0,      1 ...
        ];
    Tp = [  1 / std_of_matches(3),      0,  - mean_of_matches(3) / std_of_matches(3); ...
            0,      1 / std_of_matches(4),  - mean_of_matches(4) / std_of_matches(4); ...
            0,      0,      1 ...
        ];
    Fret = Tp' * Fret * T;
end


end

