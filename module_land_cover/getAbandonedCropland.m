addpath(genpath(pwd()))

[NC_fileArray, LandCoverClassArray ] = main_CCI();

mSize = size(NC_fileArray(1).landCoverMatrix_lucc);

urbanClassID_1992_2015 = -66;
urbanClassID_2018 = 190;
croplandMosaicClassID = 30;
naturalVegetationMosaicClassID = 40;



tic

%Get some information
LandUseClass_IDsFromPos = [LandCoverClassArray.ID];
LandUseClass_isCropland = [LandCoverClassArray.isCropland];
LandUseClass_isUrban = [LandCoverClassArray.isUrban];
LandUseClass_IDsThatRepresentCropland = LandUseClass_IDsFromPos(LandUseClass_isCropland==1);
LandUseClass_IDsThatRepresentUrban = LandUseClass_IDsFromPos(LandUseClass_isUrban==1);
LandUseClass_isMixedCropland = [LandCoverClassArray.isMixedCropland];
LandUseClass_mixedCropland_croplandFactor = [LandCoverClassArray.mixedCropland_croplandFactor];
LandUseClass_mixedCropland_grasslandFactor = [LandCoverClassArray.mixedCropland_grasslandFactor];
LandUseClass_mixedCropland_forestFactor = [LandCoverClassArray.mixedCropland_forestFactor];
LandUseClass_mixedCropland_shrublandFactor = [LandCoverClassArray.mixedCropland_shrublandFactor];

croplandIDs = LandUseClass_IDsFromPos(LandUseClass_isCropland == 1);
mixedCroplandIDs = LandUseClass_IDsFromPos(LandUseClass_isMixedCropland == 1);

binary_isCropland_1992 = false(mSize(1),mSize(2));
binary_isCropland_2015 = false(mSize(1),mSize(2));

% 
binary_isMixedCropland_1992 = false(mSize(1),mSize(2));
binary_isMixedCropland_2015 = false(mSize(1),mSize(2));

% 
% toc

for i = 1:length(NC_fileArray)
    if NC_fileArray(i).year == 1992
        binary_isUrban_1992 = NC_fileArray(i).landCoverMatrix_lucc == urbanClassID_1992_2015;
        for ID = 1:length(croplandIDs)
            binary_isCropland_1992(NC_fileArray(i).landCoverMatrix_lucc == croplandIDs(ID)) = true;
            
        end
        for ID = 1:length(mixedCroplandIDs)
            binary_isMixedCropland_1992(NC_fileArray(i).landCoverMatrix_lucc == mixedCroplandIDs(ID)) = true;
        end
        
        binary_isCroplandMosaic_1992 = NC_fileArray(i).landCoverMatrix_lucc == croplandMosaicClassID;
        binary_isNatVegMosaic_1992 = NC_fileArray(i).landCoverMatrix_lucc == naturalVegetationMosaicClassID;
        
    elseif NC_fileArray(i).year == 2015
        binary_isUrban_2015 = NC_fileArray(i).landCoverMatrix_lucc == urbanClassID_1992_2015;
        for ID = 1:length(croplandIDs)
            binary_isCropland_2015(NC_fileArray(i).landCoverMatrix_lucc == croplandIDs(ID)) = true;   
        end
        for ID = 1:length(mixedCroplandIDs)
            binary_isMixedCropland_2015(NC_fileArray(i).landCoverMatrix_lucc == mixedCroplandIDs(ID)) = true;
        end
        
        binary_isCroplandMosaic_2015 = NC_fileArray(i).landCoverMatrix_lucc == croplandMosaicClassID;
        binary_isNatVegMosaic_2015 = NC_fileArray(i).landCoverMatrix_lucc == naturalVegetationMosaicClassID;
        
    end
end

toc

binary_abandonedCropland_1992_2015 = binary_isCropland_1992;
binary_abandonedCropland_1992_2015(binary_isCropland_2015) = false;
binary_abandonedCropland_1992_2015(binary_isUrban_2015) = false;
binary_abandonedCropland_1992_2015(binary_isCropland_1992 & (~binary_isMixedCropland_1992) & binary_isMixedCropland_2015) = true;
binary_abandonedCropland_1992_2015(binary_isCroplandMosaic_1992 & binary_isNatVegMosaic_2015) = true;


