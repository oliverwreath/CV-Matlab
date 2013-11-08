function show_all_ellipses(I, cx, cy, rad, eigD, MajorColumn, MinorColumn, angleColumn, ReNumber )
%% I: image on top of which you want to display the circles
%% cx, cy: column vectors with x and y coordinates of circle centers
%% rad: column vector with radii of circles. 
%% The sizes of cx, cy, and rad must all be the same
%% color: optional parameter specifying the color of the circles
%%        to be displayed (red by default)
%% ln_wid: line width of circles (optional, 1.5 by default

DrawingTic = tic;

if nargin > 2

    CircleNum = size(cx,1)

    color = 'r';
    ln_wid = 1;

    diffNumberR = 0 ;
    
    figure, imshow(I); hold on;
    
    for ii = 1 : size(cx, 1)
        if ii > size(cx, 1)
            break;
        end
        
        %% R < 0 Removal
        level1 = graythresh( eigD( :, 1) );
        level2 = graythresh( eigD( :, 2) );
        if eigD( ii, 1) < level1 || eigD( ii, 2) < level2
            line( cx(ii), cy(ii), 'Color', 'r', 'LineWidth', 1);
            %rad(ii) = 0.5;
            diffNumberR = diffNumberR + 1;
            continue;
        end

        %Circle
        [ X Y ] = calculateCircle( cx(ii), cy(ii), rad(ii) );
        line(X, Y, 'Color', color, 'LineWidth', ln_wid);
        
        
%         %%Ellipse
%         p = calculateEllipse( cx(ii), cy(ii), MajorColumn(ii), MinorColumn(ii), angleColumn(ii) );
%         line(p(:,1), p(:,2), 'Color', color, 'LineWidth', ln_wid);
    end

    ReNumber = ReNumber + diffNumberR;
    CircleNum = CircleNum - diffNumberR;
    title(sprintf('%d Circles, %d Removed', CircleNum, ReNumber ));
    
    hold off;

end

toc(DrawingTic);

end
