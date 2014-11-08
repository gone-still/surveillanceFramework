

%---File Name: blobTracker.m---
%---Date: Feb. 08, 2014
%---Description:
%---Blob measurements and correction:
%--- blob area, width, height and center of mass
%---Associated Files:
%--- blobMeasurements.m -- the blob measurements algorithm
%---Author : Ricardo Acevedo

clc;
clear all;
close all;

%max number of blobs post-correction:
maxBlobs = 2;
%deviation (Aprox) from the current feature (area) mean:
percentTh = 0.4;

%points by frame:
%blobMeas = zeros(maxBlobs, 6);

%Blob measurements table
%   1   2   3   4  5    6 
% [Bin][Cx][Cy][W][H][Area] 

F1 = [1, 47, 46, 3124; 2, 50, 36, 1150];

F2 = [1, 50, 50, 3000; 2, 60, 40, 1000];

F3 = [1, 60, 40, 1300; 2, 60, 60, 3300];

blobFrames = {F1, F2, F3};

mdfTable = zeros(maxBlobs, 8);
%   1      2      3    4     5     6    7      8
% [Blob][newX][newY][oldX][oldY][area][mfd][newBlob]

infiniteValue = 10000;
mdfTable(:,7) = infiniteValue; %infinite distance is initial distance

oldX = 0;
oldY = 0;
newX = 0;
newY = 0;
newMFD = 0;

currentBlob = 0;
pastBlob = 0;
oldArea = 0;
newArea = 0;

areaTh = 0;
areaMin = 0;
areaMax = 0;

tic;

for frames = 1:3
    
    blobMeas = blobFrames{frames};

    %for each blob...
    for i = 1:maxBlobs
    
    %Blob #
    mdfTable(i,1) = i;

    %extract current blob measurements:
    oldX = mdfTable(i,2); 
    oldY = mdfTable(i,3);

    oldArea = mdfTable(i,6);
    pastMDF = mdfTable(i,7);
    
    fprintf(['Blob# ' num2str(i) ' at (' num2str(oldX) ', ' num2str(oldY) ')' ' area: ' num2str(oldArea)])
    
        %test against each blob..
        for j = 1:maxBlobs %i:maxBlobs

            %past data:
            newX = blobMeas(j,2);
            newY = blobMeas(j,3);
            newArea = blobMeas(j,4);
            areaTh = oldArea * percentTh;
            areaMin = oldArea - areaTh;
            areaMax = oldArea + areaTh;
            
            %only if data != 0
            if (oldX ~= 0 || oldY ~= 0)

                %compute MDF:
                currentMDF =( (oldX - newX)^2 + (oldY - newY)^2 );
                areaMDF = (oldArea - newArea)^2;

                %current distance is smaller than past distance
                if (currentMDF < pastMDF) && (newArea > areaMin) && (newArea < areaMax)
                    mdfTable(i,7) = currentMDF;
                    pastMDF = currentMDF;
                    mdfTable(i,8) = j; %smaller distance blob in current frame is past blob
                    %store coordinates:
                    mdfTable(i,2) = newX;
                    mdfTable(i,3) = newY; 
                    mdfTable(i,6) = newArea;
                end

            else
                %store past data for the first time:
                if (i == j)
                    mdfTable(i,2) = newX;
                    mdfTable(i,3) = newY;
                    mdfTable(i,6) = newArea;
                end        
            end 

        end 
        %blob tracking:
        disp([' is now Blob# ' num2str(mdfTable(i,8)) ' at (' num2str(mdfTable(i,2)) ', ' num2str(mdfTable(i,3)) ')' ' area: ' num2str(mdfTable(i,6))])
        %reset initial MDF:
        mdfTable(i, 7) = infiniteValue;
    end

end
toc;
disp(['Total execution time: ' num2str((toc)*1000) ' ms']);