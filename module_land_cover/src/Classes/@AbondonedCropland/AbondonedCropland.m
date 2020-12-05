classdef AbondonedCropland
    %ABONDONEDCROPLAND Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CCI_row
        CCI_column
        CCI_latitude
        CCI_longitude
        CCI_area_m2
        bioenergyCropYield
        bioenergyCropName
        bioenergyCrop_ID
        
    end
    
    methods
        
        function obj = AbondonedCropland(CCI_row, CCI_column, CCI_latitude, CCI_longitude, CCI_area_m2, bioenergyCropYield, bioenergyCropName, bionenergyCrop_ID)
            obj.CCI_row = CCI_row;
            obj.CCI_column = CCI_column;
            obj.CCI_latitude = CCI_latitude;
            obj.CCI_longitude = CCI_longitude;
            obj.CCI_area_m2 = CCI_area_m2;
            obj.bioenergyCropYield = bioenergyCropYield;
            obj.bioenergyCropName = bioenergyCropName;
            obj.bioenergyCrop_ID = obj.bioenergyCrop_ID;
        end
        
    end
    
end

