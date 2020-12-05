function  export2netcdf_boxLatsLons(obj, longitudeCoordinates_border ,latitudeCoordinates_border  )
%Takes filename and border coordinates as input
%e.g. longitudeCoordinates_border = [lon1 lon2], latitudeCoordinates_border
%= [lat1 lat2];
%written to export data for Baptists project work, Europe

outputFolder = 'Output/Box_export_070620/';

if exist([outputFolder],'dir') ~= 7
    mkdir([outputFolder]);
end

filename = [outputFolder  obj.cropname '_box_lons_' num2str(longitudeCoordinates_border(1)) '-' num2str(longitudeCoordinates_border(2)) '_lats_' num2str(latitudeCoordinates_border(1)) '-' num2str(latitudeCoordinates_border(2)) '.nc'];

if exist(filename)
    delete(filename);
end

%%Finding box to export
delta_lon1 = 360;
delta_lon2 = 360;
delta_lat1 = 180;
delta_lat2 = 180;

lonLimits_pos = [0 0];

for i = 1:length(obj.longitudeVector_centered)
    if abs(obj.longitudeVector_centered(i)-longitudeCoordinates_border(1)) < delta_lon1
        lonLimits_pos(1) = i;
        delta_lon1 = abs(obj.longitudeVector_centered(i)-longitudeCoordinates_border(1));
    elseif abs(longitudeCoordinates_border(1)-obj.longitudeVector_centered(i)) < delta_lon1
        lonLimits_pos(1) = i;
        delta_lon1 = abs(longitudeCoordinates_border(1)-obj.longitudeVector_centered(i));
    end
    if abs(obj.longitudeVector_centered(i)-longitudeCoordinates_border(2)) < delta_lon2
        lonLimits_pos(2) = i;
        delta_lon2 = abs(obj.longitudeVector_centered(i)-longitudeCoordinates_border(2));
    elseif abs(longitudeCoordinates_border(2)-obj.longitudeVector_centered(i)) < delta_lon2
        lonLimits_pos(2) = i;
        delta_lon2 = abs(longitudeCoordinates_border(2)-obj.longitudeVector_centered(i));
    end
        
end
if lonLimits_pos(1) == 0 || lonLimits_pos(2) == 0
   error('Could not find correct longitude borders.'); 
end

latLimits_pos = [0 0 ];
for i = 1:length(obj.latitudeVector_centered)
    if abs(obj.latitudeVector_centered(i)-latitudeCoordinates_border(1)) < delta_lat1
        latLimits_pos(1) = i;
        delta_lat1 = abs(obj.latitudeVector_centered(i)-latitudeCoordinates_border(1));
    elseif abs(latitudeCoordinates_border(1)-obj.latitudeVector_centered(i)) < delta_lat1
        latLimits_pos(1) = i;
        delta_lat1 = abs(latitudeCoordinates_border(1)-obj.latitudeVector_centered(i));
    end
    if abs(obj.latitudeVector_centered(i)-latitudeCoordinates_border(2)) < delta_lat2
        latLimits_pos(2) = i;
        delta_lat2 = abs(obj.latitudeVector_centered(i)-latitudeCoordinates_border(2));
    elseif abs(latitudeCoordinates_border(2)-obj.latitudeVector_centered(i)) < delta_lat2
        latLimits_pos(2) = i;
        delta_lat2 = abs(latitudeCoordinates_border(2)-obj.latitudeVector_centered(i));
    end
        
end
if latLimits_pos(1) == 0 || latLimits_pos(2) == 0
   error('Could not find correct longitude borders.'); 
end

if latLimits_pos(1) > latLimits_pos(2)
    temp = latLimits_pos(1);
    latLimits_pos(1) = latLimits_pos(2);
    latLimits_pos(2) = temp;
end
if lonLimits_pos(1) > lonLimits_pos(2)
   temp = lonLimits_pos(1);
   lonLimits_pos(1) = lonLimits_pos(2);
   lonLimits_pos(2) = temp;
end


givenYieldMatrix_tonsPerHectarePerYear = obj.dataMatrix_lonXlat_multiplicationFactorAccounted(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));
givenYieldMatrix_identifiedLands_tonsPerYear = obj.cropYield_identifiedLands_tonsPerYear(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));
areaPerLatitudeVector = obj.areaPerLatitudeVector_hectare(latLimits_pos(1):latLimits_pos(2));
givenPrimaryEnergyOutput = obj.primaryEnergyOutput_spatial_lhv_MJ_perYear(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));
latitudeVector_centered = obj.latitudeVector_centered(latLimits_pos(1):latLimits_pos(2));
longitudeVector_centered = obj.longitudeVector_centered(lonLimits_pos(1):lonLimits_pos(2));
identifiedLandMatrix_hectares = obj.areaMatrix_identifiedLand_ha(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));
identifiedLandMatrix_fractions = obj.fractionsMatrix_identifiedLand(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));


