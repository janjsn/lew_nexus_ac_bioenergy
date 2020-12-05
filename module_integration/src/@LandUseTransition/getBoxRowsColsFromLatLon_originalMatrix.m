function [ rows_lon, cols_lat ] = getBoxRowsColsFromLatLon_originalMatrix(  obj, latitude_N_deg, latitude_S_deg, longitude_W_deg, longitude_E_deg )
        
%GETBOXROWSCOLSFROMLATLON_ORIGINALMATRIX Summary of this function goes here
%   Detailed explanation goes here


%% Find lat/lon borders
for i = 1:length(obj.latitudeVector_original)
    if obj.latitudeVector_original(i) > latitude_N_deg
        pos_lat_north = i; %Most north
    end
    
    if obj.latitudeVector_original(i) > latitude_S_deg
        pos_lat_south = i+1; %most south
    end
    
    
end

for i = 1:length(obj.longitudeVector_original)
    if obj.longitudeVector_original(i) < longitude_W_deg
        pos_lon_west = i; %most west
    end
    if obj.longitudeVector_original(i) < longitude_E_deg
        pos_lon_east = i+1; %most east
    end
end

rows_lon = [pos_lon_west pos_lon_east];
cols_lat = [pos_lat_north pos_lat_south];

end

