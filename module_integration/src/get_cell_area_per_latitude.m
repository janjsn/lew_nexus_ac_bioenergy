function [ areaPerLatitude_hectare ] = get_cell_area_per_latitude( latitude_bounds, cell_extent_in_longitude)
%GET_CELL_AREA_PER_LATITUDE Summary of this function goes here
%   Detailed explanation goes here
            Earth = referenceSphere('earth','m');
            surfaceArea_hectare = Earth.SurfaceArea/10000;
            
            size_lat_bnds = size(latitude_bounds);
            areaPerLatitude_hectare = zeros(1,size_lat_bnds(2));
    
            for i = 1:length(areaPerLatitude_hectare )
                areaPerLatitude_hectare(i) =  areaquad(latitude_bounds(1,i),0,latitude_bounds(2,i),cell_extent_in_longitude)*surfaceArea_hectare;
            end

            
            
end