nccreate(filename,'lat','Dimensions',{'lat' length(latitudeVector_centered)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees_north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename, 'lat', 'axis', 'Y'); %ADDED 1306

nccreate(filename,'lon','Dimensions',{'lon' length(longitudeVector_centered)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X'); %ADDED 1306

nccreate(filename, 'area_per_latitude_hectares', 'Dimensions', {'lat' length(latitudeVector_centered)});
ncwriteatt(filename, 'area_per_latitude_hectares', 'standard_name', 'area_per_latitude_hectares');
ncwriteatt(filename, 'area_per_latitude_hectares', 'long_name', 'area_per_latitude_per_gridCell_hectares');
ncwriteatt(filename, 'area_per_latitude_hectares', 'units', 'hectares');
ncwriteatt(filename, 'area_per_latitude_hectares', 'missing_value', '-999');

nccreate(filename,'identified_land_hectares','Dimensions',{'lon' length(longitudeVector_centered) 'lat' length(latitudeVector_centered)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_hectares', 'standard_name', 'identified_land_hectares');
ncwriteatt(filename, 'identified_land_hectares', 'long_name', 'identified_land_hectares_ESA_CCI');
ncwriteatt(filename, 'identified_land_hectares', 'units', 'hectares');
ncwriteatt(filename, 'identified_land_hectares', 'missing_value', '-999');

nccreate(filename,'identified_land_fractions','Dimensions',{'lon' length(longitudeVector_centered) 'lat' length(latitudeVector_centered)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_fractions', 'standard_name', 'identified_land_fractions');
ncwriteatt(filename, 'identified_land_fractions', 'long_name', 'identified_land_fractions_ESA_CCI');
ncwriteatt(filename, 'identified_land_fractions', 'units', 'fraction');
ncwriteatt(filename, 'identified_land_fractions', 'missing_value', '-999');

nccreate(filename,'cropYield_tonsPerHectarePerYear','Dimensions',{'lon' length(longitudeVector_centered) 'lat' length(latitudeVector_centered)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropYield_tonsPerHectarePerYear', 'standard_name', 'crop_yields_tons_per_year');
ncwriteatt(filename, 'cropYield_tonsPerHectarePerYear', 'long_name', 'crop_yields_tons_per_year_GAEZ_output');
ncwriteatt(filename, 'cropYield_tonsPerHectarePerYear', 'units', 'ton_per_year');
ncwriteatt(filename, 'cropYield_tonsPerHectarePerYear', 'missing_value', '-999');

nccreate(filename,'cropYield_identifiedLands_tonsPerYear','Dimensions',{'lon' length(longitudeVector_centered) 'lat' length(latitudeVector_centered)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'cropYield_identifiedLands_tonsPerYear', 'standard_name', 'crop_yields_tons_per_year');
ncwriteatt(filename, 'cropYield_identifiedLands_tonsPerYear', 'long_name', 'crop_yields_tons_per_year_GAEZ_output');
ncwriteatt(filename, 'cropYield_identifiedLands_tonsPerYear', 'units', 'ton_per_year');
ncwriteatt(filename, 'cropYield_identifiedLands_tonsPerYear', 'missing_value', '-999');

nccreate(filename,'primary_energy_output_LHV','Dimensions',{'lon' length(longitudeVector_centered) 'lat' length(latitudeVector_centered)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_output_LHV', 'standard_name', 'primary_energy_output_LHV');
ncwriteatt(filename, 'primary_energy_output_LHV', 'long_name', 'primary_energy_output_LHV');
ncwriteatt(filename, 'primary_energy_output_LHV', 'units', 'MJ_per_year');
ncwriteatt(filename, 'primary_energy_output_LHV', 'missing_value', '-999');

nccreate(filename,'water_deficit_mm','Dimensions',{'lon' length(longitudeVector_centered) 'lat' length(latitudeVector_centered)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_deficit_mm', 'standard_name', 'primary_energy_output_LHV');
ncwriteatt(filename, 'water_deficit_mm', 'long_name', 'primary_energy_output_LHV');
ncwriteatt(filename, 'water_deficit_mm', 'units', 'mm');
ncwriteatt(filename, 'water_deficit_mm', 'missing_value', '-999');

nccreate(filename,'water_requirements_of_irrigated_conditions_m3','Dimensions',{'lon' length(longitudeVector_centered) 'lat' length(latitudeVector_centered)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_requirements_of_irrigated_conditions_m3', 'standard_name', 'water_requirements_of_irrigated_conditions_m3');
ncwriteatt(filename, 'water_requirements_of_irrigated_conditions_m3', 'long_name', 'water_requirements_of_irrigated_conditions_m3');
ncwriteatt(filename, 'water_requirements_of_irrigated_conditions_m3', 'units', 'm^3');
ncwriteatt(filename, 'water_requirements_of_irrigated_conditions_m3', 'missing_value', '-999');

nccreate(filename,'calorific_value_LHV', 'Datatype', 'double');
ncwriteatt(filename, 'calorific_value_LHV', 'standard_name', 'calorific_value_LHV');
ncwriteatt(filename, 'calorific_value_LHV', 'long_name', 'calorific_value_LHV');
ncwriteatt(filename, 'calorific_value_LHV', 'units', 'MJ_per_kg');
ncwriteatt(filename, 'calorific_value_LHV', 'missing_value', '-999');

nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', 1000})
ncwriteatt(filename, 'description', 'standard_name', 'description')
ncwriteatt(filename, 'description', 'long_name', 'description')

nccreate(filename, 'crop_ID', 'Datatype', 'double')
ncwriteatt(filename, 'crop_ID', 'standard_name', 'crop_id');
ncwriteatt(filename, 'crop_ID', 'long_name', 'crop_id');

nccreate(filename, 'year', 'Datatype', 'double')
ncwriteatt(filename, 'year', 'standard_name', 'year');
ncwriteatt(filename, 'year', 'long_name', 'year');

nccreate(filename, 'climate_scenario_ID', 'Datatype', 'double');
ncwriteatt(filename, 'climate_scenario_ID', 'standard_name', 'climate_scenario_ID');
ncwriteatt(filename, 'climate_scenario_ID', 'long_name', 'climate_scenario_ID');

nccreate(filename, 'irrigation_level', 'Datatype', 'double');
ncwriteatt(filename, 'irrigation_level', 'standard_name', 'irrigation_level');
ncwriteatt(filename, 'irrigation_level', 'long_name', 'irrigation_level');

nccreate(filename, 'input_level', 'Datatype', 'double');
ncwriteatt(filename, 'input_level', 'standard_name', 'input_level');
ncwriteatt(filename, 'input_level', 'long_name', 'input_tech_fertilizer_level');

nccreate(filename, 'biodiversity_hotspots_excluded_from_identified_land_binary', 'Datatype', 'double');
ncwriteatt(filename, 'biodiversity_hotspots_excluded_from_identified_land_binary', 'standard_name', 'biodiversity_hotspots_excluded_from_identified_land_binary');
ncwriteatt(filename, 'biodiversity_hotspots_excluded_from_identified_land_binary', 'long_name', 'biodiversity_hotspots_excluded_from_identified_land_binary');



ncwrite(filename,'lat',latitudeVector_centered);
ncwrite(filename,'lon',longitudeVector_centered);
ncwrite(filename, 'area_per_latitude_hectares', areaPerLatitudeVector);
ncwrite(filename, 'identified_land_hectares', identifiedLandMatrix_hectares);
ncwrite(filename,'identified_land_fractions', identifiedLandMatrix_fractions)

ncwrite(filename, 'cropYield_tonsPerHectarePerYear', givenYieldMatrix_tonsPerHectarePerYear);
ncwrite(filename, 'cropYield_identifiedLands_tonsPerYear', givenYieldMatrix_identifiedLands_tonsPerYear);
ncwrite(filename, 'primary_energy_output_LHV', givenPrimaryEnergyOutput);
ncwrite(filename, 'calorific_value_LHV', obj.calorificValue_weightedAllPlant_MJperKgFromGAEZ_lhv);
ncwrite(filename, 'description', char(obj.cropname));
ncwrite(filename, 'crop_ID', obj.cropID);
ncwrite(filename, 'year', obj.year);
ncwrite(filename, 'climate_scenario_ID', obj.climateScenarioID);
ncwrite(filename, 'irrigation_level', obj.isIrrigated);
ncwrite(filename, 'input_level', obj.inputRate);
ncwrite(filename, 'biodiversity_hotspots_excluded_from_identified_land_binary', obj.biodiversityHotspotsExcludedFromIdentifiedLand_binary);

%Getting water deficit if applicable
if obj.waterDeficitDataIsGiven_binary == 1
%All land surface in box
    waterDeficitMatrix_allLand_mm = obj.waterDeficitMatrix_mm(lonLimits_pos(1):lonLimits_pos(2),latLimits_pos(1):latLimits_pos(2));
    
    
    %identifiedLand in box
    waterDeficitMatrix_identifiedLand_mm = waterDeficitMatrix_allLand_mm;
    waterDeficitMatrix_identifiedLand_mm(givenYieldMatrix_tonsPerHectarePerYear == 0) = 0;
    
    waterRequirements_identifiedLand_m3 = ((10^4)*identifiedLandMatrix_hectares).*((10^-3)*waterDeficitMatrix_identifiedLand_mm);
    
    ncwrite(filename, 'water_deficit_mm', waterDeficitMatrix_identifiedLand_mm);
    ncwrite(filename, 'water_requirements_of_irrigated_conditions_m3',  waterRequirements_identifiedLand_m3);
end


fprintf(['Wrote to file: ' filename '\n'] )

end

