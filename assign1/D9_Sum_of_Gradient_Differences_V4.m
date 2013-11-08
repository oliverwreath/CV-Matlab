function [ distance ] = D9_Sum_of_Gradient_Differences_V4( grad_A, grad_B, grad_A_y, grad_B_y )
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

A = abs(grad_A - grad_B);
B = abs(grad_A_y - grad_B_y);

% threshold = 0.3;
% maxA = max(max(A));
% maxB = max(max(B));
% threA = threshold * maxA;
% threB = threshold * maxB;

% figure, surfc(A), view(150, 60)
% figure, surfc(B), view(150, 60)
% figure, mesh(A), view(150, 60)
% figure, mesh(B), view(150, 60)

% for i = 1 : size(A, 1)
%     for j = 1 : size(A, 2)
%         if A(i, j) < threA || B(i, j) < threB
%             A(i, j) = 0 ;
%             B(i, j) = 0 ;
%         end
%     end
% end

abs_of_2degree_grad_SOD_matrix = A + B ;

distance = sum(abs_of_2degree_grad_SOD_matrix(:));

end

