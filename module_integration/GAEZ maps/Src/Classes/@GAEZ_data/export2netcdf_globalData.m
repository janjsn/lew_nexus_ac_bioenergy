function  export2netcdf_globalData( obj )
%EXPORT2NETCDF_GLOBALDATA Summary of this function goes here
%   Detailed explanation goes here

%% Setup filename and description
filename = ['Output/GAEZ_netcdf/' ];

cropname = obj.cropname;
for i = 1:length(cropname)
    if strcmp(cropname(i), '_')
       cropname = cropname(1:i-1);
        break
    end
end
   

description = [cropname '_' num2str(obj.year) '_'];

if obj.climateScenarioID == 2
    description = [description 'RCP45_'];
    climate_string = 'RCP45';
elseif obj.climateScenarioID == 3
    description = [description 'RCP85_'];
    climate_string = 'RCP45';
else
    climate_string = 'historical';
end

if obj.inputRate == 1
    description = [description 'lo_rf'];
    management_string = 'low';
elseif obj.inputRate == 2
    management_string = 'medium';
    if obj.isIrrigated == 1
        description = [description 'me_ir'];
    else
        description = [description 'me_rf'];
    end
elseif obj.inputRate == 3
    management_string = 'high';
    if obj.isIrrigated == 1
        description = [description 'hi_ir'];
    else
        description = [description 'hi_rf'];
    end
end

filename = [filename description '.nc'];

if exist(filename)
   delete(filename) 
end

%% Get lon and lat
lon = obj.longitudeVector_centered;
lat = obj.latitudeVector_centered;

%% Design netcdf

nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'description', 'standard_name', 'description');
ncwriteatt(filename, 'description', 'long_name', 'description');

nccreate(filename, 'year');
ncwriteatt(filename, 'year', 'standard_name', 'year');
ncwriteatt(filename, 'year', 'long_name', 'year');

nccreate(filename, 'crop_name', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'crop_name', 'standard_name', 'description');
ncwriteatt(filename, 'crop_name', 'long_name', 'description');

nccreate(filename, 'crop_ID');
ncwriteatt(filename, 'crop_ID', 'standard_name', 'crop_ID');
ncwriteatt(filename, 'crop_ID', 'long_name', 'crop_ID');

nccreate(filename, 'lhv');
ncwriteatt(filename, 'lhv', 'standard_name', 'lower_heating_value');
ncwriteatt(filename, 'lhv', 'long_name', 'lower_heating_value');
ncwriteatt(filename, 'lhv', 'units', 'MJ kg-1');

nccreate(filename, 'ref_lhv', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'ref_lhv', 'standard_name', 'reference_lhv');
ncwriteatt(filename, 'ref_lhv', 'long_name', 'reference_lower_heating_value');

nccreate(filename, 'climate_scenario_ID');
ncwriteatt(filename, 'climate_scenario_ID', 'standard_name', 'climate_scenario_ID');
ncwriteatt(filename, 'climate_scenario_ID', 'long_name', 'climate_scenario_ID');

nccreate(filename, 'climate_scenario_name', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'climate_scenario_name', 'standard_name', 'climate_scenario_name');
ncwriteatt(filename, 'climate_scenario_name', 'long_name', 'climate_scenario_name');

nccreate(filename, 'climate_model', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'climate_model', 'standard_name', 'climate_model');
ncwriteatt(filename, 'climate_model', 'long_name', 'climate_model');

nccreate(filename, 'agricultural_management_intensity')
ncwriteatt(filename, 'agricultural_management_intensity', 'standard_name', 'agricultural_management_intensity')
ncwriteatt(filename, 'agricultural_management_intensity', 'long_name', 'agricultural_management_intensity')

nccreate(filename, 'agricultural_management_intensity_name', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'agricultural_management_intensity_name', 'standard_name', 'agricultural_management_intensity_name')
ncwriteatt(filename, 'agricultural_management_intensity_name', 'long_name', 'agricultural_management_intensity_name')

nccreate(filename, 'irrigation_is_assumed')
ncwriteatt(filename, 'irrigation_is_assumed', 'standard_name', 'irrigation_is_assumed')
ncwriteatt(filename, 'irrigation_is_assumed', 'long_name', 'irrigation_is_assumed_0=rainfed_1=irrigated')

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

nccreate(filename,'dm_yield','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'dm_yield', 'standard_name', 'dry_matter_yields');
ncwriteatt(filename, 'dm_yield', 'long_name', 'dry_matter_yields');
ncwriteatt(filename, 'dm_yield', 'units', 'ton ha-1 yr-1');
ncwriteatt(filename, 'dm_yield', 'missing_value', '-999');

nccreate(filename, 'ref_dm_yield', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'ref_dm_yield', 'standard_name', 'reference_dry_matter_yields');
ncwriteatt(filename, 'ref_dm_yield', 'long_name', 'reference_dry_matter_yields');

nccreate(filename,'bioenergy_yield','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_yield', 'standard_name', 'bioenergy_yield');
ncwriteatt(filename, 'bioenergy_yield', 'long_name', 'bioenergy_yield');
ncwriteatt(filename, 'bioenergy_yield', 'units', 'GJ ha-1 yr-1');
ncwriteatt(filename, 'bioenergy_yield', 'missing_value', '-999');

nccreate(filename,'water_use','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_use', 'standard_name', 'irrigation_applied');
ncwriteatt(filename, 'water_use', 'long_name', 'applied_water_use_for_irrigation_based_on_water_deficit_at_rainfed_conditions');
ncwriteatt(filename, 'water_use', 'units', 'mm yr-1');
ncwriteatt(filename, 'water_use', 'missing_value', '-999');

nccreate(filename, 'ref_water_deficit', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'ref_water_deficit', 'standard_name', 'reference_water_deficit');
ncwriteatt(filename, 'ref_water_deficit', 'long_name', 'reference_water_deficit');

%% Get water deficit matrice
applied_irrigation = zeros(length(lon), length(lat));
if obj.isIrrigated == 1
    if obj.waterDeficitDataIsGiven_binary == 1
        applied_irrigation = obj.waterDeficitMatrix_mm;
    else
        applied_irrigation(:,:) = -999;
    end
end
%% Write variables

ncwrite(filename, 'description', description);
ncwrite(filename, 'year', obj.year);
ncwrite(filename, 'crop_name', cropname);
ncwrite(filename, 'crop_ID', obj.cropID);
ncwrite(filename, 'lhv', obj.calorificValue_weightedAllPlant_MJperKgFromGAEZ_lhv);
ncwrite(filename, 'ref_lhv', 'Phyllis2');
ncwrite(filename, 'climate_scenario_ID', obj.climateScenarioID);
ncwrite(filename, 'climate_scenario_name', climate_string);
ncwrite(filename, 'climate_model', 'HadCM3');
ncwrite(filename, 'agricultural_management_intensity', obj.inputRate);
ncwrite(filename, 'agricultural_management_intensity_name', management_string);
ncwrite(filename, 'irrigation_is_assumed', obj.isIrrigated);
ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'dm_yield', obj.dataMatrix_lonXlat_multiplicationFactorAccounted);
ncwrite(filename, 'ref_dm_yield', 'GAEZ 3.0');
ncwrite(filename, 'bioenergy_yield', obj.globalEnergyYields_lhv_GJperHectarePerYear);
ncwrite(filename, 'water_use', applied_irrigation);
ncwrite(filename, 'ref_water_deficit', 'GAEZ 3.0');

fprintf(['Wrote to: ' filename '. \n']);

end

