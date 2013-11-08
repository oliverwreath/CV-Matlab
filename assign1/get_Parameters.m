function [ thresholdScale, sum_up_Window, search_Window, search_Window_x1_x4, search_Window_y1_y2, pyramid_DrillDown_Threshold, search_Window_For_Cropping, search_Window_For_Cropping2, scale_of_average, mode_Decision ] = get_Parameters(  )
%GETPARAMETERS Summary of this function goes here
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

thresholdScale = 16;
sum_up_Window = 345 ;
search_Window = 170 ;
search_Window_x1_x4 = 40.96 ;
search_Window_y1_y2 = 15.6 ;
pyramid_DrillDown_Threshold = 150; %optimized
% pyramid_DrillDown_Threshold = 999999999999;
search_Window_For_Cropping = 28;
search_Window_For_Cropping2 = 58;
scale_of_average = 1 / 5;
mode_Decision = 0;  %-1 for Fastest, 0 Optimized Normal,  1 for Best Quality 

end

