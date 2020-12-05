classdef WaterScarcity_data
    %WATERSCARCITY_DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dataMatrix_raw
        latitudeLimits_raw
        longitudeLimits_raw
        dataMatrix_global
        %Rest here are global
        latitudeLimits
        longitudeLimits
        latitudeVector_centered
        longitudeVector_centered
        cellExtent_latitude
        cellExtent_longitude
        angleUnit %string
        columnsStartFrom %string
        rowsStartFrom %string
        rasterExtent_longitude
        rasterExtent_latitude
        coordinateSystemType
        waterClass_ID = 0;
        lowWaterScarcity_ID = 1;
        moderateWaterScarcity_ID = 2;
        highWaterScarcity_ID = 3;
        veryHighWaterScarcity_ID = 4;
        waterScarcityIsLowMatrix_binary
        
    end
    
    methods
        
        
        %Constructor
        function obj = WaterScarcity_data(matrix, DataInformation_GeographicCellsReference)
            obj.dataMatrix_raw = matrix;
            %matrix_raw_lonLat = matrix';
            lonStep_raw = DataInformation_GeographicCellsReference.CellExtentInLongitude;
            latStep_raw = DataInformation_GeographicCellsReference.CellExtentInLatitude;
            longitudeVector_raw = [DataInformation_GeographicCellsReference.LongitudeLimits(1)+lonStep_raw/2:lonStep_raw:DataInformation_GeographicCellsReference.LongitudeLimits(2)-lonStep_raw/2];
            latitudeVector_raw = [DataInformation_GeographicCellsReference.LatitudeLimits(2)-latStep_raw/2:-latStep_raw:DataInformation_GeographicCellsReference.LatitudeLimits(1)+latStep_raw/2];
            
            matrix(isnan(matrix)) = 0;
            
            dataMatrix_global = zeros(4320,2160);
            
            longitudeVector_global = [-180+lonStep_raw/2:lonStep_raw:180-lonStep_raw/2];
            latitudeVector_global = [90-latStep_raw/2:-latStep_raw:-90+latStep_raw/2];
            
            %%Distributing to global matrix
            
            %finding pos
            globalPos_rawLongitudeVector(length(longitudeVector_raw))=0;
            globalPos_rawLatitudeVector(length(latitudeVector_raw))=0;
            %lon
            for i = 1:length(longitudeVector_raw)
                globalPos_rawLongitudeVector(i) = 0;
                for j = 1:length(longitudeVector_global)
                    if abs(longitudeVector_raw(i)-longitudeVector_global(j)) < lonStep_raw/2
                        globalPos_rawLongitudeVector(i) = j;
                        break
                    elseif abs(longitudeVector_global(j)-longitudeVector_raw(i)) < lonStep_raw/2
                        globalPos_rawLongitudeVector(i) = j;
                        break
                    end
                end  
            end
            %lat
            for i = 1:length(latitudeVector_raw)
                globalPos_rawLatitudeVector(i) = 0;
                for j = 1:length(latitudeVector_global)
                    if abs(latitudeVector_raw(i)-latitudeVector_global(j)) < latStep_raw/2
                        globalPos_rawLatitudeVector(i) = j;
                        break
                    elseif abs(latitudeVector_global(j)-latitudeVector_raw(i)) < latStep_raw/2
                        globalPos_rawLatitudeVector(i) = j;
                        break
                    end
                end  
            end
            
            
            mSize = size(matrix);
            for i = 1:mSize(1)
                for j = 1:mSize(2)

                    %Assigning value
                    dataMatrix_global(globalPos_rawLongitudeVector(j), globalPos_rawLatitudeVector(i)) = matrix(i,j);
                    
                end
            end
            obj.dataMatrix_global = dataMatrix_global;
            %nans_logical = isnan(matrix_raw_lonLat);
            %matrix_raw_lonLat(nans_logical) = 0;
            obj.cellExtent_latitude = DataInformation_GeographicCellsReference.CellExtentInLatitude;
            obj.cellExtent_longitude = DataInformation_GeographicCellsReference.CellExtentInLongitude;
            obj.angleUnit = DataInformation_GeographicCellsReference.AngleUnit;
            obj.columnsStartFrom = 'west';
            obj.rowsStartFrom = 'north';
            obj.rasterExtent_latitude = [90 -90];
            obj.rasterExtent_longitude = [-180 180];
            obj.coordinateSystemType = DataInformation_GeographicCellsReference.CoordinateSystemType;
            obj.latitudeVector_centered = latitudeVector_global;
            obj.longitudeVector_centered = longitudeVector_global;
            obj.waterScarcityIsLowMatrix_binary = obj.getWaterScarcityIsLowMatrix_binary();
            
            fprintf('Water scarcity data was imported. \n');
            
        end
        
        %Get water scarcity is low matrix
        function waterScarcityIsLowMatrix_binary = getWaterScarcityIsLowMatrix_binary(obj)
            mSize = size(obj.dataMatrix_global);
            waterScarcityIsLowMatrix_binary = zeros(mSize(1), mSize(2));
            waterScarcityIsLowMatrix_binary(obj.dataMatrix_global == obj.lowWaterScarcity_ID) = 1;
        end
    end
end


