function [  ] = main(  )
%MIAN Summary of this function goes here
%   Detailed explanation goes here

%% Parameters.
color = 2;

% 3 pairs 
% fileName = char( 'uttower_left.jpg', 'uttower_right.jpg' );
% fileName = char('100-0025_img.jpg', '101-0104_img.jpg' );
% fileName = char('100-0023_img.jpg', '100-0024_img.jpg' );
% fileName = char( '100-0024_img.jpg', '100-0039_img.jpg' );

% 3 pics
% fileName = char('100-0023_img.jpg', '100-0024_img.jpg', '100-0039_img.jpg' );
% fileName = char( 'goldengate-01.png', 'goldengate-02.png', 'goldengate-03.png' );
fileName = char( '3.png', '4.png', '5.png' );

% 4 pics
% fileName = char('3.png', '4.png', '5.png', '6.png' );

% 5 pics center is 3
% fileName = char('goldengate-00.png', 'goldengate-01.png', 'goldengate-02.png', 'goldengate-03.png', 'goldengate-04.png' );

if color == 2
% if size( fileName, 1 ) == 2
    %     [ imgDouble, tform, tform2, xdata, ydata ] = transform2_right( fileName );
    %     [ output1, xdata1, ydata1 ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
    %     figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;
    % 
    %     [ output2, xdata2, ydata2 ] = imtransform( imgDouble{2}, tform2, 'XData', xdata, 'YData', ydata );
    %     figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    % 
    %     merge_output = output1 .* 0.5 + output2 .* 0.5;
    %     figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    % else
    if size( fileName, 1 ) == 2
        [ ~, ~, ~ ] = transform2_Color_Blending( fileName );
    elseif size( fileName, 1 ) == 3
        [ ~, ~, ~ ] = transform3_Color_Blending( fileName );
    elseif size( fileName, 1 ) == 4
        [ ~, ~, ~ ] = transform4( fileName );
    elseif size( fileName, 1 ) == 5
        [ ~, ~, ~ ] = transform5( fileName );
    else
        fprintf( 'more than 5 are not supported ! \n' );
    end
elseif color == 1
% if size( fileName, 1 ) == 2
    %     [ imgDouble, tform, tform2, xdata, ydata ] = transform2_right( fileName );
    %     [ output1, xdata1, ydata1 ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
    %     figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;
    % 
    %     [ output2, xdata2, ydata2 ] = imtransform( imgDouble{2}, tform2, 'XData', xdata, 'YData', ydata );
    %     figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    % 
    %     merge_output = output1 .* 0.5 + output2 .* 0.5;
    %     figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    % else
    if size( fileName, 1 ) == 2
        [ ~, ~, ~ ] = transform2_Color( fileName );
    elseif size( fileName, 1 ) == 3
        [ ~, ~, ~ ] = transform3_Color( fileName );
    elseif size( fileName, 1 ) == 4
        [ ~, ~, ~ ] = transform4( fileName );
    elseif size( fileName, 1 ) == 5
        [ ~, ~, ~ ] = transform5( fileName );
    else
        fprintf( 'more than 5 are not supported ! \n' );
    end
else

    % if size( fileName, 1 ) == 2
    %     [ imgDouble, tform, tform2, xdata, ydata ] = transform2_right( fileName );
    %     [ output1, xdata1, ydata1 ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
    %     figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;
    % 
    %     [ output2, xdata2, ydata2 ] = imtransform( imgDouble{2}, tform2, 'XData', xdata, 'YData', ydata );
    %     figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    % 
    %     merge_output = output1 .* 0.5 + output2 .* 0.5;
    %     figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    % else
    if size( fileName, 1 ) == 2
        [ imgDouble, tform, tform2, xdata, ydata ] = transform2( fileName );
        [ output1, xdata1, ydata1 ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
        % figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;

        [ output2, xdata2, ydata2 ] = imtransform( imgDouble{2}, tform2, 'XData', xdata, 'YData', ydata );
        % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

        merge_output = output1 .* 0.5 + output2 .* 0.5;
        figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    elseif size( fileName, 1 ) == 3
        [ imgDouble, xdata, ydata ] = transform3( fileName );
    elseif size( fileName, 1 ) == 4
        [ imgDouble, xdata, ydata ] = transform4( fileName );
    elseif size( fileName, 1 ) == 5
        [ imgDouble, xdata, ydata ] = transform5( fileName );
    else
        fprintf( 'more than 5 are not supported ! \n' );
    end
end


end

