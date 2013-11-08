function [ merge_output, xdata, ydata ] = transform3_Color_Blending( fileName )
%TRANSFORM2 Match transform between two pictures
%   between two pictures

tic1 = tic;

    [ ~, tform_1, tform2_1, xdata_1, ydata_1 ] = transform2( [  fileName(1, :); fileName(2, :) ] );
    
    [ ~, tform_2, ~, xdata_2, ydata_2 ] = transform2( [  fileName(3, :); fileName(2, :) ] );
    
    xdata(1) = min( xdata_1(1), xdata_2(1) );
    ydata(1) = min( ydata_1(1), ydata_2(1) );
    xdata(2) = max( xdata_1(2), xdata_2(2) );
    ydata(2) = max( ydata_1(2), ydata_2(2) );

    imgInput1 = im2double(imread( fileName(1, :) ));
    imgInput2 = im2double(imread( fileName(2, :) ));
    imgInput3 = im2double(imread( fileName(3, :) ));

    tform_1.tdata.T
    tform2_1.tdata.T
    tform_2.tdata.T
    
    
    [ output1, ~, ~ ] = imtransform( imgInput1, tform_1, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output1, 'XData', xdata, 'YData', ydata ), axis on, impixelinfo;

    [ output2, ~, ~ ] = imtransform( imgInput2, tform2_1, 'XData', xdata, 'YData', ydata );
    % figure, imshow( output2, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;
    
    [ output3, ~, ~ ] = imtransform( imgInput3, tform_2, 'XData', xdata, 'YData', ydata );

    overlap = (output1 > 0.00000001) + (output2 > 0.00000001) + (output3 > 0.00000001);
    overlap2 = (overlap == 3) * 0.33333 + (overlap == 2) * 0.5 + (overlap == 1) * 1;
    merge_output = (output1 + output2 + output3) .* overlap2;
    

%     merge_output = output1 .* 0.5 + output2 .* 0.5 + output3 .* 0.5;
    if ndims( merge_output ) == 3
        for i = 1 : 3
            merge_output(:,:,i) = ordfilt2( merge_output(:,:,i), 5, ones(3) );
        end
    else 
        merge_output(:,:) = ordfilt2( merge_output(:,:), 5, ones(3) );
    end
    figure, imshow( merge_output, 'XData', xdata , 'YData', ydata ), axis on, impixelinfo;

    
toc(tic1);

end

