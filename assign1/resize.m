function [ imgA, imgB, imgC ] = resize( imgA, imgB, imgC )
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


height = min ( min(size(imgA,1), size(imgB,1)), size(imgC,1));
if height < size(imgA,1)  
    imgA = imgA( floor( (size(imgA,1) - height) / 2 ) + 1 : height + floor( (size(imgA,1) - height) / 2 ), :);
end
if height < size(imgB,1)   
    imgB = imgB( floor( (size(imgB,1) - height) / 2 ) + 1 : height + floor( (size(imgB,1) - height) / 2 ), :);
end
if height < size(imgC,1)   
    imgC = imgC( floor( (size(imgC,1) - height) / 2 ) + 1 : height + floor( (size(imgC,1) - height) / 2 ), :);
end


width = min (min(size(imgA,2), size(imgB,2)), size(imgC,2));
if width < size(imgA,2)  
    imgA = imgA( :, floor( (size(imgA,2) - width) / 2 ) + 1 : width + floor( (size(imgA,2) - width) / 2 ) );
end
if width < size(imgB,2)   
    imgB = imgB( :, floor( (size(imgB,2) - width) / 2 ) + 1 : width + floor( (size(imgB,2) - width) / 2 ) );
end
if width < size(imgC,2)   
    imgC = imgC( :, floor( (size(imgC,2) - width) / 2 ) + 1 : width + floor( (size(imgC,2) - width) / 2 ) );
end


end



