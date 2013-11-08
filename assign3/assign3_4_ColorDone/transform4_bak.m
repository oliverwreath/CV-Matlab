function [ merge_output, xdata, ydata ] = transform4( fileName )
%TRANSFORM2 Match transform between two pictures
%   between two pictures

tic1 = tic;

    [ imgDouble, tform, tform2, xdata, ydata ] = transform2( fileName );
    
    [ imgDouble_right, tform_right, ~, xdata_right, ydata_right ] = transform2( [  fileName(3, :); fileName(2, :) ] );
    
    [ imgDouble_4, tform_4, ~, xdata_4, ydata_4 ] = transform2( [  fileName(4, :); fileName(3, :) ] );
%     [ temp, ~, ~ ] = imtransform( imgDouble_4{1}, tform_4 );
%     [ imgDouble_4, tform_4_2, ~, xdata_4, ydata_4 ] = transform2( [  temp; fileName(2, :) ] );
    tform_4.tdata.T = tform_right.tdata.T * tform_4.tdata.T;
    [ ~, xdata_4, ydata_4 ] = imtransform( imgDouble_4{1}, tform_4 );
    
    min3 = @( x, y, z ) min( min( x, y ), z );
    max3 = @( x, y, z ) max( max( x, y ), z );
    xdata(1) = min3( xdata(1), xdata_right(1), xdata_4(1) );
    ydata(1) = min3( ydata(1), ydata_right(1), ydata_4(1) );
    xdata(2) = max3( xdata(2), xdata_right(2), xdata_4(2) );
    ydata(2) = max3( ydata(2), ydata_right(2), ydata_4(2) );

    [ output1, ~, ~ ] = imtransform( imgDouble{1}, tform, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;

    [ output2, ~, ~ ] = imtransform( imgDouble{2}, tform2, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

    [ output3, ~, ~ ] = imtransform( imgDouble_right{1}, tform_right, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    
    [ output4, ~, ~ ] = imtransform( imgDouble_4{1}, tform_4, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

    merge_output = output1 .* 0.3 + output2 .* 0.3 + output3 .* 0.3 + output4 .* 0.3;
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