% Get areas
Earth = referenceSphere('earth','m');
surfaceArea_hectare = Earth.SurfaceArea/10000;

% 
abandonedCropland_1992_2015_hectare = zeros(mSize(1),mSize(2));

lat_step = 180/mSize(2);
lon_step = 360/mSize(1);
latitudeVector_centered = [90-(lat_step/2):-lat_step:-90+(lat_step/2)];
longitudeVector_centered = [-180+(lon_step/2):lon_step:180-(lon_step/2)];
areaPerLatitudeVector = NC_fileArray(1).areaPerLatitudeVector;
clear('NC_fileArray')


for i_lat = 1:length(areaPerLatitudeVector)
    abandonedCropland_1992_2015_hectare(:,i_lat) = binary_abandonedCropland_1992_2015(:,i_lat)*areaPerLatitudeVector(i_lat)*surfaceArea_hectare;
end

% 
 sum(sum(abandonedCropland_1992_2015_hectare))

 upscale = 1 ;
 
 if upscale == 1
     fprintf('Calculating abandonment, 30arcsec \n')
     fprintf('1992-2015 \n')
     tic
     [abandonedCropland_1992_2015_hectare_30arcsec, latitudeVector_30arcsec_centered, longitudeVector_30arcsec_centered, latitudeBounds_30arcsec, longitudeBounds_30arcsec]  = aggregateMatrix2givenDimensions( abandonedCropland_1992_2015_hectare,longitudeVector_centered,latitudeVector_centered, 43200, 21600);
     toc

     fprintf('Exporting abandoned cropland 1992-2015 to file at 30 arcsec \n')
     export2netcdf_abandonedCropland( 'abandoned_cropland_1992_2015_30_arcsec_timestamp_',  abandonedCropland_1992_2015_hectare_30arcsec, latitudeVector_30arcsec_centered , longitudeVector_30arcsec_centered)
     
     fprintf('Finished writing \n');
     
     %% Upscale to 5 arcmin
     [abandonedCropland_1992_2015_hectare_5arcmin, latitudeVector_5arcmin_centered, longitudeVector_5arcmin_centered, latitudeBounds_5arcmin, longitudeBounds_5arcmin]  = aggregateMatrix2givenDimensions( abandonedCropland_1992_2015_hectare_30arcsec,longitudeVector_30arcsec_centered,latitudeVector_30arcsec_centered, 4320, 2160);
     %Exporting at 5 arcmin.
     fprintf('Exporting abandoned cropland 1992-2015 to file at 5arcmin \n')
     export2netcdf_abandonedCropland( 'abandoned_cropland_1992_2015_5arcmin_timestamp_',  abandonedCropland_1992_2015_hectare_5arcmin, latitudeVector_5arcmin_centered , longitudeVector_5arcmin_centered)
     
     fprintf('Finished writing \n');
     
     %% APPLY COUNTRY MASKS AT 30 arcsec
     
     [countryMasks_30arcsec, GeoInfo_countryMask] = getCountryMasks_gpw('Country masks/gpw-v4-national-identifier-grid-rev11_30_sec_tif/gpw_v4_national_identifier_grid_rev11_30_sec.tif');
     countryMasks_30arcsec = countryMasks_30arcsec';
     
     CountryArray = getCountryMaskIDs( 'Country masks/gpw-v4-national-identifier-grid-rev11_30_sec_tif/gpw-v4-country-level-summary-rev11.xlsx', 'GPWv4 Rev11 Summary' );
     
     fprintf('Calculating country level cropland abandonment (1992-2015)... \n')
     for n_countries = 1:length(CountryArray)
         %Print country name:
         fprintf('Country: ')
         fprintf(CountryArray(n_countries).country_name);
         fprintf(': \n');
         %Get country cropland abandonment:
         CountryArray(n_countries).abandonedCropland_total_hectares = sum(sum(abandonedCropland_1992_2015_hectare_30arcsec(countryMasks_30arcsec == CountryArray(n_countries).GPW_country_ISO_numeric)));
         %Print result:
         fprintf(num2str(CountryArray(n_countries).abandonedCropland_total_hectares));
         fprintf('\n');
     end
     
     
     
 end




