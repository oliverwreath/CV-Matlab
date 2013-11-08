function [ merge_output, xdata, ydata ] = transform3_Color( fileName )
%TRANSFORM2 Match transform between two pictures
%   between two pictures

tic1 = tic;

    [ ~, tform_1, tform2_1, xdata_1, ydata_1 ] = transform2( [  fileName(1, :); fileName(2, :) ] );
    
    [ ~, tform_2, ~, xdata_2, ydata_2 ] = transform2( [  fileName(3, :); fileName(2, :) ] );
    
    xdata(1) = min( xdata_1(1), xdata_2(1) );
    ydata(1) = min( ydata_1(1), ydata_2(1) );
    xdata(2) = max( xdata_1(2), xdata_2(2) );
    ydata(2) = max( ydata_1(2), ydata_2(2) );

    imgInput1 = imread( fileName(1, :) );
    imgInput2 = imread( fileName(2, :) );
    imgInput3 = imread( fileName(3, :) );

    tform_1.tdata.T
    tform2_1.tdata.T
    tform_2.tdata.T
    
    
    [ output1, ~, ~ ] = imtransform( imgInput1, tform_1, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;

    [ output2, ~, ~ ] = imtransform( imgInput2, tform2_1, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    
    [ output3, ~, ~ ] = imtransform( imgInput3, tform_2, 'XData', xdata, 'YData', ydata );

    merge_output = output1 .* 0.5 + output2 .* 0.5 + output3 .* 0.5;
    figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

    
toc(tic1);

end

