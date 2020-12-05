%Test script for land use changes fraction matrix aggregation

addpath(genpath(pwd()));

%Aggregate to these dimensions:
newNumberOfRows = 4320;
newNumberOfCols = 2160;

% fprintf('Loading some data.. \n')
% tic
% load('InputData/landUseChanges_fractionMatrix_129600_64800.mat');
% toc
% fprintf('Finished loading data. \n')

%% THE TWO LINES NEEDED FOR AGGREGATION
%Generating object using the matrix "test1" and lat/lon vectors
myTransition_gaezSize = LandUseTransition(test1, latitudeVector, longitudeVector);
%Aggregating, new rows and cols divided by old must be equal to a positive integer
myTransition_gaezSize = myTransition_gaezSize.aggregateOriginalMatrix(newNumberOfRows,newNumberOfCols);



%Show new object in command line
myTransition_gaezSize

%Write nc file to Output folder
filename = 'Output/myTransition_gaezSize.nc';
myTransition_gaezSize.makeNcFile_newAggregatedResults(filename);
fprintf('Results written to: "');
fprintf(filename);
fprintf('" \n');
