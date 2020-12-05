function [ nitrogen_use_grid, phosphorus_use_grid ] = getGriddedFertilizerUse( filename_nitrogen, filename_phosphorus )
%GETGRIDDEDFERTILIZERUSE Summary of this function goes here
%   Detailed explanation goes here

[N_raw, N_ref] = geotiffread(filename_nitrogen);
[P_raw, P_ref] = geotiffread(filename_phosphorus);

lat_step = N_ref.CellExtentInLatitude;
lon_step = N_ref.CellExtentInLongitude;

lat_raw = [N_ref.LatitudeLimits(2)-lat_step/2:-lat_step:N_ref.LatitudeLimits(1)+lat_step/2];
lon_raw = [N_ref.LongitudeLimits(1)+lon_step/2:lon_step:N_ref.LongitudeLimits(2)-lon_step/2];

%prealloc
nitrogen_use_grid = zeros(4320,2160);
phosphorus_use_grid = zeros(4320,2160);

lat_step_new = 2160/180;
lon_step_new = 4320/360;

lat = [90-lat_step_new/2:-lat_step_new:-90+lat_step_new/2];
lon = [-180+lon_step_new/2:lon_step_new:180-lon_step_new/2];

for lats = 1:length(lat)
    for lons = 1:length(lon)
        
        
    end
end





end

