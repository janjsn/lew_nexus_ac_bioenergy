function makeNcFile_latlon(filename, Matrix,lat,lon)
%Makes an nc file for using a given matrix, latitude vector and longitude vector.

%Matrix must have dimensions (latitude,longitude).
%lon is Longitude vector, same length as rows in Matrix.
%lat is Latitude vector, same length as columns in Matrix

%Example filename: 'myfile.nc'

if exist(filename) == 2
delete(filename)
end

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

nccreate(filename,'Matrix','Dimensions',{'lon' length(lon) 'lat' length(lat)});
ncwriteatt(filename, 'Matrix', 'standard_name', 'fractions available land');
ncwriteatt(filename, 'Matrix', 'long_name', 'Fractions available land per lat lon');
ncwriteatt(filename, 'Matrix', 'units', '');
ncwriteatt(filename, 'Matrix', 'missing_value', '-999');

ncwrite(filename,'lat',lat);
ncwrite(filename,'lon',lon);
ncwrite(filename, 'Matrix', Matrix);

end

%'datatype','double',