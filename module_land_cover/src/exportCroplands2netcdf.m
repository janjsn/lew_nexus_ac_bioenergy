function  exportCroplands2netcdf( file_description,  croplands_hectare, lat, lon )
%EXPORTCROPLANDS2NETCDF Summary of this function goes here
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
    fractionsMatrix(:,i) = croplands_hectare(:,i)/areaPerLatitude(i);
end

sum(sum(areaPerLatitude*length(lon)))

filename = [file_description timestamp '.nc'];

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

nccreate(filename, 'cropland_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_hectare', 'standard_name', 'cropland_hectare');
ncwriteatt(filename, 'cropland_hectare', 'long_name', 'cropland_hectare');
ncwriteatt(filename, 'cropland_hectare', 'units', 'hectare');
ncwriteatt(filename, 'cropland_hectare', 'missing_value', '-999');

nccreate(filename, 'cropland_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropland_fractions', 'standard_name', 'cropland_fractions');
ncwriteatt(filename, 'cropland_fractions', 'long_name', 'cropland_fractions');
ncwriteatt(filename, 'cropland_fractions', 'units', '-');
ncwriteatt(filename, 'cropland_fractions', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'cell_area_per_latitude', areaPerLatitude);
ncwrite(filename, 'cropland_hectare', croplands_hectare);
ncwrite(filename, 'cropland_fractions', fractionsMatrix);



end

