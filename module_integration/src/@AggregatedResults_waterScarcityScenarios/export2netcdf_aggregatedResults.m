function export2netcdf_aggregatedResults( obj, filename, outputFolder)
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


ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', obj.primaryEnergy_MJ_perYear_lhv);
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.primaryEnergy_PJ_perYear_lhv);
ncwrite(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_MJ_per_year', obj.excluded_BH_primaryEnergy_MJ_perYear_lhv);
ncwrite(filename, 'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year', obj.excluded_BH_primaryEnergy_PJ_perYear_lhv);
% ncwrite(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year', obj.delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv);
% ncwrite(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.delta_fromBaseline_spatialOptimizationMatrix_PJ_perYear_lhv);
% ncwrite(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv);
% ncwrite(filename, 'Percentage_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv);

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


%Identified land
nccreate(filename, 'Land_abandoned_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Land_abandoned_cropland', 'standard_name', 'Land_abandoned_cropland');
ncwriteatt(filename, 'Land_abandoned_cropland', 'long_name', 'Land_abandoned_cropland');
ncwriteatt(filename, 'Land_abandoned_cropland', 'units', 'ha');
ncwriteatt(filename, 'Land_abandoned_cropland', 'missing_value', '-999');
%Identified land fractions
nccreate(filename, 'Fractions_abandoned_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Fractions_abandoned_cropland', 'standard_name', 'Fractions_abandoned_cropland');
ncwriteatt(filename, 'Fractions_abandoned_cropland', 'long_name', 'Fractions_abandoned_cropland');
ncwriteatt(filename, 'Fractions_abandoned_cropland', 'units', '');
ncwriteatt(filename, 'Fractions_abandoned_cropland', 'missing_value', '-999');

%Identified land
nccreate(filename, 'Land_abandoned_cropland_outside_biodiversity_hotspots', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Land_abandoned_cropland_outside_biodiversity_hotspots', 'standard_name', 'Land_abandoned_cropland_outside_biodiversity_hotspots');
ncwriteatt(filename, 'Land_abandoned_cropland_outside_biodiversity_hotspots', 'long_name', 'Land_abandoned_cropland_outside_biodiversity_hotspots');
ncwriteatt(filename, 'Land_abandoned_cropland_outside_biodiversity_hotspots', 'units', 'ha');
ncwriteatt(filename, 'Land_abandoned_cropland_outside_biodiversity_hotspots', 'missing_value', '-999');
%Identified land fractions
nccreate(filename, 'Fractions_abandoned_cropland_outside_biodiversity_hotspots', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Fractions_abandoned_cropland_outside_biodiversity_hotspots', 'standard_name', 'Fractions_abandoned_cropland_outside_biodiversity_hotspots');
ncwriteatt(filename, 'Fractions_abandoned_cropland_outside_biodiversity_hotspots', 'long_name', 'Fractions_abandoned_cropland_outside_biodiversity_hotspots');
ncwriteatt(filename, 'Fractions_abandoned_cropland_outside_biodiversity_hotspots', 'units', '');
ncwriteatt(filename, 'Fractions_abandoned_cropland_outside_biodiversity_hotspots', 'missing_value', '-999');

%Water use of irrigation
nccreate(filename, 'Water_use_full_irrigation', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Water_use_full_irrigation', 'standard_name', 'Water_use_full_irrigation');
ncwriteatt(filename, 'Water_use_full_irrigation', 'long_name', 'Water_use_full_irrigation');
ncwriteatt(filename, 'Water_use_full_irrigation', 'units', 'million m3');
ncwriteatt(filename, 'Water_use_full_irrigation', 'missing_value', '-999');

%Blue water footprint
nccreate(filename, 'Blue_water_footprint_full_irrigation', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Blue_water_footprint_full_irrigation', 'standard_name', 'Blue_water_footprint_full_irrigation');
ncwriteatt(filename, 'Blue_water_footprint_full_irrigation', 'long_name', 'Blue_water_footprint_full_irrigation');
ncwriteatt(filename, 'Blue_water_footprint_full_irrigation', 'units', 'm3 GJ-1');
ncwriteatt(filename, 'Blue_water_footprint_full_irrigation', 'missing_value', '-999');

%Water use cell average
nccreate(filename, 'Average_water_deficit_abandoned_cropland', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Average_water_deficit_abandoned_cropland', 'standard_name', 'Average_water_deficit_abandoned_cropland');
ncwriteatt(filename, 'Average_water_deficit_abandoned_cropland', 'long_name', 'Average_water_deficit_abandoned_cropland');
ncwriteatt(filename, 'Average_water_deficit_abandoned_cropland', 'units', 'mm');
ncwriteatt(filename, 'Average_water_deficit_abandoned_cropland', 'missing_value', '-999');

%Primary energy gain of full irrigation deployment
nccreate(filename, 'Primary energy gain of full irrigation deployment', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary energy gain of full irrigation deployment', 'standard_name', 'Primary energy gain of full irrigation deployment');
ncwriteatt(filename, 'Primary energy gain of full irrigation deployment', 'long_name', 'Primary energy gain of full irrigation deployment');
ncwriteatt(filename, 'Primary energy gain of full irrigation deployment', 'units', 'PJ yr-1');
ncwriteatt(filename, 'Primary energy gain of full irrigation deployment', 'missing_value', '-999');

%Energy yield gain of full irrigation deployment
nccreate(filename, 'Energy yield gain of full irrigation deployment', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Energy yield gain of full irrigation deployment', 'standard_name', 'Energy yield gain of full irrigation deployment');
ncwriteatt(filename, 'Energy yield gain of full irrigation deployment', 'long_name', 'Energy yield gain of full irrigation deployment');
ncwriteatt(filename, 'Energy yield gain of full irrigation deployment', 'units', 'GJ ha-1 yr-1');
ncwriteatt(filename, 'Energy yield gain of full irrigation deployment', 'missing_value', '-999');


%energy yield gain per irrigation unit GJ/ha*mm
nccreate(filename, 'Energy yield gain per unit irrigation', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Energy yield gain per unit irrigation', 'standard_name', 'Energy yield gain per unit irrigation');
ncwriteatt(filename, 'Energy yield gain per unit irrigation', 'long_name', 'Energy yield gain per unit irrigation');
ncwriteatt(filename, 'Energy yield gain per unit irrigation', 'units', 'GJ ha-1 mm-1 yr-1');
ncwriteatt(filename, 'Energy yield gain per unit irrigation', 'missing_value', '-999');

%% WRITE TO NETCDF variables
matrix_energyYieldGainPerIrrigation = obj.energyYieldGainPerIrrigation_GJ_perHaMm;
matrix_energyYieldGainPerIrrigation(matrix_energyYieldGainPerIrrigation == 0) = -999;
ncwrite(filename, 'Energy yield gain per unit irrigation', matrix_energyYieldGainPerIrrigation);

matrix_energyYieldGain = obj.energyYieldGain_lhv_ir_rf_GJ_perYearHa;
matrix_energyYieldGain(matrix_energyYieldGain == 0) = -999;
ncwrite(filename, 'Energy yield gain of full irrigation deployment', matrix_energyYieldGain);

matrix_land = obj.identifiedLandMatrix_hectare;
matrix_land(matrix_land == 0) = -999;
ncwrite(filename, 'Land_abandoned_cropland', matrix_land);

matrix_fractions = obj.identifiedLandMatrix_fractions;
matrix_fractions(matrix_fractions == 0) = -999;
ncwrite(filename, 'Fractions_abandoned_cropland', matrix_fractions);

matrix_land_bh = obj.excluded_BH_identifiedLandMatrix_hectare;
matrix_land_bh(matrix_land_bh == 0) = -999;
ncwrite(filename, 'Land_abandoned_cropland_outside_biodiversity_hotspots', matrix_land_bh);

matrix_fractions_bh = obj.excluded_BH_identifiedLandMatrix_fractions;
matrix_fractions_bh(matrix_fractions_bh == 0) = -999;
ncwrite(filename, 'Fractions_abandoned_cropland_outside_biodiversity_hotspots', matrix_fractions_bh);

matrix_waterUse_ir = obj.waterUseToIrrigate_lhv_m3*10^-6;
matrix_waterUse_ir(matrix_waterUse_ir == 0) = -999;
ncwrite(filename, 'Water_use_full_irrigation', matrix_waterUse_ir);

matrix_avg_water_def = obj.waterUse_cellAverage_mm;
matrix_avg_water_def(matrix_avg_water_def == 0) = -999;
ncwrite(filename, 'Average_water_deficit_abandoned_cropland', matrix_avg_water_def);

matrix_energyGainOfFullIrrigation = obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-9;
matrix_energyGainOfFullIrrigation(matrix_energyGainOfFullIrrigation == 0) = -999;
ncwrite(filename, 'Primary energy gain of full irrigation deployment', matrix_energyGainOfFullIrrigation);


matrix_PJperYear = obj.primaryEnergy_PJ_perYear_lhv;
matrix_PJperYear(matrix_PJperYear == 0) = -999;
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot',matrix_PJperYear);

matrix_noBH_PJperYear = obj.excluded_BH_primaryEnergy_PJ_perYear_lhv;
matrix_noBH_PJperYear(matrix_noBH_PJperYear == 0) = -999;
ncwrite(filename,'Primary_energy_output_identified_land_excluded_biodiversity_hotspots_spatial_lhv_PJ_per_year_4Plot', matrix_noBH_PJperYear)

matrix_blueWaterFootprint = obj.waterUseToIrrigate_lhv_m3./(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3);
matrix_blueWaterFootprint(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear < 0.01) = -999;
matrix_blueWaterFootprint(matrix_blueWaterFootprint == 0) = -999;
ncwrite(filename, 'Blue_water_footprint_full_irrigation', matrix_blueWaterFootprint);

% matrix_delta_MJperYear = obj.delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv;
% matrix_delta_MJperYear(matrix_delta_MJperYear == 0) = -999;
% ncwrite(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_MJ_per_year_4plot', matrix_delta_MJperYear);

% matrix_delta_PJperYear = obj.delta_fromBaseline_spatialOptimizationMatrix_PJ_perYear_lhv;
% matrix_delta_PJperYear(matrix_delta_PJperYear == 0) = -999;
% ncwrite(filename, 'Delta_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', matrix_delta_PJperYear);

% matrix_fractionChange = obj.fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv;
% matrix_fractionChange(matrix_fractionChange == 0) = -999;
% ncwrite(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', matrix_fractionChange);
% 
% matrix_percentageChange = obj.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv;
% matrix_percentageChange(matrix_percentageChange == 0) = -999;
% ncwrite(filename, 'Fractional_change_compared_to_baseline_primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4plot', matrix_percentageChange);
end

