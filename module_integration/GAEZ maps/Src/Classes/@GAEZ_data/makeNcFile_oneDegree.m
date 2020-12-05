function  makeNcFile_oneDegree( obj, filename, outputFolder )
%MAKENCFILE_ONEDEGREE Summary of this function goes here
%   Detailed explanation goes here

if exist([outputFolder],'dir') ~= 7
    mkdir([outputFolder]);
end

filename = [outputFolder filename];

% filename = [outputFolder filename]
%exist(filename)

if exist(filename) == 2
    delete(filename)
end

lat = obj.AggregatedProduction_oneDegree.latitudeVector_centered;
lon = obj.AggregatedProduction_oneDegree.longitudeVector_centered;

nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'description', 'standard_name', 'description');
ncwriteatt(filename, 'description', 'long_name', 'description');

nccreate(filename, 'year');
ncwriteatt(filename, 'year', 'standard_name', 'year');
ncwriteatt(filename, 'year', 'long_name', 'year');

nccreate(filename, 'crop_ID');
ncwriteatt(filename, 'crop_ID', 'standard_name', 'crop_ID');
ncwriteatt(filename, 'crop_ID', 'long_name', 'crop_ID');

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
ncwriteatt(filename, 'lat', 'axis', 'Y'); %ADDED 1306

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X'); %ADDED 1306

nccreate(filename, 'Identified_land_matrix_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Identified_land_matrix_fractions', 'standard_name', 'Identified_land_matrix_fractions');
ncwriteatt(filename, 'Identified_land_matrix_fractions', 'long_name', 'Identified_land_matrix_fractions');
ncwriteatt(filename, 'Identified_land_matrix_fractions', 'units', 'hectare');
ncwriteatt(filename, 'Identified_land_matrix_fractions', 'missing_value', '-999');

nccreate(filename, 'Identified_land_matrix_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Identified_land_matrix_hectare', 'standard_name', 'Identified_land_matrix_hectare');
ncwriteatt(filename, 'Identified_land_matrix_hectare', 'long_name', 'Identified_land_matrix_hectare');
ncwriteatt(filename, 'Identified_land_matrix_hectare', 'units', 'hectare');
ncwriteatt(filename, 'Identified_land_matrix_hectare', 'missing_value', '-999');

