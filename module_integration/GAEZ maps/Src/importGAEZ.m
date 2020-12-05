function [ GAEZ_dataArray ] = importGAEZ( GAEZ_fileArray )
%IMPORTGAEZ Reads GAEZ files (asc format).
%   Input: GAEZ_fileArrray of class GAEZ_files
% Output: Gaez data array.

GAEZ_dataArray(length(GAEZ_fileArray)) = GAEZ_data;

ID_counter = 1;

for j = 1:length(GAEZ_fileArray)
    if GAEZ_fileArray(j).isAscFile == 1
        [Matrix,DataInformation] = arcgridread(GAEZ_fileArray(j).filename, 'geographic');
        
        mSize = DataInformation.RasterSize;
        longitudeVector_leftCorner(mSize(2)) = 0;
        latitudeVector_upperCorner(mSize(1)) = 0;
        
        %If sentences here? Or are data ok?
        longitudeVector_leftCorner(1) = DataInformation.LongitudeLimits(1);
        latitudeVector_upperCorner(1) = DataInformation.LatitudeLimits(2);
        
        cellExtent_latitude = DataInformation.RasterExtentInLatitude/mSize(1);
        cellExtent_longitude = DataInformation.RasterExtentInLongitude/mSize(2);
        
        
        for i = 2:mSize(2)
            longitudeVector_leftCorner(i) = longitudeVector_leftCorner(i-1)+cellExtent_longitude;
        end
        for i = 2:mSize(1)
            latitudeVector_upperCorner(i) = latitudeVector_upperCorner(i-1)-cellExtent_latitude;
        end
        
        %% Saving to GAEZ_data class
        newData = GAEZ_data;
        
        newData.dataMatrix_raw = Matrix;
        newData.latitudeVector_upperCorner = latitudeVector_upperCorner;
        newData.longitudeVector_leftCorner = longitudeVector_leftCorner;
        newData.cellExtent_latitude = cellExtent_latitude;
        newData.cellExtent_longitude = cellExtent_longitude;
        newData.latitudeLimits = DataInformation.LatitudeLimits;
        newData.longitudeLimits = DataInformation.LongitudeLimits;
        newData.angleUnit = DataInformation.AngleUnit; %string
        newData.columnStartFrom = DataInformation.ColumnsStartFrom; %string
        newData.rowsStartFrom = DataInformation.RowsStartFrom; %string
        newData.rasterExtent_longitude = DataInformation.RasterExtentInLongitude;
        newData.rasterExtent_latitude = DataInformation.RasterExtentInLatitude;
        newData.coordinateSystemType = DataInformation.CoordinateSystemType; %string
        newData.multiplicationFactor = GAEZ_fileArray(j).multiplicationFactor;
        newData.cropname = GAEZ_fileArray(j).cropname;
        newData.isTifData = 0;
        newData.isAscData= 1;
        
        if isnan(GAEZ_fileArray(j).filename_waterDeficit)
            newData.waterDeficitDataIsGiven_binary = 0;
        else
            newData.waterDeficitDataIsGiven_binary =1;
            if strcmp(GAEZ_fileArray(j).filename_waterDeficit(end-3:end),'.asc')
                newData.waterDeficitMatrix_mm = importWaterDeficitData_asc(GAEZ_fileArray(j).filename_waterDeficit);
            elseif strcmp(GAEZ_fileArray(j).filename_waterDeficit(end-3:end),'.tif')
                newData.waterDeficitMatrix_mm = importWaterDeficitData_tif( GAEZ_fileArray(j).filename_waterDeficit );
            end
        end
        
        newData.cropID = GAEZ_fileArray(j).cropID;
        newData.inputID_unique = GAEZ_fileArray(j).uniqueID;
        newData.year = GAEZ_fileArray(j).year;
        newData.climateScenarioID = GAEZ_fileArray(j).climateScenario_ID;
        newData.isIrrigated = GAEZ_fileArray(j).isIrrigated_binary;
        newData.isRainfed = GAEZ_fileArray(j).isRainfed;
        newData.isConsideringCO2Fertilization  = GAEZ_fileArray(j).considersCO2Fertilization_binary;
        newData.inputRate = GAEZ_fileArray(j).inputRate;
        
        newData.ID = ID_counter;
        ID_counter = ID_counter+1;
        
        dataMatrix_estimated_sameLatLonSteps = newData.dataMatrix_raw*newData.multiplicationFactor;
        
        
        %% Cleaning datapoints showing negative yield
        mSize = size(dataMatrix_estimated_sameLatLonSteps);
        nNegativeCases = 0;
        
        for i = 1:mSize(1)
            for k = 1:mSize(2)
                if dataMatrix_estimated_sameLatLonSteps(i,k) < 0
                    dataMatrix_estimated_sameLatLonSteps(i,k) = 0;
                    nNegativeCases = nNegativeCases + 1;
                end
            end
        end
        
        newData.dataMatrix_estimated_sameLatLonSteps = dataMatrix_estimated_sameLatLonSteps;
        
        GAEZ_dataArray(j) = newData;
        
    elseif GAEZ_fileArray(j).isTifFile == 1
        %bugfix
        
        
        if exist(GAEZ_fileArray(j).filename)
            matrix_tif = imread(GAEZ_fileArray(j).filename);
        elseif exist(GAEZ_fileArray(j).filename(2:end))
            GAEZ_fileArray(j).filename = GAEZ_fileArray(j).filename(2:end);
            stringFile = GAEZ_fileArray(j).filename(1:end);
            matrix_tif = imread(stringFile);
        end
        
        %TEMP BUGFIX
        mSize = size(matrix_tif);
        matrix_tif(matrix_tif<0) = 0;
        newData = GAEZ_data;
        newData.cellExtent_latitude = 180/mSize(1);
        newData.cellExtent_longitude = 360/mSize(2);
        newData.latitudeLimits = [90 -90];
        newData.longitudeLimits = [-180 180];
        newData.rasterExtent_longitude = 360;
        newData.rasterExtent_latitude = 180;
        newData.isTifData = 1;
        newData.isAscData = 0;
        newData.coordinateSystemType = 'geographic';
        newData.rowsStartFrom = 'west';
        newData.columnStartFrom = 'north';
        newData.angleUnit = 'degree';
        newData.dataMatrix_raw = matrix_tif;
        newData.latitudeVector_upperCorner = [90: -newData.cellExtent_latitude:-90];
        newData.latitudeVector_upperCorner = newData.latitudeVector_upperCorner(1:end-1);
        newData.longitudeVector_leftCorner = [-180:newData.cellExtent_longitude:180];
        newData.longitudeVector_leftCorner = newData.longitudeVector_leftCorner(1:end-1);
        newData.multiplicationFactor = GAEZ_fileArray(j).multiplicationFactor;
        newData.cropname = GAEZ_fileArray(j).cropname;
        
        if isnan(GAEZ_fileArray(j).filename_waterDeficit)
            newData.waterDeficitDataIsGiven_binary = 0;
        else
            newData.waterDeficitDataIsGiven_binary =1;
            if strcmp(GAEZ_fileArray(j).filename_waterDeficit(end-3:end),'.asc')
                newData.waterDeficitMatrix_mm = importWaterDeficitData_asc(GAEZ_fileArray(j).filename_waterDeficit);
                
            elseif strcmp(GAEZ_fileArray(j).filename_waterDeficit(end-3:end),'.tif')
                newData.waterDeficitMatrix_mm = importWaterDeficitData_tif( GAEZ_fileArray(j).filename_waterDeficit );
            else
                fprintf(GAEZ_fileArray(j).filename_waterDeficit(end-3:end))
                fprintf('\n')
            end
            
            %newData.waterDeficitMatrix_mm = importWaterDeficitData_tif( GAEZ_fileArray(j).filename_waterDeficit );
        end
        %size(newData.waterDeficitMatrix_mm)
        newData.cropID = GAEZ_fileArray(j).cropID;
        newData.inputID_unique = GAEZ_fileArray(j).uniqueID;
        newData.year = GAEZ_fileArray(j).year;
        newData.climateScenarioID = GAEZ_fileArray(j).climateScenario_ID;
        newData.isIrrigated = GAEZ_fileArray(j).isIrrigated_binary;
        newData.isRainfed = GAEZ_fileArray(j).isRainfed_binary;
        newData.isConsideringCO2Fertilization  = GAEZ_fileArray(j).considersCO2Fertilization_binary;
        newData.inputRate = GAEZ_fileArray(j).inputRate;
        
        newData.ID = ID_counter;
        ID_counter = ID_counter+1;
        
        newData.dataMatrix_lonXlat_multiplicationFactorAccounted = double(newData.dataMatrix_raw)'*newData.multiplicationFactor; %Transpose and multiply with factor.
        
        GAEZ_dataArray(j) = newData;
    end %if filetypes
    
    GAEZ_dataArray(j) = GAEZ_dataArray(j).generateAreaPerLongitudeVector;
    
    %Centered lon/lat vectors
    lat_step = 180/length(GAEZ_dataArray(j).latitudeVector_upperCorner);
    lon_step = 360/length(GAEZ_dataArray(j).longitudeVector_leftCorner);
    
    GAEZ_dataArray(j).latitudeVector_centered = [90-(lat_step/2):-lat_step:-90+(lat_step/2)];
    GAEZ_dataArray(j).longitudeVector_centered = [-180+(lon_step/2):lon_step:180-(lon_step/2)];
    
end %for j = fileArray

fprintf('Finished importing GAEZ crop data. \n');
end %function

