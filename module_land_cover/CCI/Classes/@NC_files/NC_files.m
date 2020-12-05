classdef NC_files
    %NC_FILES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        year
        filename
        landCoverMatrix_lucc
        latitudeVector
        longitudeVector
        areaPerLatitudeVector
        %importGivenData_binary
    end
    
    methods
        obj = importDataFromFile(obj)
            
        [latitude, longitude] = getLatitudeLongitudeFromLinearIndex(obj, linearIndex);    
        
    end
    
end

