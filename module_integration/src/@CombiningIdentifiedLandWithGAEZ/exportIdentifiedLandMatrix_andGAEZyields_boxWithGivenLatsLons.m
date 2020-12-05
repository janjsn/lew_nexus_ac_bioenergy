function exportIdentifiedLandMatrix_andGAEZyields_boxWithGivenLatsLons(obj, lat1, lat2, lon1, lon2)
%% CODE TO EXPORT A BOX OF DATA; Identified lands and GAEZ yields/outputs in given box
%  Written by Jan Sandstad Næss, 10.09.2019

latpos1 = 0;
latpos2 = 0;
lonpos1 = 0;
lonpos2 = 0;

if lat1 == lat2 || lon1 == lon2
    error('Same lat/lon values given, not a box.');
end

%% Finding positions in datamatrixes and vectors
smallestDeltaLat1 = 180;
smallestDeltaLat2 = 180;

smallestDeltaLon1 = 360;
smallestDeltaLon2 = 360;

%lat
for i = 1 : length(obj.identifiedLand_latitudeVector_centered)
    %lat1
    lat1_delta1 = abs(obj.identifiedLand_latitudeVector_centered(i)-lat1);
    lat1_delta2 = abs(lat1-obj.identifiedLand_latitudeVector_centered(i));
    if lat1_delta1 < smallestDeltaLat1
        smallestDeltaLat1 = lat1_delta1;
        latpos1 = i;
    end
    if lat1_delta2 < smallestDeltaLat1
        smallestDeltaLat1 = lat1_delta2;
        latpos1 = i;
    end   
    %lat2
    lat2_delta1 = abs(obj.identifiedLand_latitudeVector_centered(i)-lat2);
    lat2_delta2 = abs(lat2-obj.identifiedLand_latitudeVector_centered(i));
    if lat2_delta1 < smallestDeltaLat2
        smallestDeltaLat2 = lat2_delta1;
        latpos2 = i;
    end
    if lat1_delta2 < smallestDeltaLat2
        smallestDeltaLat2 = lat2_delta2;
        latpos2 = i;
    end   
    
end
%lon
for i = 1 : length(obj.identifiedLand_longitudeVector_centered)
    %lon1
    lon1_delta1 = abs(obj.identifiedLand_longitudeVector_centered(i)-lon1);
    lon1_delta2 = abs(lon1-obj.identifiedLand_longitudeVector_centered(i));
    if lon1_delta1 < smallestDeltaLon1
        smallestDeltaLon1 = lon1_delta1;
        lonpos1 = i;
    end
    if lon1_delta2 < smallestDeltaLon1
        smallestDeltaLon1 = lon1_delta2;
        lonpos1 = i;
    end   
    %lon2
    lon2_delta1 = abs(obj.identifiedLand_longitudeVector_centered(i)-lon2);
    lon2_delta2 = abs(lon2-obj.identifiedLand_longitudeVector_centered(i));
    if lon2_delta1 < smallestDeltaLon2
        smallestDeltaLon2 = lon2_delta1;
        lonpos2 = i;
    end
    if lon2_delta2 < smallestDeltaLon2
        smallestDeltaLon2 = lon2_delta2;
        lonpos2 = i;
    end   
    
end
%% Making lat/lon vectors and limits
if latpos1 < latpos2
    latitudeVector_centered = obj.identifiedLand_latitudeVector_centered(latpos1:latpos2);
    latLimits_pos = [latpos1 latpos2];
elseif latpos2 < latpos1
    latitudeVector_centered = obj.identifiedLand_latitudeVector_centered(latpos2:latpos1);
    latLimits_pos = [latpos2 latpos1];
end

if lonpos1 < lonpos2
    longitudeVector_centered = obj.identifiedLand_longitudeVector_centered(lonpos1:lonpos2);
    lonLimits_pos = [lonpos1 lonpos2];
elseif lonpos2 < lonpos1
    longitudeVector_centered = obj.identifiedLand_longitudeVector_centered(lonpos2:lonpos1);
    lonLimits_pos = [lonpos2 lonpos1];
end



%% Getting and exporting data matrices
outputFolder = ['Output/Exported_latLonBox/Box_Lats_' num2str(lat1) '_' num2str(lat2) '_Lons_' num2str(lon1) '_' num2str(lon2)];
if exist(outputFolder, 'dir') ~=7
   mkdir(outputFolder); 
end

%Getting identified land matrix
identifiedLandMatrix_hectares = obj.identifiedLandMatrix_hectares(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));
identifiedLandMatrix_fractions = obj.identifiedLandMatrix_fractionOfCell(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));

%Without biodiversity hotspots
identifiedLandMatrix_noBH_hectares = obj.identifiedLandMatrix_excludingBiodiversityHotspots_hectares(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));
identifiedLandMatrix_noBH_fractions = obj.identifiedLandMatrix_excludingBiodiversityHotspots_fractions(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));



%% WRITING DATA
for i = 1:length(obj.GAEZ_array)
    filename = [outputFolder '/' obj.GAEZ_array(i).cropname '.nc'];
    if exist(filename) == 2
        delete(filename)
    end
    obj.GAEZ_array(i).export2netcdf_boxLatsLons(filename, latLimits_pos, lonLimits_pos, latitudeVector_centered, longitudeVector_centered, identifiedLandMatrix_hectares, identifiedLandMatrix_fractions);
end

for i = 1:length(obj.GAEZ_array_noBiodiversityHotspots)
    filename = [outputFolder '/' obj.GAEZ_array_noBiodiversityHotspots(i).cropname '_excluding_biodiversity_hotspots.nc'];
    if exist(filename) == 2
        delete(filename)
    end
    obj.GAEZ_array_noBiodiversityHotspots(i).export2netcdf_boxLatsLons(filename, latLimits_pos, lonLimits_pos, latitudeVector_centered, longitudeVector_centered, identifiedLandMatrix_noBH_hectares, identifiedLandMatrix_noBH_fractions);
end


end

