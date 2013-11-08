function [ img_negative_from_input, y1_R, y2_R, slide_y1, slide_y2 ] = boarder_Effect_Locating2_y( img_negative_from_input, sum_up_Window, search_Window, threshold_of_average, scale_of_average )
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


sum_up_Window = 0;

search_Window_For_Cropping_y = ceil( size(img_negative_from_input, 2) * 17/400) ;

sum_vector_of_R_y = sum(img_negative_from_input);

y1_R = 1;

y2_R = size(sum_vector_of_R_y, 2);

y1_R = max( y1_R, cropSearching_y1_y2( sum_vector_of_R_y, 1, sum_up_Window, search_Window_For_Cropping_y, threshold_of_average, scale_of_average ) );

y2_R = min( y2_R, cropSearching_y1_y2( sum_vector_of_R_y, size(sum_vector_of_R_y, 2), sum_up_Window, search_Window_For_Cropping_y, threshold_of_average, scale_of_average ) );

%
% R = R(x1_R: x2_R, y1_R: y2_R);
% G = G(x1_G: x2_G, y1_G: y2_G);
% B = B(x1_B: x2_B, y1_B: y2_B);
img_negative_from_input = img_negative_from_input(:,y1_R:y2_R);

slide_y1 = y1_R - 1;
slide_y2 = size(sum_vector_of_R_y, 2) - y2_R ;

end