nccreate(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions', 'standard_name', 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions');
ncwriteatt(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions', 'long_name', 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions');
ncwriteatt(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions', 'units', '');
ncwriteatt(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions', 'missing_value', '-999');

nccreate(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare', 'standard_name', 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare');
ncwriteatt(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare', 'long_name', 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare');
ncwriteatt(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare', 'units', 'hectare');
ncwriteatt(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare', 'missing_value', '-999');


nccreate(filename,'Crop_yields_tons_per_year_identified_land','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Crop_yields_tons_per_year_identified_land', 'standard_name', 'Crop_yields_tons_per_year_identified_land');
ncwriteatt(filename, 'Crop_yields_tons_per_year_identified_land', 'long_name', 'Crop_yields_tons_per_year_identified_land');
ncwriteatt(filename, 'Crop_yields_tons_per_year_identified_land', 'units', 'ton_per_year');
ncwriteatt(filename, 'Crop_yields_tons_per_year_identified_land', 'missing_value', '-999');

nccreate(filename,'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots', 'standard_name', 'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots');
ncwriteatt(filename, 'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots', 'long_name', 'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots');
ncwriteatt(filename, 'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots', 'units', 'ton_per_year');
ncwriteatt(filename, 'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots', 'missing_value', '-999');

%MJ per year primary energy
nccreate(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'units', 'MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', 'missing_value', '-999');

nccreate(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'standard_name', 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'long_name', 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'units', 'MJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'missing_value', '-999');

%PJ per year primary energy
nccreate(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', 'missing_value', '-999');

nccreate(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_PJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_PJ_per_year', 'standard_name', 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_PJ_per_year', 'long_name', 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_PJ_per_year', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_PJ_per_year', 'missing_value', '-999');



ncwrite(filename, 'description', obj.cropname);
ncwrite(filename,  'year', obj.year);
ncwrite(filename, 'crop_ID',obj.cropID);
ncwrite(filename, 'climate_scenario_ID',obj.climateScenarioID);
ncwrite(filename, 'input_level', obj.inputRate);
ncwrite(filename, 'irrigation_is_assumed',obj.isIrrigated);
ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);

ncwrite(filename, 'Identified_land_matrix_fractions', obj.AggregatedProduction_oneDegree.identifiedLandMatrix_fractions)
ncwrite(filename, 'Identified_land_matrix_hectare', obj.AggregatedProduction_oneDegree.identifiedLandMatrix_hectare);
ncwrite(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions', obj.AggregatedProduction_oneDegree.identifiedLandMatrix_excludedBH_fractions);
ncwrite(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare', obj.AggregatedProduction_oneDegree.identifiedLandMatrix_excludedBH_hectare);
ncwrite(filename, 'Crop_yields_tons_per_year_identified_land', obj.AggregatedProduction_oneDegree.identifiedLand_productionMatrix_tonPerYear);
ncwrite(filename, 'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots', obj.AggregatedProduction_oneDegree.identifiedLand_productionMatrix_excludedBH_tonPerYear);
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', obj.AggregatedProduction_oneDegree.identifiedLand_energyProductionMatrix_lhv_MJ_perYear);
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', obj.AggregatedProduction_oneDegree.identifiedLand_energyProductionMatrix_lhv_excludedBH_MJ_perYear);
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year', obj.AggregatedProduction_oneDegree.identifiedLand_energyProductionMatrix_lhv_PJ_perYear);
ncwrite(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_PJ_per_year', obj.AggregatedProduction_oneDegree.identifiedLand_energyProductionMatrix_lhv_excludedBH_PJ_perYear);

%% SET 0 to missing value and write two matrices
nccreate(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'standard_name', 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'long_name', 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'units', 'PJ_per_year');
ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot', 'missing_value', '-999');

nccreate(filename, 'Identified_land_matrix_fractions_4Plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Identified_land_matrix_fractions_4Plot', 'standard_name', 'Identified_land_matrix_fractions_4Plot');
ncwriteatt(filename, 'Identified_land_matrix_fractions_4Plot', 'long_name', 'Identified_land_matrix_fractions_4Plot');
ncwriteatt(filename, 'Identified_land_matrix_fractions_4Plot', 'units', '');
ncwriteatt(filename, 'Identified_land_matrix_fractions_4Plot', 'missing_value', '-999');

nccreate(filename, 'Biodiversity_hotspots_fractions_4Plot', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Biodiversity_hotspots_fractions_4Plot', 'standard_name', 'Biodiversity_hotspots_fractions_4Plot');
ncwriteatt(filename, 'Biodiversity_hotspots_fractions_4Plot', 'long_name', 'Biodiversity_hotspots_fractions_4Plot');
ncwriteatt(filename, 'Biodiversity_hotspots_fractions_4Plot', 'units', '');
ncwriteatt(filename, 'Biodiversity_hotspots_fractions_4Plot', 'missing_value', '-999');

plotmatrix_PJ = obj.AggregatedProduction_oneDegree.identifiedLand_energyProductionMatrix_lhv_PJ_perYear;
plotmatrix_PJ(plotmatrix_PJ == 0) = -999;
ncwrite(filename,'Primary_energy_output_identified_land_spatial_lhv_PJ_per_year_4Plot',plotmatrix_PJ);

plotmatrix_fractions = obj.AggregatedProduction_oneDegree.identifiedLandMatrix_fractions;
plotmatrix_fractions(plotmatrix_fractions == 0) = -999;
ncwrite(filename, 'Identified_land_matrix_fractions_4Plot', plotmatrix_fractions);

plotmatrix_hotspotsFractions = obj.AggregatedProduction_oneDegree.biodiversityHotspots_fractions;
plotmatrix_hotspotsFractions(plotmatrix_hotspotsFractions == 0) = -999;
ncwrite(filename, 'Biodiversity_hotspots_fractions_4Plot', plotmatrix_hotspotsFractions);

end

