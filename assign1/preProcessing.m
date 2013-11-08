function [ B, G, R, x1, x2, x3, x4, y1, y2, x11, x22, x33, x44, y11, y22, slide_y1, slide_y2, slide_x1, slide_x4 ] = preProcessing( img_negative_from_input, sum_up_Window, search_Window, search_Window_x1_x4, search_Window_y1_y2 )
%PREPROCESSING Summary of this function goes here
%%%   Copyright (c) <2013>, Yanliang Han
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
% 3. Neither the name of the University of Illinois at Urbana-Champaign nor the
%    names of its contributors may be used to endorse or promote products
%    derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY Yanliang Han ''AS IS'' AND ANY
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL Yanliang Han BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% %

% sum_up_Window = floor(size(img_negative_from_input,1) / sum_up_Window);
sum_up_Window1 = 1 ;
sum_up_Window2 = 1 ;
search_Window = ceil(size(img_negative_from_input,1) / search_Window);

search_Window_x1_x4 = ceil(size(img_negative_from_input,1) / search_Window_x1_x4);
search_Window_y1_y2 = ceil(size(img_negative_from_input,2) / search_Window_y1_y2);


%% Left and Right Boundery Detection
sum_vector_of_y = sum(img_negative_from_input);
y1 = 1;
y2 = size(img_negative_from_input,2);
[y1] = preSearching_y1_y2( sum_vector_of_y, y1, sum_up_Window1, search_Window_y1_y2 );
[y2] = preSearching_y1_y2( sum_vector_of_y, y2, sum_up_Window1, search_Window_y1_y2 );

% Process
img_negative_from_input = img_negative_from_input( :, y1:y2 );

[ img_negative_from_input, y11, y22, slide_y1, slide_y2 ] = boarder_Effect_Locating2_y( img_negative_from_input, sum_up_Window2, search_Window, 1 / 4, 33 / 100 );
y22 = y1 + y22 - 1;
y11 = y1 + y11 - 1;

%% Chopping Upper and Lower Boundery
sum_vector_of_x = sum(img_negative_from_input, 2)';

x1 = 1;
x4 = size(img_negative_from_input,1);

[x1] = preSearching_x1_x4( sum_vector_of_x, x1, sum_up_Window1, search_Window_x1_x4 );
[x4] = preSearching_x1_x4( sum_vector_of_x, x4, sum_up_Window1, search_Window_x1_x4 );

% Process
img_negative_from_input = img_negative_from_input( x1:x4, : );

[ img_negative_from_input, x11, x44, slide_x1, slide_x4  ] = boarder_Effect_Locating2_x( img_negative_from_input, sum_up_Window2, search_Window, 1 / 4, 33 / 100 );
x44 = x1 + x44 - 1;
x11 = x1 + x11 - 1;

%% X Axis Direction Detection of Boundary
% sum_vector_of_x = sum(img_negative_from_input, 2)';

% height = round(size(img_negative_from_input,1)/3);
% x2 = height ;
% x3 = height*2 ;
x2 = round(size(img_negative_from_input,1) * 12/36);
x3 = round(size(img_negative_from_input,1) * 25/36);
% sum_up_Window1 = 3;
% search_Window2 = 25 ;
% [x22] = preSearching( sum_vector_of_x, x2, sum_up_Window1, search_Window2 );
% [x33] = preSearching( sum_vector_of_x, x3, sum_up_Window1, search_Window2 );
x22 = x2;
x33 = x3;

% Process
B = img_negative_from_input(1:x22, :);
G = img_negative_from_input(x22+1:x33, :);
R = img_negative_from_input(x33+1:size(img_negative_from_input, 1), :);

end

