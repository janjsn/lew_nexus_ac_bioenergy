function export2netcdf( obj, outputFolder, latitudeVector, longitudeVector, identifiedLand_fractions, identifiedLandMatrix_hectares  )
%Exports water scarcity scenario results to netcdf file

lon = longitudeVector;
lat = latitudeVector;

%Making sure output folder exist
if exist([outputFolder '/NC files/Water scarcity scenarios/'],'dir') ~= 7
    mkdir([outputFolder '/NC files/Water scarcity scenarios/']);
end

outputFolder = [outputFolder '/NC files/Water scarcity scenarios/'];
timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

filename = [outputFolder obj.scenarioDescription_string '_water_scarcity_scenarios_' timestamp '.nc'];

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

nccreate(filename, 'year', 'Datatype', 'double')
ncwriteatt(filename, 'year', 'standard_name', 'year')
ncwriteatt(filename, 'year', 'long_name', 'year of analyses')
ncwriteatt(filename, 'year', 'units', '');
%ncwriteatt(filename, 'year', 'Datatype', 'double')

nccreate(filename, 'scenario_description', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'scenario_description', 'standard_name', 'scenario_description')
ncwriteatt(filename, 'scenario_description', 'long_name', 'scenario_description')
%ncwriteatt(filename, 'scenario_description', 'Datatype', 'char')

