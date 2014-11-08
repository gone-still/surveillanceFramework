

%---File Name: blobMeasurements.m---
%---Date: Feb. 04, 2014
%---Description:
%---Blob measurements and correction:
%--- blob area, width, height and center of mass
%---Associated Files:
%--- blobTracker.m -- the blob tracker algorithm
%---Author : Ricardo Acevedo

clc;
clear all;
close all;

%input:
%niceShape, eh??
bin1Label = [  0	0	0	0	0	0	0	0	0	0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0 ];
bin1Data(1,:) = [  0	0	0	0	0	0	0	0	0	0	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11	0	0	0	0	0	0	0	0	0	0	0	0	0	0 ];
bin1Data(2,:) = [  0	0	0	0	0	0	0	0	0	0	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	25	89	0	0	0	0	0	0	0	0	0	0	0	0	0	0 ];

bin2Label = [  0	0	0	0	0	0	0	0	0	0	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0 ];
bin2Data(1,:) = [  0	0	0	0	0	0	0	0	0	0	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	39	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0 ];
bin2Data(2,:) = [  0	0	0	0	0	0	0	0	0	0	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	61	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0 ];

bin3Label = [  0	0	0	0	0	0	0	0	0	0	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3 ];
bin3Data(1,:) = [  0	0	0	0	0	0	0	0	0	0	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	75	11	11	11	11	11	11	11	11	11	11	11	11	11	11	11 ];
bin3Data(2,:) = [  0	0	0	0	0	0	0	0	0	0	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89	89 ];

%simpleBlob
%bin1Label = [	0	0	0	0	0	0	0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1 0];
%bin1Data(1,:) = [	0	0	0	0	0	0	0	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	53	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	5	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	29	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76	76 0];
%bin1Data(2,:) = [	0	0	0	0	0	0	0	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	148	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101	101 0];