% Decrease resolution t 1 degree


[abandonedCropland_1992_2015_hectare_oneDegree, latitudeVector_oneDegree_centered, longitudeVector_oneDegree_centered, latitudeBounds_oneDegree, longitudeBounds_oneDegree]  = aggregateMatrix2givenDimensions( abandonedCropland_1992_2015_hectare,longitudeVector_centered,latitudeVector_centered, 360, 180);


clear
areaPerLatitudeVector_oneDegree = zeros(1,180);
latitudeVector_oneDegree_corners = [90:-1:-90];

Calculating area per quadrangle
for i = 2:length(latitudeVector_oneDegree_corners)
    areaPerLatitudeVector_oneDegree(i-1) = areaquad(latitudeVector_oneDegree_corners(i-1),0,latitudeVector_oneDegree_corners(i),1)*surfaceArea_hectare;
end
cellAreaMatrix_hectare_oneDegree = zeros(360,180);
for i = 1:180
    cellAreaMatrix_hectare_oneDegree(1:end,i) = areaPerLatitudeVector_oneDegree(i);
end

%Calculating fractions
abandonedCropland_1992_2015_fractions_oneDegree = abandonedCropland_1992_2015_hectare_oneDegree./cellAreaMatrix_hectare_oneDegree;



% OTHER 



%% Export key results to netcdf
%timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

%1992-2015 300m AC
filename = 'Abandoned_cropland_1992_2015_300m.nc';

lon = longitudeVector_centered;
lat = latitudeVector_centered;


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

nccreate(filename, 'abandoned_cropland_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_hectare', 'standard_name', 'abandoned_cropland_hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'long_name', 'abandoned_cropland_1992_2015_300m_hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'units', 'hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'missing_value', '-999');

nccreate(filename, 'abandoned_cropland_fractions_of_gridcell','Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_fractions_of_gridcell', 'standard_name', 'abandoned_cropland_fractions');
ncwriteatt(filename, 'abandoned_cropland_fractions_of_gridcell', 'long_name', 'abandoned_cropland_1992_2015_300m_fractions_of_gricell');
ncwriteatt(filename, 'abandoned_cropland_fractions_of_gridcell', 'units', 'hectare');
ncwriteatt(filename, 'abandoned_cropland_fractions_of_gridcell', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'abandoned_cropland_hectare', abandonedCropland_1992_2015_hectare);
%ncwrite(filename, 'abandoned_cropland_fractions_of_gridcell', );

fprintf('Wrote to file: ');
fprintf(filename);
fprintf('\n');


%% One degree AC
%1992-2015 1Deg AC
filename = 'Abandoned_cropland_1992_2015_oneDegree.nc';

lon = longitudeVector_centered;
lat = latitudeVector_centered;


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

nccreate(filename, 'abandoned_cropland_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_hectare', 'standard_name', 'abandoned_cropland_hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'long_name', 'abandoned_cropland_1992_2015_oneDegree_hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'units', 'hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'missing_value', '-999');

nccreate(filename, 'abandoned_cropland_fractions_of_gridcell','Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_fractions_of_gridcell', 'standard_name', 'abandoned_cropland_fractions');
ncwriteatt(filename, 'abandoned_cropland_fractions_of_gridcell', 'long_name', 'abandoned_cropland_1992_2015_oneDegree_fractions_of_gricell');
ncwriteatt(filename, 'abandoned_cropland_fractions_of_gridcell', 'units', 'hectare');
ncwriteatt(filename, 'abandoned_cropland_fractions_of_gridcell', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'abandoned_cropland_hectare', abandonedCropland_1992_2015_hectare_oneDegree);
ncwrite(filename, 'abandoned_cropland_fractions_of_gridcell', abandonedCropland_1992_2015_fractions_oneDegree);

fprintf('Wrote to file: ');
fprintf(filename);
fprintf('\n');


