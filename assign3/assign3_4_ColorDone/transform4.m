function [ merge_output, xdata, ydata ] = transform4( fileName )
%TRANSFORM2 Match transform between two pictures
%   between two pictures

tic1 = tic;

    [ imgDouble_1, tform_1, tform2_1, xdata_1, ydata_1 ] = transform2( [  fileName(1, :); fileName(3, :) ] );
    
    [ imgDouble_2, tform_2, ~, xdata_2, ydata_2 ] = transform2( [  fileName(2, :); fileName(3, :) ] );
    
    [ imgDouble_4, tform_4, ~, xdata_4, ydata_4 ] = transform2( [  fileName(4, :); fileName(3, :) ] );
    
    min3 = @( x, y, z ) min( min( x, y ), z );
    max3 = @( x, y, z ) max( max( x, y ), z );
    xdata(1) = min3( xdata_1(1), xdata_2(1), xdata_4(1), xdata_5(1) );
    ydata(1) = min3( ydata_1(1), ydata_2(1), ydata_4(1), ydata_5(1) );
    xdata(2) = max3( xdata_1(2), xdata_2(2), xdata_4(2), xdata_5(2) );
    ydata(2) = max3( ydata_1(2), ydata_2(2), ydata_4(2), ydata_5(2) );
        
    [ output1, ~, ~ ] = imtransform( imgDouble_1{1}, tform_1, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;

    [ output2, ~, ~ ] = imtransform( imgDouble_2{1}, tform_2, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    
    [ output3, ~, ~ ] = imtransform( imgDouble_1{2}, tform2_1, 'XData', xdata, 'YData', ydata );

    [ output4, ~, ~ ] = imtransform( imgDouble_4{1}, tform_4, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

    merge_output = output1 .* 0.5 + output2 .* 0.5 + output3 .* 0.5 + output4 .* 0.5;
    figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

    


% 
% [ imgDouble, tform, tform2, xdata, ydata ] = transform2( fileName(1: 2, :) );
% 
% [ imgDouble_right, tform_right, tform2_right, xdata_right, ydata_right ] = transform2_right( fileName(2: 3, :) );
% 
% xdata(1) = min( xdata(1), xdata_right(1) );
% ydata(1) = min( ydata(1), ydata_right(1) );
% xdata(2) = max( xdata(2), xdata_right(2) );
% ydata(2) = max( ydata(2), ydata_right(2) );
% 
% [ output1, xdata1, ydata1 ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
% % figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;
% 
% [ output2, xdata2, ydata2 ] = imtransform( imgDouble{2}, tform2, 'XData', xdata, 'YData', ydata );
% % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
% 
% [ output3, xdata2, ydata2 ] = imtransform( imgDouble_right{2}, tform_right, 'XData', xdata, 'YData', ydata );
% % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
% 
% merge_output = output1 .* 0.5 + output2 .* 0.5 + output3 .* 0.5;
% figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
% 
% 
% 
%     [ imgDouble, tform, tform2, xdata, ydata ] = transform2_right( fileName );
%     [ output1, xdata1, ydata1 ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
%     figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;
% 
%     [ output2, xdata2, ydata2 ] = imtransform( imgDouble{2}, tform2, 'XData', xdata, 'YData', ydata );
%     figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
% 
%     merge_output = output1 .* 0.5 + output2 .* 0.5;
%     figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    
toc(tic1);

end