nccreate(filename,'optimal_crop_ID_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'optimal_crop_ID_lhv', 'standard_name', 'optimal_crop_ID_lhv');
ncwriteatt(filename, 'optimal_crop_ID_lhv', 'long_name', 'optimal_crop_ID_lhv');
ncwriteatt(filename, 'optimal_crop_ID_lhv', 'units', '');
ncwriteatt(filename, 'optimal_crop_ID_lhv', 'missing_value', '-999');

nccreate(filename,'optimal_crop_ID_hhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'optimal_crop_ID_hhv', 'standard_name', 'optimal_crop_ID_hhv');
ncwriteatt(filename, 'optimal_crop_ID_hhv', 'long_name', 'optimal_crop_ID_hhv');
ncwriteatt(filename, 'optimal_crop_ID_hhv', 'units', '');
ncwriteatt(filename, 'optimal_crop_ID_hhv', 'missing_value', '-999');

nccreate(filename,'irrigation_matrix_binary','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'irrigation_matrix_binary', 'standard_name', 'irrigation_matrix_binary');
ncwriteatt(filename, 'irrigation_matrix_binary', 'long_name', 'irrigation_matrix_binary');
ncwriteatt(filename, 'irrigation_matrix_binary', 'units', '');
ncwriteatt(filename, 'irrigation_matrix_binary', 'missing_value', '-999');


nccreate(filename,'primary_energy_potential_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_potential_lhv', 'standard_name', 'primary_energy_potential_lhv');
ncwriteatt(filename, 'primary_energy_potential_lhv', 'long_name', 'primary_energy_potential_lhv');
ncwriteatt(filename, 'primary_energy_potential_lhv', 'units', 'MJ/year');
ncwriteatt(filename, 'primary_energy_potential_lhv', 'missing_value', '-999');

nccreate(filename,'primary_energy_potential_hhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_potential_hhv', 'standard_name', 'primary_energy_potential_hhv');
ncwriteatt(filename, 'primary_energy_potential_hhv', 'long_name', 'primary_energy_potential_hhv');
ncwriteatt(filename, 'primary_energy_potential_hhv', 'units', 'MJ/year');
ncwriteatt(filename, 'primary_energy_potential_hhv', 'missing_value', '-999');

nccreate(filename, 'estimated_total_primary_energy_potential_lhv', 'Datatype', 'double')
ncwriteatt(filename, 'estimated_total_primary_energy_potential_lhv', 'standard_name', 'primary_energy_potential_lhv')
ncwriteatt(filename, 'estimated_total_primary_energy_potential_lhv', 'long_name', 'primary_energy_potential_lhv')
ncwriteatt(filename, 'estimated_total_primary_energy_potential_lhv', 'units', 'EJ/year');

nccreate(filename, 'estimated_total_primary_energy_potential_hhv', 'Datatype', 'double')
ncwriteatt(filename, 'estimated_total_primary_energy_potential_hhv', 'standard_name', 'primary_energy_potential_hhv')
ncwriteatt(filename, 'estimated_total_primary_energy_potential_hhv', 'long_name', 'primary_energy_potential_hhv')
ncwriteatt(filename, 'estimated_total_primary_energy_potential_hhv', 'units', 'EJ/year');

% nccreate(filename, 'hectares_allocated_per_crop_type_lhv', 'Dimensions', {'dim1', inf})
% ncwriteatt(filename, 'hectares_allocated_per_crop_type_lhv', 'standard_name', 'hectares_allocated_per_crop_type_lhv')
% ncwriteatt(filename, 'hectares_allocated_per_crop_type_lhv', 'long_name', 'hectares_allocated_per_crop_type_lhv')
% ncwriteatt(filename, 'hectares_allocated_per_crop_type_lhv', 'units', 'hectares');
% 
% nccreate(filename, 'hectares_allocated_per_crop_type_hhv', 'Dimensions', {'dim1', inf})
% ncwriteatt(filename, 'hectares_allocated_per_crop_type_hhv', 'standard_name', 'hectares_allocated_per_crop_type_hhv')
% ncwriteatt(filename, 'hectares_allocated_per_crop_type_hhv', 'long_name', 'hectares_allocated_per_crop_type_hhv')
% ncwriteatt(filename, 'hectares_allocated_per_crop_type_hhv', 'units', 'hectares');

nccreate(filename, 'crop_descriptions_array', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'crop_descriptions_array', 'standard_name', 'crop_descriptions');
ncwriteatt(filename, 'crop_descriptions_array', 'long_name', 'crop_descriptions_array')
ncwriteatt(filename, 'crop_descriptions_array', 'units', ''); 



nccreate(filename,'delta_primary_energy_lhv_between_ir_rf_MJ_perYear','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_primary_energy_lhv_between_ir_rf_MJ_perYear', 'standard_name', 'delta_primary_energy_lhv_between_ir_rf_MJ_perYear');
ncwriteatt(filename, 'delta_primary_energy_lhv_between_ir_rf_MJ_perYear', 'long_name', 'delta_primary_energy_lhv_between_ir_rf_MJ_perYear');
ncwriteatt(filename, 'delta_primary_energy_lhv_between_ir_rf_MJ_perYear', 'units', 'MJ/year');
ncwriteatt(filename, 'delta_primary_energy_lhv_between_ir_rf_MJ_perYear', 'missing_value', '-999');

nccreate(filename,'delta_primary_energy_hhv_between_ir_rf_MJ_perYear','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_primary_energy_hhv_between_ir_rf_MJ_perYear', 'standard_name', 'delta_primary_energy_hhv_between_ir_rf_MJ_perYear');
ncwriteatt(filename, 'delta_primary_energy_hhv_between_ir_rf_MJ_perYear', 'long_name', 'delta_primary_energy_hhv_between_ir_rf_MJ_perYear');
ncwriteatt(filename, 'delta_primary_energy_hhv_between_ir_rf_MJ_perYear', 'units', 'MJ/year');
ncwriteatt(filename, 'delta_primary_energy_hhv_between_ir_rf_MJ_perYear', 'missing_value', '-999');

nccreate(filename,'delta_primary_energy_lhv_between_ir_rf_TJ_perYear','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_primary_energy_lhv_between_ir_rf_TJ_perYear', 'standard_name', 'delta_primary_energy_lhv_between_ir_rf_TJ_perYear');
ncwriteatt(filename, 'delta_primary_energy_lhv_between_ir_rf_TJ_perYear', 'long_name', 'delta_primary_energy_lhv_between_ir_rf_TJ_perYear');
ncwriteatt(filename, 'delta_primary_energy_lhv_between_ir_rf_TJ_perYear', 'units', 'TJ/year');
ncwriteatt(filename, 'delta_primary_energy_lhv_between_ir_rf_TJ_perYear', 'missing_value', '-999');

nccreate(filename,'delta_primary_energy_hhv_between_ir_rf_TJ_perYear','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_primary_energy_hhv_between_ir_rf_TJ_perYear', 'standard_name', 'delta_primary_energy_hhv_between_ir_rf_TJ_perYear');
ncwriteatt(filename, 'delta_primary_energy_hhv_between_ir_rf_TJ_perYear', 'long_name', 'delta_primary_energy_hhv_between_ir_rf_TJ_perYear');
ncwriteatt(filename, 'delta_primary_energy_hhv_between_ir_rf_TJ_perYear', 'units', 'TJ/year');
ncwriteatt(filename, 'delta_primary_energy_hhv_between_ir_rf_TJ_perYear', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_lhv_MJ_per_mm','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm', 'standard_name', 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm', 'long_name', 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm', 'units', 'MJ/mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_hhv_MJ_per_mm','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm', 'standard_name', 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm', 'long_name', 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm', 'units', 'MJ/mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_lhv_GJ_per_mm','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm', 'standard_name', 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm', 'long_name', 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm', 'units', 'GJ/mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_hhv_GJ_per_mm','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm', 'standard_name', 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm', 'long_name', 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm', 'units', 'GJ/mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv', 'standard_name', 'primary_energy_gain_per_irrigation_lhv');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv', 'long_name', 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv', 'units', 'MJ/mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_lhv', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_hhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv', 'standard_name', 'primary_energy_gain_per_irrigation_hhv');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv', 'long_name', 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv', 'units', 'MJ/mm');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_hhv', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_per_hectare_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', 'standard_name', 'primary_energy_gain_per_irrigation_hhv');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', 'long_name', 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm_per_hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', 'units', 'MJ/mm/hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_per_hectare_hhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', 'standard_name', 'primary_energy_gain_per_irrigation_per_hectare_hhv');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', 'long_name', 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm_per_hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', 'units', 'MJ/mm/hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_per_hectare_lhv_GJ_per_mm_ha','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv_GJ_per_mm_ha', 'standard_name', 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm_ha');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv_GJ_per_mm_ha', 'long_name', 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm_per_hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv_GJ_per_mm_ha', 'units', 'GJ/mm/hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv_GJ_per_mm_ha', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_per_hectare_hhv_GJ_per_mm_ha','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv_GJ_per_mm_ha', 'standard_name', 'primary_energy_gain_per_irrigation_per_hectare_hhv');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv_GJ_per_mm_ha', 'long_name', 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm_per_hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv_GJ_per_mm_ha', 'units', 'GJ/mm/hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv_GJ_per_mm_ha', 'missing_value', '-999');


