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


%---File Name: IMG2TEXT.m---
%---Date: Jan. 17, 2013
%---Description:
%--- Processes .jpg image files into .dat files for FPGA processing.
%---Associated Files:
%--- text2img.m
%---Author : Ricardo Acevedo

clc;
close all;
clear all;

frameCounter = 250;
imagesNumber = 84;

imageDir = 'C:\tftp\tftpd32.450\';
outputDir = 'C:\Vhdl\composerTest\fpgaImg\';


for i=1:imagesNumber
    
    A = imread( [imageDir, sprintf('Frame%d.jpg', frameCounter)] , 'JPG');
    %A = imread(sprintf('Frame%d.jpg',frameCounter),'JPG');
    I = rgb2gray(A);
    
    
    [r,c] = size(I);
    
    fileID = fopen( [outputDir,sprintf('data%d.dat',i)] , 'w');
    for m = 1:r 
        for n = 1:c
            %fprintf(fileID,'%s\n',dec2bin(I(m,n),8)); %write in binary
            fprintf( fileID,'%u\n',I(m,n) ); %write in decimal
        end
    end 
    frameCounter = frameCounter + 1;  
    fclose(fileID); 
    
end

 
