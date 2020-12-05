function export2netcdf_aggregatedResults( obj, filename, outputFolder, identificationVector)
%Exporting aggregated results with/without Biodversity hotspots for
%optimized crop combinations
%13.11.2019

%Identification vector: [climateScenarioID irrigationLevel inputLevel
%year]

if exist([outputFolder],'dir') ~= 7
    mkdir([outputFolder]);
end

filename = [outputFolder filename];

if exist(filename) == 2
    delete(filename)
end

lat = obj.latitudeVector_centered;
lon = obj.longitudeVector_centered;

nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'description', 'standard_name', 'description');
ncwriteatt(filename, 'description', 'long_name', 'description');

nccreate(filename, 'year');
ncwriteatt(filename, 'year', 'standard_name', 'year');
ncwriteatt(filename, 'year', 'long_name', 'year');

nccreate(filename, 'climate_scenario_ID');
ncwriteatt(filename, 'climate_scenario_ID', 'standard_name', 'climate_scenario_ID');
ncwriteatt(filename, 'climate_scenario_ID', 'long_name', 'climate_scenario_ID');

nccreate(filename, 'input_level')
ncwriteatt(filename, 'input_level', 'standard_name', 'input_level')
ncwriteatt(filename, 'input_level', 'long_name', 'input_level_agricultural_management_and_fertilizer')

nccreate(filename, 'irrigation_is_assumed')
ncwriteatt(filename, 'irrigation_is_assumed', 'standard_name', 'irrigation_is_assumed')
ncwriteatt(filename, 'irrigation_is_assumed', 'long_name', 'irrigation_is_assumed_0=rainfed_1=irrigated')

nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees_north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename, 'lat', 'axis', 'Y'); 

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X'); 

%MJ per year primary energy
nccreate(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'units', 'MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'missing_value', '-999');

%PJ per year primary energy
nccreate(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'missing_value', '-999');


%Excluded biodiversity hotspots: MJ per year primary energy
nccreate(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year', 'long_name', 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year', 'units', 'MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year', 'missing_value', '-999');

%Excluded biodiversity hotspots: PJ per year primary energy
nccreate(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year', 'long_name', 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year', 'missing_value', '-999');

%Energy yields GJ ha-1 yr-1
nccreate(filename, 'Bioenergy_yields_identified_land_spatial_lhv_GJ_per_ha_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Bioenergy_yields_identified_land_spatial_lhv_GJ_per_ha_year', 'standard_name', 'Bioenergy_yields_identified_land_spatial_lhv_GJ_per_year');
ncwriteatt(filename, 'Bioenergy_yields_identified_land_spatial_lhv_GJ_per_ha_year', 'long_name', 'Bioenergy_yields_identified_land_spatial_lhv_GJ_per_year');
ncwriteatt(filename, 'Bioenergy_yields_identified_land_spatial_lhv_GJ_per_ha_year', 'units', 'GJ ha-1 yr-1');
ncwriteatt(filename, 'Bioenergy_yields_identified_land_spatial_lhv_GJ_per_ha_year', 'missing_value', '-999');

%delta compared to baseline, MJ per year primary energy
nccreate(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'standard_name', 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'long_name', 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'units', 'MJ_per_year');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'missing_value', '-999');

%delta compared to baseline, PJ per year primary energy
nccreate(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'standard_name', 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'long_name', 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'missing_value', '-999');

%fractional change compared to baseline, PJ per year primary energy
nccreate(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'standard_name', 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'long_name', 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'units', '');
ncwriteatt(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'missing_value', '-999');

%percentage change compared to baseline, PJ per year primary energy
nccreate(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'standard_name', 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'long_name', 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'units', '%');
ncwriteatt(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'year', identificationVector(4));
ncwrite(filename, 'climate_scenario_ID', identificationVector(1));
ncwrite(filename, 'input_level', identificationVector(3));
ncwrite(filename, 'irrigation_is_assumed', identificationVector(2));
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', obj.spatialOptimizationMatrix_MJ_perYear_lhv);
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.spatialOptimizationMatrix_PJ_perYear_lhv);
ncwrite(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year', obj.excluded_BH_spatialOptimizationMatrix_MJ_perYear_lhv);
ncwrite(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year', obj.excluded_BH_spatialOptimizationMatrix_PJ_perYear_lhv);
ncwrite(filename, 'Bioenergy_yields_identified_land_spatial_lhv_GJ_per_ha_year', obj.spatialOptimizationMatrix_bioenergyYields_GJ_perHaYear_lhv);

addDeltas = 0;
if addDeltas == 1
ncwrite(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year', obj.delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv);
ncwrite(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.delta_fromBaseline_spatialOptimizationMatrix_PJ_perYear_lhv);
ncwrite(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv);
ncwrite(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv);
end
%% Setting zeros to missing values and exporting for Panoply purposes

%PJ per year primary energy
nccreate(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'standard_name', 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'long_name', 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'missing_value', '-999');

%Excluded biodiversity hotspots: PJ per year primary energy
nccreate(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot', 'standard_name', 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot', 'long_name', 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot', 'missing_value', '-999');

%delta compared to baseline, MJ per year primary energy
nccreate(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot', 'standard_name', 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot', 'long_name', 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot', 'units', 'MJ_per_year');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot', 'missing_value', '-999');

%delta compared to baseline, PJ per year primary energy
nccreate(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'standard_name', 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'long_name', 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'missing_value', '-999');

%fractional change compared to baseline, PJ per year primary energy
nccreate(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'standard_name', 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'long_name', 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'units', '');
ncwriteatt(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'missing_value', '-999');

%percentage change compared to baseline, PJ per year primary energy
nccreate(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'standard_name', 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot');
ncwriteatt(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'long_name', 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot');
ncwriteatt(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'units', '%');
ncwriteatt(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', 'missing_value', '-999');


matrix_PJperYear = obj.spatialOptimizationMatrix_PJ_perYear_lhv;
matrix_PJperYear(matrix_PJperYear == 0) = -999;
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot',matrix_PJperYear);

matrix_noBH_PJperYear = obj.excluded_BH_spatialOptimizationMatrix_PJ_perYear_lhv;
matrix_noBH_PJperYear(matrix_noBH_PJperYear == 0) = -999;
ncwrite(filename,'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot', matrix_noBH_PJperYear)

%Add deltas?
addDeltas = 0;
if addDeltas == 1
matrix_delta_MJperYear = obj.delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv;
matrix_delta_MJperYear(matrix_delta_MJperYear == 0) = -999;
ncwrite(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot', matrix_delta_MJperYear);

matrix_delta_PJperYear = obj.delta_fromBaseline_spatialOptimizationMatrix_PJ_perYear_lhv;
matrix_delta_PJperYear(matrix_delta_PJperYear == 0) = -999;
ncwrite(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', matrix_delta_PJperYear);

matrix_fractionChange = obj.fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv;
matrix_fractionChange(matrix_fractionChange == 0) = -999;
ncwrite(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', matrix_fractionChange);

matrix_percentageChange = obj.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv;
matrix_percentageChange(matrix_percentageChange == 0) = -999;
ncwrite(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', matrix_percentageChange);
end

end

