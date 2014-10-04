% Copyright (c) 2013-2014 Ricardo Acevedo

% Permission is hereby granted, free of charge, to any person
% obtaining a copy of this software and associated documentation
% files (the "Software"), to deal in the Software without
% restriction, including without limitation the rights to use,
% copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the
% Software is furnished to do so, subject to the following
% conditions:

% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
% OTHER DEALINGS IN THE SOFTWARE.


%---File Name: TEXT2IM.m---
%---Date: Jan. 17, 2013
%---Description:
%--- Processes .dat files produced by FPGA into grayscale images.
%---Associated Files:
%--- img2text.m
%---Author : Ricardo Acevedo

clc;
close all;
clear all;
frameCounter = 250;
imageWidth = 320;
imageHeight = 240;

imageEnd = 7;
imageStart = 1;

numVars = zeros(imageWidth*imageHeight, 1);
imageMatrix = zeros(imageHeight,imageWidth);

imagePixels = 1;
debug = 0;
tempData = 0;

imageDir = 'C:\tftp\tftpd32.450\';
outputDir = 'C:\Vhdl\composerTest\fpgaImg\';

fpgaData = 1;

for i=imageStart:imageEnd
    
    imagePixels = 1;
    
    if (fpgaData)
         %FPGA data file:
        fileID = fopen([imageDir,sprintf('outD%d.dat',i)],'r');
    else
        %simulation files:
        if (i < 10)
            fileID = fopen([imageDir,sprintf('outF0%d.log',i)],'r');
        else
            fileID = fopen([imageDir,sprintf('outF%d.log',i)],'r');
        end   
    end
    
    C = textscan(fileID,'%s');
    fclose(fileID); 
    data = C{1,1};
    
    for j=1:size(data)       
        switch ( char(data(j)) )
            case '064'
                tempData = 64;
            case '000'
                tempData = 0;
            otherwise
                if (fpgaData)
                    tempData = str2double(data(j)); %receive decimal data
                else
                    tempData = bin2dec(char(data(j))); %receive binary
                    %data
                end              
        end        
        numVars(j) = tempData;
    end
    
    for x = 1:imageHeight
        for y = 1:imageWidth
            imageMatrix(x,y) = numVars(imagePixels);
            imagePixels = imagePixels + 1;
            if imagePixels == 76800
                debug = 1;
            end
        end
    end

    I = mat2gray(imageMatrix, [0 255]);
    disp('Image parsed from FPGA Data...');
    figure, imshow(I);
    
    %Image path for writing results to file
    %[imageDir, sprintf('Frame%d.jpg', frameCounter)] 
    %imgName = [outputDir, sprintf('classifierHardware%d',i), '.png'];
    %imwrite(I, imgName);
    %disp(['Wrote Image: ' imgName ]);
    
    frameCounter = frameCounter + 1;  
    
end

 
