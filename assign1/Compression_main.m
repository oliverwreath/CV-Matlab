function [  ] = Compression_main(  )
%COMPRESSION_MAIN Summary of this function goes here
%   Detailed explanation goes here


% parameters goes here
directoryPath = 'D:\report\report3_ProductionTest_400\';
outputDirectory = 'D:\report\report3_ProductionTest_200\';
outputDirectory2 = 'D:\report\report2_smaller_Compressed\';

% 800
% 100

% fileListing = dir(fullfile(directoryPath, '*.*') );
fileListing = dir(fullfile(directoryPath, '*.*') );
fileCount = ceil( size( fileListing, 1 ) );

for i = 1 : fileCount
    if fileListing(i).isdir == 0
        %Compression Begins
        if fileListing(i).bytes > 60000;
            A = imread([directoryPath fileListing(i).name]);
            A = imresize(A, [200, NaN]);
            imwrite( A, [ outputDirectory '-200px-' fileListing(i).name ] );
        end
        progress = [num2str(i * 100 /fileCount) '%']
        %Compression Ends
    end
end

% Compression_Begins = 'Compression_Begins'
% % Compression Begins
% zip( [outputDirectory2 'Compressed.zip'], outputDirectory );
% % Compression Ends
% Compression_Ends = 'Compression_Ends'

end

