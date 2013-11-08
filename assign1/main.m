function [ ] = main(  ) %distance_Measure_Selection
%MAIN the start point of the whole project 
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

distance_Measure_Selection = 9;

main_tic = tic;

% parameters goes here
directoryPath = 'D:\report\input2\';
outputDirectory = 'D:\report\finalOutput00\';

% 200
% 50

fileListing = dir(fullfile(directoryPath, '*.*') );
fileCount = ceil( size( fileListing, 1 ) );
sizeCount = 0 ;
for i = 1 : fileCount
    if fileListing(i).isdir == 0
        sizeCount = sizeCount + fileListing(i).bytes;
    end
end
sizeSum = 0 ;

for i = 1 : fileCount
    if fileListing(i).isdir == 0
        colorizing( fileListing(i).name, directoryPath, outputDirectory, distance_Measure_Selection )
        sizeSum = sizeSum + fileListing(i).bytes;
    end
    progress = [num2str( sizeSum * 100 /sizeCount) '%']
end

toc(main_tic);

end

