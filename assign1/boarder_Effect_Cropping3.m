function [ R, G, B ] = boarder_Effect_Cropping3( R, G, B, sum_up_Window, search_Window_For_Cropping, threshold_of_average, scale_of_average )
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


sum_up_Window = ceil( size(R,1) / sum_up_Window);
search_Window_For_Cropping_y = ceil( size(R, 2) / search_Window_For_Cropping );
search_Window_For_Cropping_x = ceil( size(R, 1) / search_Window_For_Cropping );

sum_vector_of_R_y = sum(R);
sum_vector_of_G_y = sum(G);
sum_vector_of_B_y = sum(B);

sum_vector_of_R_x = sum(R, 2)';
sum_vector_of_G_x = sum(G, 2)';
sum_vector_of_B_x = sum(B, 2)';

y1_R = 1;
y1_G = 1;
y1_B = 1;
y2_R = size(sum_vector_of_R_y, 2);
y2_G = size(sum_vector_of_G_y, 2);
y2_B = size(sum_vector_of_B_y, 2);
y1_R = max( y1_R, cropSearching_y1_y2( sum_vector_of_R_y, 1, sum_up_Window, search_Window_For_Cropping_y, threshold_of_average, scale_of_average ) );
y1_G = max( y1_G, cropSearching_y1_y2( sum_vector_of_G_y, 1, sum_up_Window, search_Window_For_Cropping_y, threshold_of_average, scale_of_average ) );
y1_B = max( y1_B, cropSearching_y1_y2( sum_vector_of_B_y, 1, sum_up_Window, search_Window_For_Cropping_y, threshold_of_average, scale_of_average ) );

y2_R = min( y2_R, cropSearching_y1_y2( sum_vector_of_R_y, size(sum_vector_of_R_y, 2), sum_up_Window, search_Window_For_Cropping_y, threshold_of_average, scale_of_average ) );
y2_G = min( y2_G, cropSearching_y1_y2( sum_vector_of_G_y, size(sum_vector_of_G_y, 2), sum_up_Window, search_Window_For_Cropping_y, threshold_of_average, scale_of_average ) );
y2_B = min( y2_B, cropSearching_y1_y2( sum_vector_of_B_y, size(sum_vector_of_B_y, 2), sum_up_Window, search_Window_For_Cropping_y, threshold_of_average, scale_of_average ) );

%
x1_R = 1;
x1_G = 1;
x1_B = 1;
x2_R = size(sum_vector_of_R_x, 2);
x2_G = size(sum_vector_of_G_x, 2);
x2_B = size(sum_vector_of_B_x, 2);
x1_R = max( x1_R, cropSearching_y1_y2( sum_vector_of_R_x, 1, sum_up_Window, search_Window_For_Cropping_x, threshold_of_average, scale_of_average ) );
x1_G = max( x1_G, cropSearching_y1_y2( sum_vector_of_G_x, 1, sum_up_Window, search_Window_For_Cropping_x, threshold_of_average, scale_of_average ) );
x1_B = max( x1_B, cropSearching_y1_y2( sum_vector_of_B_x, 1, sum_up_Window, search_Window_For_Cropping_x, threshold_of_average, scale_of_average ) );

x2_R = min( x2_R, cropSearching_y1_y2( sum_vector_of_R_x, size(sum_vector_of_R_x, 2), sum_up_Window, search_Window_For_Cropping_x, threshold_of_average, scale_of_average ) );
x2_G = min( x2_G, cropSearching_y1_y2( sum_vector_of_G_x, size(sum_vector_of_G_x, 2), sum_up_Window, search_Window_For_Cropping_x, threshold_of_average, scale_of_average ) );
x2_B = min( x2_B, cropSearching_y1_y2( sum_vector_of_B_x, size(sum_vector_of_B_x, 2), sum_up_Window, search_Window_For_Cropping_x, threshold_of_average, scale_of_average ) );

% R = R(x1_R: x2_R, y1_R: y2_R);
% G = G(x1_G: x2_G, y1_G: y2_G);
% B = B(x1_B: x2_B, y1_B: y2_B);

max_x1 = max( [x1_R, x1_G, x1_B] );
min_x2 = min( [x2_R, x2_G, x2_B] );
max_y1 = max( [y1_R, y1_G, y1_B] );
min_y2 = min( [y2_R, y2_G, y2_B] );

R = R( max_x1: min_x2, max_y1: min_y2 );
G = G( max_x1: min_x2, max_y1: min_y2 );
B = B( max_x1: min_x2, max_y1: min_y2 );

end

