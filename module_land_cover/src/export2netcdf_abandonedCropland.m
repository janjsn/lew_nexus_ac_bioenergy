function  export2netcdf_abandonedCropland( file_description,  abandoned_croplands_hectare, lat, lon  )
%EXPORT2NETCDF_ABANDONEDCROPLAND Summary of this function goes here
%   Detailed explanation goes here

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
fractionsMatrix = zeros(length(lon), length(lat));
areaPerLatitude = zeros(1,length(lat));

Earth = referenceSphere('earth','m');
surfaceArea_hectare = Earth.SurfaceArea/10000;

delta_lat = 180/length(lat);
latitudeBounds = zeros(2,length(lat));
latitudeBounds(1,:) = [90:-delta_lat:-90+delta_lat];
latitudeBounds(2,:) = [90-delta_lat:-delta_lat:-90];

for i = 1:length(lat)
    areaPerLatitude(i) =  areaquad(latitudeBounds(1,i),lon(1),latitudeBounds(2,i),lon(2))*surfaceArea_hectare;
    fractionsMatrix(:,i) = abandoned_croplands_hectare(:,i)/areaPerLatitude(i);
end

filename = ['Output/' file_description timestamp '.nc'];

nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees_north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename, 'lat', 'axis', 'Y'); %ADDED 1306

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X'); %ADDED 1306

nccreate(filename, 'cell_area_per_latitude', 'Dimensions', {'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cell_area_per_latitude', 'standard_name', 'cell_area_per_latitude');
ncwriteatt(filename, 'cell_area_per_latitude', 'long_name', 'cell_area_per_latitude');
ncwriteatt(filename, 'cell_area_per_latitude', 'units', 'hectare cell-1');
ncwriteatt(filename, 'cell_area_per_latitude', 'missing_value', '-999');

nccreate(filename, 'abandoned_cropland_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_hectare', 'standard_name', 'abandoned_cropland_hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'long_name', 'abandoned_cropland_hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'units', 'hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'missing_value', '-999');

nccreate(filename, 'abandoned_cropland_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_fractions', 'standard_name', 'abandoned_cropland_fractions');
ncwriteatt(filename, 'abandoned_cropland_fractions', 'long_name', 'abandoned_cropland_fractions');
ncwriteatt(filename, 'abandoned_cropland_fractions', 'units', '-');
ncwriteatt(filename, 'abandoned_cropland_fractions', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'cell_area_per_latitude', areaPerLatitude);
ncwrite(filename, 'abandoned_cropland_hectare', abandoned_croplands_hectare);
ncwrite(filename, 'abandoned_cropland_fractions', fractionsMatrix);
end

