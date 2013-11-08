function [ ret ] = preSearching( sum_vector_of_x, x2, sum_up_Window, search_Window )
%PRESEARCHING Summary of this function goes here
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

minSum1 = 9999999;
minSum2 = 9999999;
ret1 = x2;
ret2 = x2;

for i = x2 : x2 - search_Window
    if i < 1
        break ;
    end
    if i > size(sum_vector_of_x, 2)
        break ;
    end
    tempSum = sum(sum_vector_of_x(i-sum_up_Window:i+sum_up_Window));
    if minSum1 > tempSum
        minSum1 = tempSum;
        ret1 = i;
    end
end

for i = x2 : x2 + search_Window
    if i < 1
        break ;
    end
    if i > size(sum_vector_of_x, 2)
        break ;
    end
    tempSum = sum(sum_vector_of_x(i-sum_up_Window:i+sum_up_Window));
    if minSum2 > tempSum
        minSum2 = tempSum;
        ret2 = i;
    end
end

if minSum1 < minSum2
    ret = ret1;
else 
    ret = ret2;
end

end