nccreate(filename,'primary_energy_gain_per_irrigation_per_hectare_4plot_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_lhv', 'standard_name', 'primary_energy_gain_per_irrigation_hhv');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_lhv', 'long_name', 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm_per_hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_lhv', 'units', 'GJ/mm/hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_lhv', 'missing_value', '-999');

nccreate(filename,'primary_energy_gain_per_irrigation_per_hectare_4plot_hhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_hhv', 'standard_name', 'primary_energy_gain_per_irrigation_per_hectare_hhv');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_hhv', 'long_name', 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm_per_hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_hhv', 'units', 'GJ/mm/hectare');
ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_hhv', 'missing_value', '-999');

% nccreate(filename,'primary_energy_gain_per_irrigation_per_hectare_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
% ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', 'standard_name', 'primary_energy_gain_per_irrigation_hhv');
% ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', 'long_name', 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm_per_hectare');
% ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', 'units', 'TJ/mm/hectare');
% ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', 'missing_value', '-999');
% 
% nccreate(filename,'primary_energy_gain_per_irrigation_per_hectare_hhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
% ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', 'standard_name', 'primary_energy_gain_per_irrigation_per_hectare_hhv');
% ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', 'long_name', 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm_per_hectare');
% ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', 'units', 'TJ/mm/hectare');
% ncwriteatt(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', 'missing_value', '-999');

nccreate(filename,'water_deficit_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_deficit_lhv', 'standard_name', 'water_deficit_lhv_mm');
ncwriteatt(filename, 'water_deficit_lhv', 'long_name', 'water_deficit_lhv_mm');
ncwriteatt(filename, 'water_deficit_lhv', 'units', 'mm');
ncwriteatt(filename, 'water_deficit_lhv', 'missing_value', '-999');

nccreate(filename,'water_deficit_hhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_deficit_hhv', 'standard_name', 'water_deficit_hhv_mm');
ncwriteatt(filename, 'water_deficit_hhv', 'long_name', 'water_deficit_hhv_mm');
ncwriteatt(filename, 'water_deficit_hhv', 'units', 'mm');
ncwriteatt(filename, 'water_deficit_hhv', 'missing_value', '-999');

nccreate(filename,'water_use_to_irrigate_low_water_scarcity_areas_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_use_to_irrigate_low_water_scarcity_areas_lhv', 'standard_name', 'water_use_to_irrigate_low_water_scarcity_areas_lhv');
ncwriteatt(filename, 'water_use_to_irrigate_low_water_scarcity_areas_lhv', 'long_name', 'water_use_to_irrigate_low_water_scarcity_areas_lhv_m3');
ncwriteatt(filename, 'water_use_to_irrigate_low_water_scarcity_areas_lhv', 'units', 'm3');
ncwriteatt(filename, 'water_use_to_irrigate_low_water_scarcity_areas_lhv', 'missing_value', '-999');

nccreate(filename,'water_use_to_irrigate_low_water_scarcity_areas_hhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_use_to_irrigate_low_water_scarcity_areas_hhv', 'standard_name', 'water_use_to_irrigate_low_water_scarcity_areas_lhv');
ncwriteatt(filename, 'water_use_to_irrigate_low_water_scarcity_areas_hhv', 'long_name', 'water_use_to_irrigate_low_water_scarcity_areas_lhv_m3');
ncwriteatt(filename, 'water_use_to_irrigate_low_water_scarcity_areas_hhv', 'units', 'm3');
ncwriteatt(filename, 'water_use_to_irrigate_low_water_scarcity_areas_hhv', 'missing_value', '-999');

nccreate(filename,'water_use_to_irrigate_lhv_total_low_water_scarcity_areas_m3', 'Datatype', 'double');
ncwriteatt(filename, 'water_use_to_irrigate_lhv_total_low_water_scarcity_areas_m3', 'standard_name', 'water_use_to_irrigate_lhv_total_low_water_scarcity_areas_m3');
ncwriteatt(filename, 'water_use_to_irrigate_lhv_total_low_water_scarcity_areas_m3', 'long_name', 'water_use_to_irrigate_lhv_total_low_water_scarcity_areas_m3');
ncwriteatt(filename, 'water_use_to_irrigate_lhv_total_low_water_scarcity_areas_m3', 'units', 'm3');
ncwriteatt(filename, 'water_use_to_irrigate_lhv_total_low_water_scarcity_areas_m3', 'missing_value', '-999');

nccreate(filename,'water_use_to_irrigate_hhv_total_low_water_scarcity_areas_m3', 'Datatype', 'double');
ncwriteatt(filename, 'water_use_to_irrigate_hhv_total_low_water_scarcity_areas_m3', 'standard_name', 'water_use_to_irrigate_hhv_total_low_water_scarcity_areas_m3');
ncwriteatt(filename, 'water_use_to_irrigate_hhv_total_low_water_scarcity_areas_m3', 'long_name', 'water_use_to_irrigate_hhv_total_low_water_scarcity_areas_m3');
ncwriteatt(filename, 'water_use_to_irrigate_hhv_total_low_water_scarcity_areas_m3', 'units', 'm3');
ncwriteatt(filename, 'water_use_to_irrigate_hhv_total_low_water_scarcity_areas_m3', 'missing_value', '-999');

nccreate(filename,'waterUsePerEnergyYieldGain_lhv', 'Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'waterUsePerEnergyYieldGain_lhv', 'standard_name', 'waterUsePerEnergyYieldGain_lhv');
ncwriteatt(filename, 'waterUsePerEnergyYieldGain_lhv', 'long_name', 'waterUsePerEnergyYieldGain_lhv');
ncwriteatt(filename, 'waterUsePerEnergyYieldGain_lhv', 'units', 'mm ha GJ-1');
ncwriteatt(filename, 'waterUsePerEnergyYieldGain_lhv', 'missing_value', '-999');

nccreate(filename,'identified_land_fractions_of_cell','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_fractions_of_cell', 'standard_name', 'identified_land_fractions_of_cell');
ncwriteatt(filename, 'identified_land_fractions_of_cell', 'long_name', 'identified_land_fractions_of_cell');
ncwriteatt(filename, 'identified_land_fractions_of_cell', 'units', '');
ncwriteatt(filename, 'identified_land_fractions_of_cell', 'missing_value', '-999');

nccreate(filename,'identified_land_hectare','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_hectare', 'standard_name', 'identified_land_hectare');
ncwriteatt(filename, 'identified_land_hectare', 'long_name', 'identified_land_hectare');
ncwriteatt(filename, 'identified_land_hectare', 'units', 'ha');
ncwriteatt(filename, 'identified_land_hectare', 'missing_value', '-999');

nccreate(filename,'identified_land_hectare_4plot','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_hectare_4plot', 'standard_name', 'identified_land_hectare');
ncwriteatt(filename, 'identified_land_hectare_4plot', 'long_name', 'identified_land_hectare');
ncwriteatt(filename, 'identified_land_hectare_4plot', 'units', 'ha');
ncwriteatt(filename, 'identified_land_hectare_4plot', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'optimal_crop_ID_lhv', obj.primaryEnergyMatrix_cropIDs_lhv);
ncwrite(filename, 'optimal_crop_ID_hhv', obj.primaryEnergyMatrix_cropIDs_hhv);
ncwrite(filename, 'year', obj.year);
ncwrite(filename, 'scenario_description', char(obj.scenarioDescription_string));
ncwrite(filename, 'primary_energy_potential_lhv', obj.primaryEnergyMatrix_MJ_perYear_lhv);
ncwrite(filename, 'primary_energy_potential_hhv', obj.primaryEnergyMatrix_MJ_perYear_hhv);
ncwrite(filename, 'estimated_total_primary_energy_potential_lhv', obj.primaryEnergy_total_EJ_perYear_lhv);
ncwrite(filename, 'estimated_total_primary_energy_potential_hhv', obj.primaryEnergy_total_EJ_perYear_hhv);
ncwrite(filename, 'identified_land_fractions_of_cell', identifiedLand_fractions);
ncwrite(filename, 'irrigation_matrix_binary', obj.irrigation_binaryMatrix);
ncwrite(filename, 'identified_land_hectare', identifiedLandMatrix_hectares);
%Identified land with missing values
identifiedLandMatrix_hectares_withNaNs = identifiedLandMatrix_hectares;
identifiedLandMatrix_hectares_withNaNs(identifiedLandMatrix_hectares == 0) = -999;
ncwrite(filename, 'identified_land_hectare_4plot', identifiedLandMatrix_hectares_withNaNs);

%ncwrite(filename, 'hectares_allocated_per_crop_type_lhv', obj.landAllocatedToEachCropType_lhv_vector_hectare);
%ncwrite(filename, 'hectares_allocated_per_crop_type_hhv', obj.landAllocatedToEachCropType_hhv_vector_hectare);

cropType_descriptions = {obj.CropType_array.description};
for i = 1:length(cropType_descriptions)
ncwrite(filename, 'crop_descriptions_array', cropType_descriptions{i}, i);
end
%Water deficit estimations
if obj.waterDeficitIsConsidered == 1
    ncwrite(filename, 'delta_primary_energy_lhv_between_ir_rf_MJ_perYear', obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear);
    ncwrite(filename, 'delta_primary_energy_hhv_between_ir_rf_MJ_perYear', obj.deltaPrimaryEnergy_hhv_ir_rf_MJ_perYear);
    ncwrite(filename, 'delta_primary_energy_lhv_between_ir_rf_TJ_perYear', obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-6);
    ncwrite(filename, 'delta_primary_energy_hhv_between_ir_rf_TJ_perYear', obj.deltaPrimaryEnergy_hhv_ir_rf_MJ_perYear*10^-6);
    ncwrite(filename, 'primary_energy_gain_per_irrigation_lhv_MJ_per_mm', obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm);
    ncwrite(filename, 'primary_energy_gain_per_irrigation_hhv_MJ_per_mm', obj.primaryEnergyGainPerIrrigation_hhv_MJ_per_mm);
    ncwrite(filename, 'primary_energy_gain_per_irrigation_lhv_GJ_per_mm', obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm*10^-3);
    ncwrite(filename, 'primary_energy_gain_per_irrigation_hhv_GJ_per_mm', obj.primaryEnergyGainPerIrrigation_hhv_MJ_per_mm*10^-3);
    ncwrite(filename, 'water_use_to_irrigate_low_water_scarcity_areas_lhv', obj.waterUseToIrrigateMatrix_lowWaterScarcityAreas_lhv);
    ncwrite(filename, 'water_use_to_irrigate_low_water_scarcity_areas_hhv', obj.waterUseToIrrigateMatrix_lowWaterScarcityAreas_hhv);
    ncwrite(filename, 'water_use_to_irrigate_lhv_total_low_water_scarcity_areas_m3', obj.waterUseToIrrigate_lhv_total_lowWaterScarcityAreas_m3);
    ncwrite(filename, 'water_use_to_irrigate_hhv_total_low_water_scarcity_areas_m3', obj.waterUseToIrrigate_hhv_total_lowWaterScarcityAreas_m3);
    ncwrite(filename, 'water_deficit_lhv', obj.waterDeficit_lhv_mm);
    ncwrite(filename, 'water_deficit_hhv', obj.waterDeficit_hhv_mm);
    ncwrite(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv', obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare);
    ncwrite(filename, 'primary_energy_gain_per_irrigation_per_hectare_hhv', obj.primaryEnergyGainPerIrrigation_hhv_MJ_per_mm_per_hectare);
    
    
    mm_ha_perGJ = obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ;
    mm_ha_perGJ(isnan(mm_ha_perGJ)) = -999;
    ncwrite(filename, 'waterUsePerEnergyYieldGain_lhv', mm_ha_perGJ);
    
    GJperHa_withNaNs =obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm*10^-3;
    GJperHa_withNaNs(GJperHa_withNaNs == 0) = -999;
    GJperHa_withNaNs(obj.waterUseToIrrigate_lhv_total_lowWaterScarcityAreas_m3 == 0) = -999;
    ncwrite(filename, 'primary_energy_gain_per_irrigation_per_hectare_4plot_lhv', GJperHa_withNaNs);
    
    primaryEnergyGainPerIrrigation = obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare*10^-3;
    primaryEnergyGainPerIrrigation(isnan(primaryEnergyGainPerIrrigation)) = -999;
    
    ncwrite(filename, 'primary_energy_gain_per_irrigation_per_hectare_lhv_GJ_per_mm_ha', primaryEnergyGainPerIrrigation);
    
end
end

