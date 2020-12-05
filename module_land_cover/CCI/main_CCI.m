function [NC_fileArray, LandCoverClassArray ] = main_CCI()

%Adding all subfolders to path
addpath(genpath(pwd));

%Print
fprintf('------------------------------------- \n');
fprintf('CCI code started!! \n');
fprintf('------------------------------------- \n');

%fprintf('What do you want to do? \n')

LandCoverClassArray = importLandAreaClasses('Import nc files.xlsx', 'Land area classes');

fprintf('------------------------------------- \n');
fprintf('Now importing NETCDF files: \n')

NC_fileArray = readExcel_CCI('Import nc files.xlsx', 'Filenames');


%% IMPORTING ALL THE GIVEN NC FILES 
for i = 1:length(NC_fileArray)
   NC_fileArray(i) = NC_fileArray(i).importDataFromFile;
end

%% Finding global land changes
nYears = length(NC_fileArray);
nClasses = length(LandCoverClassArray);

%Preallocation
%landChanges_fromClass = zeros(nClasses,nClasses,nYears);
for j = 1:length(NC_fileArray)
    %Finding area per laatitude
    latitudeVector = NC_fileArray(j).latitudeVector;
    latitudeVector = double(latitudeVector);
    
    longitude1 = double(NC_fileArray(j).longitudeVector(1));
    longitude2 = double(NC_fileArray(j).longitudeVector(2));
    
    %Finding longtitude standard step, assuming equal steps.
    % longtitudeStep = NC_fileArray(1).longtitudeVector(2)-NC_fileArray(1).longtitudeVector(1);
    % if longtitudeStep < 0
    %    longtitudeStep = -longtitudeStep;
    % end
    
    
    
    %Estimating area per latitude step as vector
    areaPerLatitudeVector = 0;
    areaPerLatitudeVector(length(latitudeVector)) = 0; %prealloc
    
    %Calculating area per quadrangle
    for i = 2:length(areaPerLatitudeVector)
        areaPerLatitudeVector(i-1) = areaquad(latitudeVector(i-1),longitude1,latitudeVector(i),longitude2);
    end
    NC_fileArray(j).areaPerLatitudeVector = areaPerLatitudeVector;
end


end
