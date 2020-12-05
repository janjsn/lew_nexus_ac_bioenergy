function makeNcFile_cropYields_tonsPerYear_andMore(obj, filename, outputFolder)
%MAKENCFILE_CROPYIELDS_TONSPERYEAR Summary of this function goes here
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
            
            lon = obj.longitudeVector_leftCorner;
            lat = obj.latitudeVector_upperCorner;
            
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


            nccreate(filename, 'Crop_yields_tons_per_year_global', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'Crop_yields_tons_per_year_global', 'standard_name', 'Crop_yields_tons_per_year_global');
            ncwriteatt(filename, 'Crop_yields_tons_per_year_global', 'long_name', 'Crop_yields_tons_per_year_global');
			ncwriteatt(filename, 'Crop_yields_tons_per_year_global', 'units', 'ton_per_year');
			ncwriteatt(filename, 'Crop_yields_tons_per_year_global', 'missing_value', '-999');
            
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
            
            nccreate(filename, 'Primary_energy_output_identified_land_spatial_hhv_MJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_hhv_MJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_hhv_MJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_hhv_MJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_hhv_MJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_hhv_MJ_per_year', 'units', 'MJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_hhv_MJ_per_year', 'missing_value', '-999');
            
            nccreate(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'standard_name', 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'long_name', 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'units', 'MJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', 'missing_value', '-999');
            
            nccreate(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_MJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_MJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_MJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_MJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_MJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_MJ_per_year', 'units', 'MJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_MJ_per_year', 'missing_value', '-999');
            
            %TJ per year primary energy
            nccreate(filename, 'Primary_energy_output_identified_land_spatial_lhv_TJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_TJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_lhv_TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_TJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_lhv_TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_TJ_per_year', 'units', 'TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_lhv_TJ_per_year', 'missing_value', '-999');
            
            nccreate(filename, 'Primary_energy_output_identified_land_spatial_hhv_TJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_hhv_TJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_hhv_TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_hhv_TJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_hhv_TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_hhv_TJ_per_year', 'units', 'TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_hhv_TJ_per_year', 'missing_value', '-999');
            
            nccreate(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_TJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_TJ_per_year', 'standard_name', 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv_TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_TJ_per_year', 'long_name', 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv_TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_TJ_per_year', 'units', 'TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_TJ_per_year', 'missing_value', '-999');
            
            nccreate(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_TJ_per_year', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_TJ_per_year', 'standard_name', 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_TJ_per_year', 'long_name', 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_TJ_per_year', 'units', 'TJ_per_year');
			ncwriteatt(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_TJ_per_year', 'missing_value', '-999');
            
            nccreate(filename, 'Primary_energy_output_identified_land_total_lhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_total_lhv_EJ', 'standard_name', 'Primary_energy_output_identified_land_total_lhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_total_lhv_EJ', 'long_name', 'Primary_energy_output_identified_land_total_lhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_total_lhv_EJ', 'units', 'EJ');
            
            nccreate(filename, 'Primary_energy_output_identified_land_total_hhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_total_hhv_EJ', 'standard_name', 'Primary_energy_output_identified_land_total_hhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_total_hhv_EJ', 'long_name', 'Primary_energy_output_identified_land_total_hhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_total_hhv_EJ', 'units', 'EJ');
            
            nccreate(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_lhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_lhv_EJ', 'standard_name', 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_lhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_lhv_EJ', 'long_name', 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_lhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_lhv_EJ', 'units', 'EJ');
            
            nccreate(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_hhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_hhv_EJ', 'standard_name', 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_hhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_hhv_EJ', 'long_name', 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_hhv_EJ');
            ncwriteatt(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_hhv_EJ', 'units', 'EJ');
            
            %% WRITE
            ncwrite(filename, 'description', obj.cropname);
            ncwrite(filename,  'year', obj.year);
            ncwrite(filename, 'crop_ID',obj.cropID);
            ncwrite(filename, 'climate_scenario_ID',obj.climateScenarioID);
            ncwrite(filename, 'input_level', obj.inputRate);
            ncwrite(filename, 'irrigation_is_assumed',obj.isIrrigated);
			ncwrite(filename,'lat',obj.latitudeVector_upperCorner);	
			ncwrite(filename,'lon',obj.longitudeVector_leftCorner);
            ncwrite(filename, 'Identified_land_matrix_fractions', obj.fractionsMatrix_identifiedLand)
            ncwrite(filename, 'Identified_land_matrix_hectare', obj.areaMatrix_identifiedLand_ha);
            ncwrite(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_fractions', obj.fractionsMatrix_excludingBiodiversityHotspots_identifiedLand);
            ncwrite(filename, 'Identified_land_matrix_excluding_biodiversity_hotspots_hectare', obj.areaMatrix_excludingBiodiversityHotspots_identifiedLand_ha);
			ncwrite(filename, 'Crop_yields_tons_per_year_global', obj.dataMatrix_lonXlat_multiplicationFactorAccounted);
            ncwrite(filename, 'Crop_yields_tons_per_year_identified_land', obj.cropYield_identifiedLands_tonsPerYear);
            ncwrite(filename, 'Crop_yields_tons_per_year_identified_land_excluding_biodiversity_hotspots', obj.cropYield_identifiedLands_excludingBiodHotspots_tonsPerYear_sum);
            
            %ncwrite(filename, 'Primary_energy_output_global_spatial_lhv', obj.primaryEnergyOutput_spatial_lhv_MJ_perYear);
            %ncwrite(filename, 'Primary_energy_output_global_spatial_hhv', obj.primaryEnergyOutput_spatial_hhv_MJ_perYear);
            %ncwrite(filename, 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_lhv', obj.primaryEnergyOutput_excludingBH_spatial_lhv_MJ_perYear);
            %ncwrite(filename, 'Primary_energy_output_global_spatial_excluding_biodiversity_hotspots_hhv', obj.primaryEnergyOutput_excludingBH_spatial_hhv_MJ_perYear);
            
            ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_MJ_per_year', obj.primaryEnergyOutput_spatial_lhv_MJ_perYear);
            ncwrite(filename, 'Primary_energy_output_identified_land_spatial_hhv_MJ_per_year', obj.primaryEnergyOutput_spatial_hhv_MJ_perYear);
            ncwrite(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_MJ_per_year', obj.primaryEnergyOutput_excludingBH_spatial_lhv_MJ_perYear);
            ncwrite(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_MJ_per_year', obj.primaryEnergyOutput_excludingBH_spatial_hhv_MJ_perYear);
            
            ncwrite(filename, 'Primary_energy_output_identified_land_spatial_lhv_TJ_per_year', obj.primaryEnergyOutput_spatial_lhv_MJ_perYear*10^-6);
            ncwrite(filename, 'Primary_energy_output_identified_land_spatial_hhv_TJ_per_year', obj.primaryEnergyOutput_spatial_hhv_MJ_perYear*10^-6);
            ncwrite(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_lhv_TJ_per_year', obj.primaryEnergyOutput_excludingBH_spatial_lhv_MJ_perYear*10^-6);
            ncwrite(filename, 'Primary_energy_output_identified_land_spatial_excluding_biodiversity_hotspots_hhv_TJ_per_year', obj.primaryEnergyOutput_excludingBH_spatial_hhv_MJ_perYear*10^-6);
            
            ncwrite(filename, 'Primary_energy_output_identified_land_total_lhv_EJ', obj.primaryEnergyOutput_total_lhv_EJ_perYear);
            ncwrite(filename, 'Primary_energy_output_identified_land_total_hhv_EJ', obj.primaryEnergyOutput_total_hhv_EJ_perYear);
            ncwrite(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_lhv_EJ', obj.primaryEnergyOutput_excludingBH_total_lhv_EJ_perYear);
            ncwrite(filename, 'Primary_energy_output_identified_land_excluding_biodiversity_hotspots_total_hhv_EJ', obj.primaryEnergyOutput_excludingBH_total_hhv_EJ_perYear);
            

            
end

