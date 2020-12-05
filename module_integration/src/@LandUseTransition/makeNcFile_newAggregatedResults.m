function makeNcFile_newAggregatedResults(obj, filename)
%Makes an nc file for using a given matrix, latitude vector and longitude vector.

%Matrix must have dimensions (latitude,longitude).
%lon is Longitude vector, same length as rows in Matrix.
%lat is Latitude vector, same length as columns in Matrix

%Example filename: 'myfile.nc'

if exist(filename) == 2
delete(filename)
end

lat = obj.latitudeVector_newAggregated;
lon = obj.longitudeVector_newAggregated;

nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees north');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');

nccreate(filename,'Matrix_fractions','Dimensions',{'lon' length(lon) 'lat' length(lat)});
ncwriteatt(filename, 'Matrix_fractions', 'standard_name', 'fractions available land');
ncwriteatt(filename, 'Matrix_fractions', 'long_name', 'Fractions available cropland per lat lon');
ncwriteatt(filename, 'Matrix_fractions', 'units', '');
ncwriteatt(filename, 'Matrix_fractions', 'missing_value', '-999');

nccreate(filename,'Matrix_m2','Dimensions',{'lon' length(lon) 'lat' length(lat)});
ncwriteatt(filename, 'Matrix_m2', 'standard_name', 'm^2 available land');
ncwriteatt(filename, 'Matrix_m2', 'long_name', 'm^2 available cropland per lat lon');
ncwriteatt(filename, 'Matrix_m2', 'units', '');
ncwriteatt(filename, 'Matrix_m2', 'missing_value', '-999');

ncwrite(filename,'lat',lat);
ncwrite(filename,'lon',lon);
ncwrite(filename, 'Matrix_fractions', obj.fractionMatrix_newAggregated);
ncwrite(filename, 'Matrix_m2', obj.areaMatrix_newAggregated_m2);


end

%'datatype','double',