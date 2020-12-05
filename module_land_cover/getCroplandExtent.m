%% CODE TO GET CROPLAND EXTENT
%JSN, 2020

addpath(genpath(pwd()))
% Set input files in CCI/Input/XXX.xls

%Getting CCI data
[NC_fileArray, LandCoverClassArray ] = main_CCI();

%Set year to get
year_to_get = 2015;

%Finding position in array
for i = 1:length( NC_fileArray)
   if NC_fileArray(i).year == year_to_get
      pos =i; 
   end
end


LandUseClass_IDsFromPos = [LandCoverClassArray.ID];
LandUseClass_isCropland = [LandCoverClassArray.isCropland];
LandUseClass_IDsThatRepresentCropland = LandUseClass_IDsFromPos(LandUseClass_isCropland==1);

LandUseClass_isMixedCropland = [LandCoverClassArray.isMixedCropland];
mixedCroplandIDs = LandUseClass_IDsFromPos(LandUseClass_isMixedCropland == 1);

mSize = size(NC_fileArray(pos).landCoverMatrix_lucc);

binary_isCropland = false(mSize(1),mSize(2));
fprintf('Getting binary cropland matrix');

for i = 1:length(LandUseClass_IDsThatRepresentCropland)
       binary_isCropland(NC_fileArray(pos).landCoverMatrix_lucc ==  LandUseClass_IDsThatRepresentCropland(i)) = true;
end

Earth = referenceSphere('earth','m');
surfaceArea_hectare = Earth.SurfaceArea/10000;

croplands_hectare = zeros(mSize(1),mSize(2));

for i_lat = 1:length(NC_fileArray(pos).areaPerLatitudeVector)
    croplands_hectare(:,i_lat) = binary_isCropland(:,i_lat)*NC_fileArray(pos).areaPerLatitudeVector(i_lat)*surfaceArea_hectare;
end

total_cropland_hectare = sum(croplands_hectare);

lat = NC_fileArray(pos).latitudeVector;
lon = NC_fileArray(pos).longitudeVector;

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
%year = NC_fileArray(1).year

export_10arcsec = 1;
if export_10arcsec == 1
    filename = ['Croplands_Global_2015_10arcsec_' timestamp '.nc'];
    
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
    
    nccreate(filename, 'cropland_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'cropland_hectare', 'standard_name', 'cropland_hectare');
    ncwriteatt(filename, 'cropland_hectare', 'long_name', 'cropland_hectare');
    ncwriteatt(filename, 'cropland_hectare', 'units', 'hectare');
    ncwriteatt(filename, 'cropland_hectare', 'missing_value', '-999');
    
    nccreate(filename, 'cropland_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
    ncwriteatt(filename, 'cropland_fractions', 'standard_name', 'cropland_hectare');
    ncwriteatt(filename, 'cropland_fractions', 'long_name', 'cropland_hectare');
    ncwriteatt(filename, 'cropland_fractions', 'units', 'hectare');
    ncwriteatt(filename, 'cropland_fractions', 'missing_value', '-999');
    
    ncwrite(filename, 'lat', lat);
    ncwrite(filename, 'lon', lon);
    ncwrite(filename, 'cropland_hectare', croplands_hectare);
    ncwrite(filename, 'cropland_fractions', croplands_hectare > 0);
end
fprintf('Upscaling to 30 arcsec \n');
[croplands_hectare_30arcsec, latitudeVector_30arcsec_centered, longitudeVector_30arcsec_centered, latitudeBounds_30arcsec, longitudeBounds_30arcsec]  = aggregateMatrix2givenDimensions( croplands_hectare,lon,lat, 43200, 21600);
fprintf('Exporting, 30arcsec \n')
export_30arcsec = 1;
if export_30arcsec == 1
    lat = latitudeVector_30arcsec_centered;
    lon = longitudeVector_30arcsec_centered;
    fractionsMatrix = zeros(length(lon), length(lat));
    areaPerLatitude = zeros(1,length(lat));
    
    for i = 1:length(lat)
       areaPerLatitude(i) =  areaquad(latitudeBounds_30arcsec(1,i),lon(1),latitudeBounds_30arcsec(2,i),lon(2))*surfaceArea_hectare;
       fractionsMatrix(:,i) = croplands_hectare_30arcsec(:,i)/areaPerLatitude(i);
    end
   
    sum(sum(areaPerLatitude*length(lon)))
    
    filename = ['Croplands_Global_2015_30arcsec_timestamp_' timestamp '.nc'];
    
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
    ncwrite(filename, 'cropland_hectare', croplands_hectare_30arcsec);
    ncwrite(filename, 'cropland_fractions', fractionsMatrix);
end

[croplands_hectare_5arcmin, latitudeVector_5arcmin_centered, longitudeVector_5arcmin_centered, latitudeBounds_5arcmin, longitudeBounds_5arcmin]  = aggregateMatrix2givenDimensions( croplands_hectare_30arcsec,longitudeVector_30arcsec_centered,latitudeVector_30arcsec_centered, 4320, 2160);

export_5arcmin = 1;
if export_5arcmin == 1
    lat = latitudeVector_5arcmin_centered;
    lon = longitudeVector_5arcmin_centered;
    
    fractionsMatrix = zeros(length(lon), length(lat));
    areaPerLatitude = zeros(1,length(lat));
    
    for i = 1:length(lat)
       areaPerLatitude(i) =  areaquad(latitudeBounds_5arcmin(1,i),lon(1),latitudeBounds_5arcmin(2,i),lon(2))*surfaceArea_hectare;
       fractionsMatrix(:,i) = croplands_hectare_5arcmin(:,i)/areaPerLatitude(i);
    end
   
    sum(sum(areaPerLatitude*length(lon)))
    
    filename = ['Croplands_Global_2015_5arcmin_timestamp_' timestamp '.nc'];
    
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
    ncwrite(filename, 'cropland_hectare', croplands_hectare_5arcmin);
    ncwrite(filename, 'cropland_fractions', fractionsMatrix);
end

