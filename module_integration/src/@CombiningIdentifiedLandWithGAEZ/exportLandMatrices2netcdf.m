function exportLandMatrices2netcdf( obj )
%EXPORTLANDMATRICES2NETCDF Summary of this function goes here
%   Detailed explanation goes here

lon = obj.identifiedLand_longitudeVector_centered;
lat = obj.identifiedLand_latitudeVector_centered;

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
filename = ['Output/identified_land_' timestamp '.nc'];

if exist(filename) == 2
    delete(filename)
end

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

nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'description', 'standard_name', 'description')
ncwriteatt(filename, 'description', 'long_name', 'description')

nccreate(filename,'identified_land_fractions_of_cell','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_fractions_of_cell', 'standard_name', 'identified_land_fractions_of_cell');
ncwriteatt(filename, 'identified_land_fractions_of_cell', 'long_name', 'identified_land_fractions_of_cell');
ncwriteatt(filename, 'identified_land_fractions_of_cell', 'units', '');
ncwriteatt(filename, 'identified_land_fractions_of_cell', 'missing_value', '-999');

nccreate(filename,'identified_land_hectare','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_hectare', 'standard_name', 'identified_land_hectare');
ncwriteatt(filename, 'identified_land_hectare', 'long_name', 'identified_land_hectare');
ncwriteatt(filename, 'identified_land_hectare', 'units', 'hectare');
ncwriteatt(filename, 'identified_land_hectare', 'missing_value', '-999');

nccreate(filename,'identified_land_fractions_of_cell_biodiversity_hotspots_excluded','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_fractions_of_cell_biodiversity_hotspots_excluded', 'standard_name', 'identified_land_fractions_of_cell_biodiversity_hotspots_excluded');
ncwriteatt(filename, 'identified_land_fractions_of_cell_biodiversity_hotspots_excluded', 'long_name', 'identified_land_fractions_of_cell_biodiversity_hotspots_excluded');
ncwriteatt(filename, 'identified_land_fractions_of_cell_biodiversity_hotspots_excluded', 'units', '');
ncwriteatt(filename, 'identified_land_fractions_of_cell_biodiversity_hotspots_excluded', 'missing_value', '-999');

nccreate(filename,'identified_land_hectare_biodiversity_hotspots_excluded','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_hectare_biodiversity_hotspots_excluded', 'standard_name', 'identified_land_hectare');
ncwriteatt(filename, 'identified_land_hectare_biodiversity_hotspots_excluded', 'long_name', 'identified_land_hectare');
ncwriteatt(filename, 'identified_land_hectare_biodiversity_hotspots_excluded', 'units', 'hectare');
ncwriteatt(filename, 'identified_land_hectare_biodiversity_hotspots_excluded', 'missing_value', '-999');

nccreate(filename,'biodiversity_hotspots_fractions','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'biodiversity_hotspots_fractions', 'standard_name', 'biodiversity_hotspots_fractions');
ncwriteatt(filename, 'biodiversity_hotspots_fractions', 'long_name', 'biodiversity_hotspots_fractions');
ncwriteatt(filename, 'biodiversity_hotspots_fractions', 'units', 'hectare');
ncwriteatt(filename, 'biodiversity_hotspots_fractions', 'missing_value', '-999');

ncwrite(filename, 'lat', obj.identifiedLand_latitudeVector_centered);
ncwrite(filename, 'lon', obj.identifiedLand_longitudeVector_centered);
ncwrite(filename, 'description', 'Dataset describing abandoned cropland from 1992-2015 based on ESA CCI-LC data.')
ncwrite(filename, 'identified_land_fractions_of_cell', obj.identifiedLandMatrix_fractionOfCell);
ncwrite(filename, 'identified_land_hectare', obj.identifiedLandMatrix_hectares);
ncwrite(filename, 'identified_land_fractions_of_cell_biodiversity_hotspots_excluded',obj.identifiedLandMatrix_excludingBiodiversityHotspots_fractions);
ncwrite(filename, 'identified_land_hectare_biodiversity_hotspots_excluded', obj.identifiedLandMatrix_excludingBiodiversityHotspots_hectares);
ncwrite(filename, 'biodiversity_hotspots_fractions', obj.biodiversityHotspots_fractions);

end

