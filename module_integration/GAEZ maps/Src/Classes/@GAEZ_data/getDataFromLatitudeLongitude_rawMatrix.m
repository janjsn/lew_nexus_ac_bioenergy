function [ data ] = getDataFromLatitudeLongitude_rawMatrix( obj, latitude, longitude )
%GETDATAFROMLATITUDELONGITUDE_RAWMATRIX Summary of this function goes here
%   Detailed explanation goes here
    mSize = size(obj.dataMatrix_raw);
            
            
            %% Finding latitude posiiton in matrix
            latPos = 0;
            for i = 2:length(obj.latitudeVector_upperCorner)
               if obj.latitudeVector_upperCorner(i-1) >= latitude && obj.latitudeVector_upperCorner(i) < latitude
                   latPos = i-1;
               end 
            end
            
            %Checking if it wasn't in range or is the last element
            if latPos == 0
                if (obj.latitudeVector_upperCorner(i) + obj.cellExtent_latitude) > latitude
                    latPos = i;
                    
                end
                
                if latPos == 0
                    data = 0;
                    if latitude > 90 || latitude < -90
                        error('Not a valid latitude given in input.')  %Not in range
                    end
                end
            end
            
            %% Finding longitude position in matrix
            lonPos = 0;
            
            for i = 2:length(obj.longitudeVector_leftCorner)
                if obj.longitudeVector_leftCorner(i-1) <= longitude && obj.longitudeVector_leftCorner(i) > longitude
                   lonPos = i-1; 
                end
                
            end
            
            %Checking if it wasn't in range or is the last element
            if lonPos == 0
                if (obj.longitudeVector_upperCorner(i) + obj.cellExtent_longitude) > longitude
                    lonPos = i;
                    
                end
                
                if lonPos == 0
                    data = 0;
                    if longitude > 180 || longitude < -180
                        error('Not a valid latitude given in input.')  %Not in range
                    end
                end
            end
            
        %% Finding given data
        data = obj.dataMatrix_raw(latPos,lonPos);
            
        if isnan(data) || data < 0
            data = 0;
        end
            

end