%blobGroup
% bin1Label = [	0	0	0	0	0	0	0	0	0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	0	0	0	0	0	0	0	0	0	0	0	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	0];
% bin1Data(1,:) = [	0	0	0	0	0	0	0	0	0	14	14	14	14	14	14	14	14	14	14	14	14	14	14	14	14	14	14	14	14	14	14	10	10	10	10	10	10	10	10	10	10	10	10	10	10	10	10	10	10	10	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	46	46	46	46	46	46	46	46	46	55	55	55	55	55	55	55	55	55	55	55	55	55	55	55	55	55	55	28	28	28	28	28	28	28	28	28	28	28	28	28	28	0	0	0	0	0	0	0	0	0	0	0	118	118	113	113	113	113	107	107	107	107	107	107	107	107	113	113	0];
% bin1Data(2,:) = [	0	0	0	0	0	0	0	0	0	50	50	50	50	50	50	50	50	50	50	50	50	50	50	50	50	50	50	50	50	50	50	68	68	68	68	68	68	68	68	68	68	68	68	68	68	68	68	68	68	68	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	104	99	99	99	99	99	0	0	0	0	0	0	0	0	0	0	0	134	134	134	135	135	135	135	135	135	135	135	135	135	135	135	135	0];
% 
% bin2Label = [		0	0	0	0	0	0	0	0	0	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0   0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
% bin2Data(1,:) = [	0	0	0	0	0	0	0	0	0	86	86	86	86	82	82	82	82	82	82	82	82	82	82	86	86	86	86	86	86	86	86	86	86	86	86	86	95	95	95	95	95	95	95	95	95	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0   0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
% bin2Data(2,:) = [	0	0	0	0	0	0	0	0	0	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	122	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0   0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
% 
% bin3Label = [		0	0	0	0	0	0	0	0	0	5	5	5	5	5	5	5	5	5	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0   0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
% bin3Data(1,:) = [	0	0	0	0	0	0	0	0	0	131	131	131	131	131	131	131	131	131	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0   0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
% bin3Data(2,:) = [	0	0	0	0	0	0	0	0	0	140	140	140	140	140	140	140	140	140	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0   0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];

%complex blob group
%bin1Label = [  0	0	0	0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	0	0	0	0	0	3	3	3	3	3	3	3	3	0	0	4	4	4	4	4	4	4	4	4	4	4	4	4	4	4	0	0 ];
% bin1Data(1,:) = [  0	0	0	0	40	40	40	40	40	40	40	40	32	32	32	32	32	32	32	32	24	24	24	24	24	24	24	24	33	33	33	33	33	33	33	33	56	56	56	56	56	56	56	56	56	56	56	56	56	56	56	56	0	0	0	0	0	17	17	17	17	17	17	17	17	0	0	32	32	32	32	32	32	32	32	32	32	32	32	32	32	32	0	0 ];
% bin1Data(2,:) = [  0	0	0	0	47	47	47	47	47	47	47	47	67	67	67	67	67	67	67	67	67	67	67	67	67	67	67	67	55	55	55	55	55	55	55	55	63	63	63	63	63	63	63	63	71	71	71	71	71	71	71	71	0	0	0	0	0	24	24	24	24	24	24	24	24	0	0	47	47	47	47	47	47	47	54	54	54	54	54	54	54	54	0	0 ];
% 
% bin2Label = [  0	0	0	0	0	0	0	0	0	0	0	0	5	5	5	5	5	5	5	5	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	0	0	0	0	0	0	0	0	0	0 ];
% bin2Data(1,:) = [	0	0	0	0	0	0	0	0	0	0	0	0	77	77	77	77	77	77	77	77	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	71	71	71	71	71	71	71	71	55	55	55	55	55	55	55	55	0	0	0	0	0	0	0	0	0	0 ];
% bin2Data(2,:) = [	0	0	0	0	0	0	0	0	0	0	0	0	84	84	84	84	84	84	84	84	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	84	84	84	84	84	84	84	84	84	84	84	84	84	84	84	84	0	0	0	0	0	0	0	0	0	0 ];
% 

labelBus = {bin1Label, bin2Label, bin3Label};
binBus = {bin1Data, bin2Data, bin3Data};

binsNumber = size(binBus, 2);
labelNumber = 6; %size(labelBus,2);

%output:
outputTable = zeros(labelNumber, 10);
%   1   2   3   4  5    6       7           8       9    10
% [Bin][Cx][Cy][W][H][Area][hCounter][vCounter][Accx][Accy]   

[rows, cols] = size(bin1Data);

dataTotal = cols;

areaCounter = 0;

currentLabel = 0;

vCounter = 0;

maxLabel = 0;

mergeTable = zeros(labelNumber, 4);
%   1       2       3          4
% [label][pastX1][pastX2][mergedLabel] 
mergeTable(:,1) = 1;

pastX1 = 0;
pastX2 = 0;
pastBin = 0;
pastLabel = 1;
mTableLabel = 0;
mergedLabel = 0;

mergeLabels = 0;

mergeLabel = 0;

mergeFinalX1 = 0;
mergeFinalX2 = 0;
mergeHeight = 0;

mergeCentroidX = 0;
mergeCentroidY = 0;

centroidX = 0;
centroidY = 0;
multiplyFactor1 = 0.5;
multiplyFactor2 = 1;
blobWidth = 0;
mergeWidth = 0;
mergeArea = 0;

%blob tracker information:
blobMeas = outputTable;
trueLabels = 0;
watch = 0;
ping = 0;
pong = 0;
pang = 0;

disp('Feature Extraction----');

t1 = tic;

for dataIndex = 1:dataTotal

    %pixel rows (vertical) counter:
    vCounter = vCounter + 1;
    
    t2 = tic;

    for binIndex = 1:binsNumber
        
        %debug data:
        currentLabel = labelBus{1, binIndex}(1,dataIndex);
        currentBin = binBus{1, binIndex};

        %Only if currentLabel is valid:
        if (currentLabel ~= 0) 
           
            t3 = tic;

            %update maximum number of labels:            
            if (currentLabel > maxLabel)
                maxLabel = currentLabel;
            end
            
            %store all blank pixels from top to  first detection
            % for Cy computation
            if (outputTable(currentLabel, 8) == 0)
                outputTable(currentLabel, 8) = vCounter;
            end
            
            x1 = currentBin(1, dataIndex);
            x2 = currentBin(2, dataIndex);
            
            
            %ID the object's current label:
            outputTable(currentLabel, 1) = currentLabel;
            
            %horizontal counter increments each time a run is encountered,
            %it is stored in the corresponding row inside OutputTable:
            hCounter = outputTable(currentLabel,7);
            hCounter = hCounter + 1;
            outputTable(currentLabel,7) = hCounter;

            %Cx1 & Cx2 Moving average past (current) stored values:
            currentCx1 = outputTable(currentLabel, 9);
            currentCx2 = outputTable(currentLabel, 10);
            
            %Blob Area
            areaCounter = (x2 - x1) + 1;
            outputTable(currentLabel, 6) = outputTable(currentLabel, 6) + areaCounter;
            
            %debug snip: if currentLabel == 3
            %    outputTable(currentLabel, 6)
            %end
            
            %Moving average computation:            
            if (hCounter > 1)
                outputTable(currentLabel, 9) =  currentCx1 + (x1 - currentCx1)/hCounter;
                outputTable(currentLabel, 10) =  currentCx2 + (x2 - currentCx2)/hCounter; 
            else
                outputTable(currentLabel, 9) = x1;
                outputTable(currentLabel, 10) = x2;
            end;

            pong = pong + toc(t3);
            
            % Corrector:
            % improves bin detection by merging broken blobs:
            
            t4 = tic;

            for correctorIndex = (binIndex - 1):-1:1

                mTableLabel = mergeTable(correctorIndex, 1);
                mergedLabel = mergeTable(correctorIndex, 4);

                if (currentLabel ~= mTableLabel) && (currentLabel ~= mergedLabel)

                    %request past data:
                    pastX1 = mergeTable(mTableLabel, 2);
                    pastX2 = mergeTable(mTableLabel, 3);

                    if x1 == pastX1
                        disp(['Seems like that point was already processed. x1: ' num2str(x1) ' past x1: ' num2str(pastX1)])
                        disp(['Mergin label ' num2str(currentLabel) ' with past label ' num2str(mTableLabel)]) 
                        mergeLabels = 1;
                    end

                    if x2 == pastX2
                        disp(['Seems like that point was already processed. x2: ' num2str(x2) ' past x2: ' num2str(pastX2)])
                        disp(['Mergin label ' num2str(currentLabel) ' with past label ' num2str(mTableLabel)]) 
                        mergeLabels = 1;
                    end
                    
                    %become ONE:
                    if mergeLabels                        
                        mergeTable(mTableLabel, 4) = currentLabel;
                        mergeTable(currentLabel, 4) = mTableLabel;
                        mergeLabels = 0;
                    end

                end

            end
            
            watch = watch + toc(t4);

            % analyzed data goes to buffer:    
            % store the label:
            mergeTable(binIndex, 1) = currentLabel;

            % store x1:
            mergeTable(binIndex, 2) = x1;

            % store x2:
            mergeTable(binIndex, 3) = x2;
            pastLabel = currentLabel;
            % end Corrector

                        
        end


    end
    
    %pang = toc;
    pang = pang + toc(t2);
end

disp('----------------------');
toc(t1)
toc1 = toc(t1);
disp('----------------------');
disp(['Measurements: ', num2str(pong)])
disp(['Corrector: ', num2str(watch)]);
disp(['Meas-Correct Loop: ', num2str(pang)]);
disp('----------------------');
disp('Final Measurements----');
tic
%final measurements
for labelIndex = 1:maxLabel   

    %final centroid
    finalX1 = outputTable(labelIndex, 9);
    finalX2 = outputTable(labelIndex, 10);

    %'height' data:
    blobHeight = outputTable(labelIndex,7);

    %centroid on X:
    outputTable(labelIndex, 2) = 0.5 * (finalX1 + finalX2);

    %centroid on Y:
    outputTable(labelIndex, 3) = outputTable(labelIndex, 8) + (blobHeight * 0.5);
    
    %blob (average) width:
    outputTable(labelIndex, 4) = (finalX2 - finalX1) + 1;
    
    %blob height:
    outputTable(labelIndex, 5) = blobHeight;
    
    %fprintf(1,'Labl     Cx       Cy       W        H        A\n');
    %fprintf(1,'#%2d %8.1f %8.1f %8.1f %8.1f %8.1f\n', ceil(outputTable(labelIndex, 1)), ceil(outputTable(labelIndex, 2)), ceil(outputTable(labelIndex, 3)), ceil(outputTable(labelIndex, 4)), ceil(outputTable(labelIndex, 5)), outputTable(labelIndex, 6));    
end

toc
toc2 = toc;
disp('----------------------');

disp('Corection-------------');
tic
%merge labels:
for labelIndex = 1:maxLabel

    %retrive table label:
    sourceLabel = outputTable(labelIndex,1);

    if sourceLabel ~= 0
        trueLabels = trueLabels + 1;
        %merge blob, if any:
        mergeLabel = mergeTable(labelIndex, 4);       
       
        if mergeLabel ~= 0
            
            disp(['merged labels: ' num2str(labelIndex) ' with ' num2str(mergeLabel)])
            %merge x centroid:       
            mergeFinalX1 = outputTable(mergeLabel, 9);
            mergeFinalX2 = outputTable(mergeLabel, 10); 

            mergeCentroidX = mergeFinalX1 + mergeFinalX2;

            mergeWidth = mergeFinalX2 - mergeFinalX1;

            mergeHeight = outputTable(mergeLabel,7);
            mergeArea = outputTable(mergeLabel,6);

            multiplyFactor1 = 0.25;
            multiplyFactor2 = 0.5;   

            %merged entry is removed:    
            outputTable(mergeLabel, 1) = 0;
        end
        
        %final measurements table:
        blobMeas(labelIndex, 1) = sourceLabel;

        %final centroid
        finalX1 = outputTable(labelIndex, 9);
        finalX2 = outputTable(labelIndex, 10); 

        %'height' data:
        blobHeight = multiplyFactor2 * (outputTable(labelIndex,7) + mergeHeight); 

        %centroid on X:
        centroidX = finalX1 + finalX2;
        outputTable(labelIndex, 2) = multiplyFactor1 * (centroidX + mergeCentroidX);
        blobMeas(labelIndex, 2) = outputTable(labelIndex, 2);
        
        %centroid on Y:
        centroidY = outputTable(labelIndex, 8) + (blobHeight * 0.5);
        outputTable(labelIndex, 3) =  centroidY;% + mergeCentroidY;
        blobMeas(labelIndex, 3) = outputTable(labelIndex, 3);
        
        %blob (average) width:
        blobWidth = finalX2 - finalX1;
        outputTable(labelIndex, 4) = multiplyFactor2 * (blobWidth + mergeWidth) + 1;
        blobMeas(labelIndex, 4) = outputTable(labelIndex, 4);
        
        %blob height:
        outputTable(labelIndex, 5) = blobHeight;
        blobMeas(labelIndex, 5) = outputTable(labelIndex, 5);
        
        %area:
        blobArea = outputTable(labelIndex, 6);
        outputTable(labelIndex, 6) = blobArea + mergeArea;
        blobMeas(labelIndex, 6) = outputTable(labelIndex, 6);
        
        fprintf(1,'Labl     Cx       Cy       W        H        A\n');
        fprintf(1,'#%2d %8.1f %8.1f %8.1f %8.1f %8.1f\n', ceil(outputTable(labelIndex, 1)), ceil(outputTable(labelIndex, 2)), ceil(outputTable(labelIndex, 3)), ceil(outputTable(labelIndex, 4)), ceil(outputTable(labelIndex, 5)), outputTable(labelIndex, 6));

        %reset variables:
        mergeFinalX1 = 0;
        mergeFinalX2 = 0;
        mergeCentroidX = 0; 
        mergeHeight = 0;
        mergeWidth = 0;
        multiplyFactor1 = 0.5;
        multiplyFactor2 = 1;
        mergeArea = 0; 

    end

end
disp(['Total Blobs: ' num2str(trueLabels)])
toc
toc3 = toc;
disp('----------------------');

disp(['Total execution time: ' num2str((toc1+toc2+toc3)*1000) ' ms']);

%End of frame, reset all variables to default values


