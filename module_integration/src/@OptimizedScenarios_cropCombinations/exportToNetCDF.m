function exportToNetCDF( obj, outputFolder, latitudeVector, longitudeVector, identifiedLand_fractions )
%EXPORTTONETCDF Summary of this function goes here
%   Detailed explanation goes here

lon = longitudeVector;
lat = latitudeVector;

%Making sure output folder exist
if exist([outputFolder '/NC files/Optimal solutions/'],'dir') ~= 7
    mkdir([outputFolder '/NC files/Optimal solutions/']);
end

outputFolder = [outputFolder '/NC files/Optimal solutions/'];
timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

filename = [outputFolder obj.scenarioDescription_string '_optimal_solution_' timestamp '.nc'];

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

nccreate(filename,'identified_land_hectares','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_hectares', 'standard_name', 'identified_land_fractions');
ncwriteatt(filename, 'identified_land_hectares', 'long_name', 'identified_land_fractions');
ncwriteatt(filename, 'identified_land_hectares', 'units', '');
ncwriteatt(filename, 'identified_land_hectares', 'missing_value', '-999');

nccreate(filename,'identified_land_fractions','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_fractions', 'standard_name', 'identified_land_fractions');
ncwriteatt(filename, 'identified_land_fractions', 'long_name', 'identified_land_fractions');
ncwriteatt(filename, 'identified_land_fractions', 'units', '');
ncwriteatt(filename, 'identified_land_fractions', 'missing_value', '-999');

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

nccreate(filename, 'hectares_allocated_per_crop_type_lhv', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'hectares_allocated_per_crop_type_lhv', 'standard_name', 'hectares_allocated_per_crop_type_lhv')
ncwriteatt(filename, 'hectares_allocated_per_crop_type_lhv', 'long_name', 'hectares_allocated_per_crop_type_lhv')
ncwriteatt(filename, 'hectares_allocated_per_crop_type_lhv', 'units', 'hectares');

nccreate(filename, 'hectares_allocated_per_crop_type_hhv', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'hectares_allocated_per_crop_type_hhv', 'standard_name', 'hectares_allocated_per_crop_type_hhv')
ncwriteatt(filename, 'hectares_allocated_per_crop_type_hhv', 'long_name', 'hectares_allocated_per_crop_type_hhv')
ncwriteatt(filename, 'hectares_allocated_per_crop_type_hhv', 'units', 'hectares');

nccreate(filename, 'crop_descriptions_array', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'crop_descriptions_array', 'standard_name', 'crop_descriptions');
ncwriteatt(filename, 'crop_descriptions_array', 'long_name', 'crop_descriptions_array')
ncwriteatt(filename, 'crop_descriptions_array', 'units', ''); 

nccreate(filename,'delta_primary_energy_potential_compared_to_baseline_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'delta_primary_energy_potential_compared_to_baseline_lhv', 'standard_name', 'delta_primary_energy_potential_compared_to_baseline_lhv');
ncwriteatt(filename, 'delta_primary_energy_potential_compared_to_baseline_lhv', 'long_name', 'delta_primary_energy_potential_compared_to_baseline_lhv');
ncwriteatt(filename, 'delta_primary_energy_potential_compared_to_baseline_lhv', 'units', 'MJ/year');
ncwriteatt(filename, 'delta_primary_energy_potential_compared_to_baseline_lhv', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'optimal_crop_ID_lhv', obj.spatialOptimizationMatrix_cropIDs_lhv);
ncwrite(filename, 'optimal_crop_ID_hhv', obj.spatialOptimizationMatrix_cropIDs_hhv);
ncwrite(filename, 'year', obj.year);
ncwrite(filename, 'scenario_description', char(obj.scenarioDescription_string));
ncwrite(filename, 'primary_energy_potential_lhv', obj.spatialOptimizationMatrix_MJ_perYear_lhv);
ncwrite(filename, 'primary_energy_potential_hhv', obj.spatialOptimizationMatrix_MJ_perYear_hhv);
ncwrite(filename, 'estimated_total_primary_energy_potential_lhv', obj.spatialOptimization_total_EJ_perYear_lhv);
ncwrite(filename, 'estimated_total_primary_energy_potential_hhv', obj.spatialOptimization_total_EJ_perYear_hhv);
ncwrite(filename, 'hectares_allocated_per_crop_type_lhv', obj.landAllocatedToEachCropType_lhv_vector_hectare);
ncwrite(filename, 'hectares_allocated_per_crop_type_hhv', obj.landAllocatedToEachCropType_hhv_vector_hectare);
ncwrite(filename, 'identified_land_fractions', identifiedLand_fractions);
ncwrite(filename, 'delta_primary_energy_potential_compared_to_baseline_lhv', obj.delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv);

cropType_descriptions = {obj.CropType_array.description};
for i = 1:length(cropType_descriptions)
ncwrite(filename, 'crop_descriptions_array', cropType_descriptions{i}, i);
end

%% EXPORTING WITH MISSING VALUES FOR PLOTTING

nccreate(filename,'optimal_crop_ID_lhv_4plot','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'optimal_crop_ID_lhv_4plot', 'standard_name', 'optimal_crop_ID_lhv_4plot');
ncwriteatt(filename, 'optimal_crop_ID_lhv_4plot', 'long_name', 'optimal_crop_ID_lhv_4plot');
ncwriteatt(filename, 'optimal_crop_ID_lhv_4plot', 'units', '');
ncwriteatt(filename, 'optimal_crop_ID_lhv_4plot', 'missing_value', '-999');

cropID_matrix_4plot = obj.spatialOptimizationMatrix_cropIDs_lhv;
cropID_matrix_4plot(cropID_matrix_4plot == 0) = -999;
ncwrite(filename, 'optimal_crop_ID_lhv_4plot', cropID_matrix_4plot);




end

