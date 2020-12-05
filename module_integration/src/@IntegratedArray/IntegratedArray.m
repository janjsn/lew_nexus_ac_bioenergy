classdef IntegratedArray
    %INTEGRATEDARRAY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        scenarioDescription_string
        identification_vector
        
        lat
        lon
        
        ClimateScenario
        CropType_array
        Biorefinery
        is_rainfed = 0;
        is_irrigated = 0;
        is_mixed_water_supply = 0;
        year
        areaPerLatitudeVector_hectare
        
        management_intensity_grid
        irrigated_mixed_fraction_grid
        
        land_grid_hectare
        land_nc_grid_hectare
        
        eo_rf_crop_allocation
        eo_mixed_crop_allocation
        eo_ir_crop_allocation
        co_rf_crop_allocation
        co_mixed_crop_allocation
        co_ir_crop_allocation
        
        dm_yield_unit = 'ton ha-1 yr-1'
        dm_yield_rf_low
        dm_yield_rf_med
        dm_yield_rf_high
        dm_yield_ir_med
        dm_yield_ir_high
        dm_yield_mixed
        
        pe_yield_unit = 'GJ ha-1 yr-1'
        pe_yield_rf_low
        pe_yield_rf_med
        pe_yield_rf_high
        pe_yield_ir_med
        pe_yield_ir_high
        pe_yield_eo_rf
        pe_yield_eo_ir
        pe_yield_eo_mixed
        
        fe_yield_unit = 'GJ ha-1 yr-1'
        
        pe_unit = 'MJ yr-1';
        pe_eo_rf
        pe_eo_ir
        pe_eo_mixed
        pe_eo_nc_rf
        pe_eo_nc_ir
        pe_eo_nc_mixed
        
        meg_unit = 'GJ mm-1 ha-1'
        meg_eo
        meg_eo_mixed
        
        fe_unit = 'MJ yr-1'
        fe_eo_rf_ethanol
        fe_eo_rf_ft
        fe_eo_ir_ethanol
        fe_eo_ir_ft
        fe_eo_mixed_ethanol
        
        c_unit = 'ton C yr-1';
        c_eo_ref_em
        c_eo_ref_cap
        c_eo_ref_f
        
        wd_unit = 'mm yr-1'
        wd_low
        wd_med
        wd_high
        
        %% Area and productive area
        land_tot_unit = 'Mha';
        land_tot
        land_eo_prod_rf_tot
        land_eo_prod_ir_tot
        land_eo_prod_mixed_tot
        land_nc_tot
        land_eo_nc_prod_rf_tot
        land_eo_nc_prod_ir_tot
        land_eo_nc_prod_mixed_tot
        
        %% Mean bioenergy yields
        pe_yield_eo_mean_unit = 'GJ ha-1 yr-1';
        pe_yield_eo_rf_mean
        pe_yield_eo_ir_mean
        pe_yield_eo_mixed_mean
        %On productive land only
        pe_yield_eo_prod_rf_mean
        pe_yield_eo_prod_ir_mean
        pe_yield_eo_prod_mixed_mean
        %Outside nature conservation areas
        pe_yield_eo_nc_rf_mean
        pe_yield_eo_nc_ir_mean
        pe_yield_eo_nc_mixed_mean
        pe_yield_eo_nc_prod_rf_mean
        pe_yield_eo_nc_prod_ir_mean
        pe_yield_eo_nc_prod_mixed_mean
        
        
        %% Totals
        pe_tot_unit = 'EJ yr-1';
        
        % Total all
        pe_eo_rf_tot
        pe_eo_ir_tot
        pe_eo_mixed_tot
        pe_eo_nc_rf_tot
        pe_eo_nc_ir_tot
        pe_eo_nc_mixed_tot
        
        %Mixed contribution IR/RF
        pe_eo_mixed_rf_contribution_tot
        pe_eo_mixed_ir_contribution_tot
        pe_eo_nc_mixed_rf_contribution_tot
        pe_eo_nc_mixed_ir_contribution_tot
        
    end
    
    methods
        
        function export2netcdf_mixedManagementScenario_basedOnYieldGaps(obj)
            
            filename = 'Output/Mixed_management_scenario_based_on_yield_gaps_5arcmin.nc';
            
            fprintf('Exporting at 5 arcmin to file: ')
            
            fprintf(filename)
            fprintf('\n');
            
            
            if exist(filename)
                delete(filename)
            end
            
            lat = obj.lat;
            lon = obj.lon;
            
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
            
            nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
            ncwriteatt(filename, 'description', 'standard_name', 'description');
            ncwriteatt(filename, 'description', 'long_name', 'description');
            
            nccreate(filename, 'year');
            ncwriteatt(filename, 'year', 'standard_name', 'year');
            ncwriteatt(filename, 'year', 'long_name', 'year');
            
            nccreate(filename, 'climate_scenario_ID');
            ncwriteatt(filename, 'climate_scenario_ID', 'standard_name', 'climate_scenario_ID');
            ncwriteatt(filename, 'climate_scenario_ID', 'long_name', 'climate_scenario_ID');
            
            nccreate(filename, 'management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'management_intensity', 'standard_name', 'Management_intensity');
            ncwriteatt(filename, 'management_intensity', 'long_name', 'Agricultural_management_intensity');
            ncwriteatt(filename, 'management_intensity', 'units', '');
            ncwriteatt(filename, 'management_intensity', 'missing_value', '-999');
            
            nccreate(filename, 'irrigation_share', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'irrigation_share', 'standard_name', 'Share_of_production_irrigated');
            ncwriteatt(filename, 'irrigation_share', 'long_name', 'Share_of_production_irrigated');
            ncwriteatt(filename, 'irrigation_share', 'units', '');
            ncwriteatt(filename, 'irrigation_share', 'missing_value', '-999');
            
            nccreate(filename, 'land_avail', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'land_avail', 'standard_name', 'Available land');
            ncwriteatt(filename, 'land_avail', 'long_name', 'Available land');
            ncwriteatt(filename, 'land_avail', 'units', 'Hectare');
            ncwriteatt(filename, 'land_avail', 'missing_value', '-999');
            
            nccreate(filename, 'land_nc_avail', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'land_nc_avail', 'standard_name', 'Available land with nature conservation measures');
            ncwriteatt(filename, 'land_nc_avail', 'long_name', 'Available land with nature conservation measures');
            ncwriteatt(filename, 'land_nc_avail', 'units', 'Hectare');
            ncwriteatt(filename, 'land_nc_avail', 'missing_value', '-999');
            
            nccreate(filename, 'eo_crop_allocation', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'eo_crop_allocation', 'standard_name', 'Energy_optimized_crop_allocation');
            ncwriteatt(filename, 'eo_crop_allocation', 'long_name', 'Energy_optimized_crop_allocation');
            ncwriteatt(filename, 'eo_crop_allocation', 'units', '');
            ncwriteatt(filename, 'eo_crop_allocation', 'missing_value', '-999');
            
            nccreate(filename, 'pe_yield_eo_mixed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'standard_name', 'Primary_energy_yield');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'long_name', 'Primary_energy_yield');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'units', 'GJ ha-1 yr-1');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'missing_value', '-999');
            
            nccreate(filename, 'pe_eo_mixed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_eo_mixed', 'standard_name', 'Primary_energy_potential');
            ncwriteatt(filename, 'pe_eo_mixed', 'long_name', 'Primary_energy_potential');
            ncwriteatt(filename, 'pe_eo_mixed', 'units', 'PJ yr-1');
            ncwriteatt(filename, 'pe_eo_mixed', 'missing_value', '-999');
            
            nccreate(filename, 'pe_eo_nc_mixed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_eo_nc_mixed', 'standard_name', 'Primary_energy_potential_with_nature_conservation_measures');
            ncwriteatt(filename, 'pe_eo_nc_mixed', 'long_name', 'Primary_energy_potential_with_nature_conservation_measures');
            ncwriteatt(filename, 'pe_eo_nc_mixed', 'units', 'PJ yr-1');
            ncwriteatt(filename, 'pe_eo_nc_mixed', 'missing_value', '-999');
            
            ncwrite(filename, 'lon', lon);
            ncwrite(filename, 'lat', lat);
            ncwrite(filename, 'year', obj.year);
            ncwrite(filename, 'climate_scenario_ID', obj.ClimateScenario.ID);
            ncwrite(filename, 'management_intensity', obj.management_intensity_grid);
            ncwrite(filename, 'irrigation_share', obj.irrigated_mixed_fraction_grid);
            ncwrite(filename, 'land_avail', obj.land_grid_hectare);
            ncwrite(filename, 'land_nc_avail', obj.land_nc_grid_hectare);
            ncwrite(filename, 'eo_crop_allocation', obj.eo_mixed_crop_allocation);
            ncwrite(filename, 'pe_yield_eo_mixed', obj.pe_yield_eo_mixed)
            ncwrite(filename, 'pe_eo_mixed', obj.pe_eo_mixed*10^-9);
            ncwrite(filename, 'pe_eo_nc_mixed', obj.pe_eo_nc_mixed*10^-9);
            
            %% Export source data extended data fig 1a
            filename = 'Output/source_data_extended_data_fig_1a.nc';
            
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
            
            nccreate(filename, 'management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'management_intensity', 'standard_name', 'Management_intensity');
            ncwriteatt(filename, 'management_intensity', 'long_name', 'Agricultural_management_intensity');
            ncwriteatt(filename, 'management_intensity', 'units', '');
            ncwriteatt(filename, 'management_intensity', 'missing_value', '-999');
            
            ncwrite(filename, 'lon', lon);
            ncwrite(filename, 'lat', lat);
            ncwrite(filename, 'management_intensity', obj.management_intensity_grid)
            
            %% Exporting 1 degree
            fprintf('Exporting at 1 degree to file: ')
            
            filename = 'Output/Mixed_management_scenario_based_on_yield_gaps_one_degree.nc';
            fprintf(filename)
            
            fprintf('\n')
            
            if exist(filename)
                delete(filename)
            end
            
            %Preallocation
            pe_yield_deg = zeros(360,180);
            
            %Upscale
            [land_deg, lat_one_deg, lon_one_deg, ~, ~]  = aggregateMatrix2givenDimensions( obj.land_grid_hectare,lon,lat, 360, 180 );
            [pe_mix_deg, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( obj.pe_eo_mixed,lon,lat, 360, 180 );
            [pe_rf_deg, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( obj.pe_eo_rf,lon,lat, 360, 180 );
            [pe_nc_deg, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( obj.pe_eo_nc_mixed,lon,lat, 360, 180 );
            [pe_rf_nc_deg, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( obj.pe_eo_nc_rf,lon,lat, 360, 180 );
            [land_nc_deg, ~, ~, ~, ~]  = aggregateMatrix2givenDimensions( obj.land_nc_grid_hectare,lon,lat, 360, 180 );
            
            pe_yield_deg = 10^-3*pe_mix_deg./land_deg; %MJ ha-1 yr-1 to GJ ha-1 yr-1
            pe_yield_deg(isnan(pe_yield_deg)) = -999;
            
            pe_yield_rf_deg = 10^-3*pe_rf_deg./land_deg; %MJ ha-1 yr-1 to GJ ha-1 yr-1
            pe_yield_rf_deg(isnan(pe_yield_rf_deg)) = -999;
            
            pe_mix_deg = pe_mix_deg*10^-9; %MJ to PJ
            pe_nc_deg = pe_nc_deg*10^-9;
            pe_rf_deg = pe_rf_deg*10^-9;
            pe_rf_nc_deg = pe_rf_nc_deg*10^-9;
            
            pe_mix_deg(pe_mix_deg == 0) = -999;
            pe_nc_deg(pe_nc_deg == 0) = -999;
            pe_rf_deg(pe_rf_deg == 0) = -999;
            pe_rf_nc_deg(pe_rf_nc_deg == 0) = -999;
            land_nc_deg(land_nc_deg == 0) = -999;
            land_deg(land_deg == 0) = -999;
            
            lat = lat_one_deg;
            lon = lon_one_deg;
            
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
            
            nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
            ncwriteatt(filename, 'description', 'standard_name', 'description');
            ncwriteatt(filename, 'description', 'long_name', 'description');
            
            nccreate(filename, 'year');
            ncwriteatt(filename, 'year', 'standard_name', 'year');
            ncwriteatt(filename, 'year', 'long_name', 'year');
            
            nccreate(filename, 'climate_scenario_ID');
            ncwriteatt(filename, 'climate_scenario_ID', 'standard_name', 'climate_scenario_ID');
            ncwriteatt(filename, 'climate_scenario_ID', 'long_name', 'climate_scenario_ID');
            
            nccreate(filename, 'land_avail', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'land_avail', 'standard_name', 'Available land');
            ncwriteatt(filename, 'land_avail', 'long_name', 'Available land');
            ncwriteatt(filename, 'land_avail', 'units', 'Hectare');
            ncwriteatt(filename, 'land_avail', 'missing_value', '-999');
            
            nccreate(filename, 'land_nc_avail', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'land_nc_avail', 'standard_name', 'Available land with nature conservation measures');
            ncwriteatt(filename, 'land_nc_avail', 'long_name', 'Available land with nature conservation measures');
            ncwriteatt(filename, 'land_nc_avail', 'units', 'Hectare');
            ncwriteatt(filename, 'land_nc_avail', 'missing_value', '-999');
            
            nccreate(filename, 'pe_yield_eo_mixed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'standard_name', 'Primary_energy_yield_mixed_water_supply');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'long_name', 'Primary_energy_yield_mixed_water_supply');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'units', 'GJ ha-1 yr-1');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'missing_value', '-999');
            
            nccreate(filename, 'pe_yield_eo_rf', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_yield_eo_rf', 'standard_name', 'Primary_energy_yield_rainfed');
            ncwriteatt(filename, 'pe_yield_eo_rf', 'long_name', 'Primary_energy_yield_rainfed');
            ncwriteatt(filename, 'pe_yield_eo_rf', 'units', 'GJ ha-1 yr-1');
            ncwriteatt(filename, 'pe_yield_eo_rf', 'missing_value', '-999');
            
            nccreate(filename, 'pe_eo_mixed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_eo_mixed', 'standard_name', 'Primary_energy_potential_mixed_water_supply');
            ncwriteatt(filename, 'pe_eo_mixed', 'long_name', 'Primary_energy_potential_mixed_water_supply');
            ncwriteatt(filename, 'pe_eo_mixed', 'units', 'PJ yr-1');
            ncwriteatt(filename, 'pe_eo_mixed', 'missing_value', '-999');
            
            nccreate(filename, 'pe_eo_nc_mixed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_eo_nc_mixed', 'standard_name', 'Primary_energy_potential_mixed_water_supply_with_nature_conservation_measures');
            ncwriteatt(filename, 'pe_eo_nc_mixed', 'long_name', 'Primary_energy_potential_mixed_water_supply_with_nature_conservation_measures');
            ncwriteatt(filename, 'pe_eo_nc_mixed', 'units', 'PJ yr-1');
            ncwriteatt(filename, 'pe_eo_nc_mixed', 'missing_value', '-999');
            
            nccreate(filename, 'pe_eo_rf', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_eo_rf', 'standard_name', 'Primary_energy_potential_rainfed');
            ncwriteatt(filename, 'pe_eo_rf', 'long_name', 'Primary_energy_potential_rainfed');
            ncwriteatt(filename, 'pe_eo_rf', 'units', 'PJ yr-1');
            ncwriteatt(filename, 'pe_eo_rf', 'missing_value', '-999');
            
            nccreate(filename, 'pe_eo_nc_rf', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_eo_nc_rf', 'standard_name', 'Primary_energy_potential_rainfed_with_nature_conservation_measures');
            ncwriteatt(filename, 'pe_eo_nc_rf', 'long_name', 'Primary_energy_potential_rainfed_with_nature_conservation_measures');
            ncwriteatt(filename, 'pe_eo_nc_rf', 'units', 'PJ yr-1');
            ncwriteatt(filename, 'pe_eo_nc_rf', 'missing_value', '-999');
            
            ncwrite(filename, 'lon', lon);
            ncwrite(filename, 'lat', lat);
            ncwrite(filename, 'year', obj.year);
            ncwrite(filename, 'climate_scenario_ID', obj.ClimateScenario.ID);
            
            ncwrite(filename, 'land_avail', land_deg);
            ncwrite(filename, 'land_nc_avail', land_nc_deg);
            ncwrite(filename, 'pe_yield_eo_mixed', pe_yield_deg)
            ncwrite(filename, 'pe_eo_mixed', pe_mix_deg);
            ncwrite(filename, 'pe_eo_nc_mixed', pe_nc_deg);
            ncwrite(filename, 'pe_yield_eo_rf', pe_yield_rf_deg)
            ncwrite(filename, 'pe_eo_rf', pe_rf_deg);
            ncwrite(filename, 'pe_eo_nc_rf', pe_rf_nc_deg);
            
            %% Export source data extended data figure 1
            
            filename = 'Output/source_data_extended_data_figure_1.nc';
            
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
            
            nccreate(filename, 'pe_yield_eo_rf', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_yield_eo_rf', 'standard_name', 'Primary_energy_yield_rainfed');
            ncwriteatt(filename, 'pe_yield_eo_rf', 'long_name', 'Primary_energy_yield_rainfed');
            ncwriteatt(filename, 'pe_yield_eo_rf', 'units', 'GJ ha-1 yr-1');
            ncwriteatt(filename, 'pe_yield_eo_rf', 'missing_value', '-999');
            
            nccreate(filename, 'pe_yield_eo_mixed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'standard_name', 'Primary_energy_yield_mixed_water_supply');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'long_name', 'Primary_energy_yield_mixed_water_supply');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'units', 'GJ ha-1 yr-1');
            ncwriteatt(filename, 'pe_yield_eo_mixed', 'missing_value', '-999');
            
            nccreate(filename, 'pe_eo_rf', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_eo_rf', 'standard_name', 'Primary_energy_potential_rainfed');
            ncwriteatt(filename, 'pe_eo_rf', 'long_name', 'Primary_energy_potential_rainfed');
            ncwriteatt(filename, 'pe_eo_rf', 'units', 'PJ yr-1');
            ncwriteatt(filename, 'pe_eo_rf', 'missing_value', '-999');
            
            nccreate(filename, 'pe_eo_mixed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
            ncwriteatt(filename, 'pe_eo_mixed', 'standard_name', 'Primary_energy_potential_mixed_water_supply');
            ncwriteatt(filename, 'pe_eo_mixed', 'long_name', 'Primary_energy_potential_mixed_water_supply');
            ncwriteatt(filename, 'pe_eo_mixed', 'units', 'PJ yr-1');
            ncwriteatt(filename, 'pe_eo_mixed', 'missing_value', '-999');
            
            ncwrite(filename, 'lon', lon);
            ncwrite(filename, 'lat', lat);
            ncwrite(filename, 'pe_yield_eo_mixed', pe_yield_deg);
            ncwrite(filename, 'pe_yield_eo_rf', pe_yield_rf_deg);
            ncwrite(filename, 'pe_eo_mixed', pe_mix_deg);
            ncwrite(filename, 'pe_eo_rf', pe_rf_deg);
            
        end
        

        function generate_yield_histogram_mixed_management_scenario(obj)
            for scens = 1:2
                if scens == 1
                    filename = 'Output/mixed_management_mixed_water_supply_energy_yield_histogram.pdf';
                    yields = obj.pe_yield_eo_mixed;
                    crop_allocation = obj.eo_mixed_crop_allocation;
                elseif scens == 2
                    filename = 'Output/mixed_management_rf_energy_yield_histogram.pdf';
                    yields = obj.pe_yield_eo_rf;
                    crop_allocation = obj.eo_rf_crop_allocation;
                    
                end
                
                bounds = zeros(2,8);
                bounds(1,2:end) = [0:100:600];
                bounds(2,2:end) = [100:100:700];
                bounds
                crop_IDs = [1 2 3];
                
                histogram_matrix = zeros(4,8);
                histogram_matrix_bh = zeros(4,8);
                
                land = obj.land_grid_hectare*10^-6;
                land_bh = obj.land_nc_grid_hectare*10^-6;
                
                
                %Get no potential
                histogram_matrix(end,1) = sum(sum(land(yields == 0)));
                histogram_matrix_bh(end,1) = sum(sum(land_bh(yields == 0)));
                
                for i = 1:length(crop_IDs)
                    for j = 2:8
                        histogram_matrix(i,j) = sum(sum(land(yields > bounds(1,j) & yields < bounds(2,j) & crop_allocation == crop_IDs(i))));
                        histogram_matrix_bh(i,j) = sum(sum(land_bh(yields > bounds(1,j) & yields < bounds(2,j) & crop_allocation == crop_IDs(i))));
                    end
                end
                
                sum(sum(histogram_matrix))
                
                timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
                
                cropTypeNames = {obj.CropType_array(1:3).name};
                
                %% Create x-axis labels
                c=2;
                labels{1} = '0';
                for i = 2:length(bounds)
                    labels{c} = [num2str(bounds(1,i)) '-' num2str(bounds(2,i))];
                    c=c+1;
                end
                
                %% PLOT
                figure1 = figure;
                labelSize = 7;
                
                set(gca,'FontSize',labelSize)
                set(gca, 'FontName', 'Arial')
                %Bar witdth
                w1 = 0.75; %Wide bar
                w2 = 0.5; %Thin bar
                
                
                % Transparancy
                alpha(1)
                
                %Plot stacked bar chart, all land
                bar_all = bar(histogram_matrix', w1,'stacked', 'FaceColor','flat');
                
                hold on
                %Plot on top, stacked bar chart, land located outside biodiversity hotspots
                bar_outside_bh = bar(histogram_matrix_bh', w2, 'stacked', 'LineStyle', '-', 'LineWidth', 0.5,'FaceColor','flat');
                %hold off
                %Set transparancy on wide bars
                alpha(bar_all,0.85)
                
                %Labeling
                xticklabels(labels);
                %xticklabels({' '});
                xtickangle(45);
                
                
                
                a = get(gca,'XTickLabel');
                set(gca,'XTickLabel',a,'fontsize',labelSize)
                
                ylabel('Mha','FontSize', labelSize);
                xlabel('GJ ha^{-1} yr^{-1}','FontSize', labelSize);
                %Axis min/max
                ylim([0 50]);
                yticks([0:10:50]);
                
                if length(crop_IDs) == 3
                    %     bar_all(1).FaceColor = [79/255 110/255 195/255];
                    %     bar_all(2).FaceColor = [241/255 206/255 118/255];
                    %     bar_all(3).FaceColor = [159/255 224/255 155/255];
                    %     bar_all(4).FaceColor = [1 1 0];
                    %
                    %     bar_bh(1).FaceColor = [79/255 110/255 195/255];
                    %     bar_bh(2).FaceColor = [241/255 206/255 118/255];
                    %     bar_bh(3).FaceColor = [159/255 224/255 155/255];
                    %     bar_bh(4).FaceColor = [1 1 0];
                    
                    bar_all(1).FaceColor = [0.9290 0.6940 0.1250];
                    bar_all(2).FaceColor = [0.4660 0.6740 0.1880];
                    bar_all(3).FaceColor = [0 0.4470 0.7410];
                    bar_all(4).FaceColor = [1 1 0];
                    
                    bar_outside_bh(1).FaceColor = [0.9290 0.6940 0.1250];
                    bar_outside_bh(2).FaceColor = [0.4660 0.6740 0.1880];
                    bar_outside_bh(3).FaceColor = [0 0.4470 0.7410];
                    bar_outside_bh(4).FaceColor = [1 1 0];
                end
                
                
                %% Create legend labels if set
                cropTypeNames
                addLegend_binary = 0;
                if exist('addLegend_binary', 'var')
                    if addLegend_binary == 1
                        for i = 1:length(cropTypeNames)
                            legendLabels{i} = [cropTypeNames{i}];
                        end
                        legendLabels{length(cropTypeNames)+1} = 'No potential';
                        legend(string(legendLabels), 'Location', 'northeast');
                    end
                end
                set(gca,'FontSize',labelSize)
                
                saveas(figure1,filename);
                
                filename(end-3:end) = '.pdf';
                print('-painters','-dpdf', '-r1000', filename)
                
                close all
                clear('figure1')
                
                fprintf(['Energy yield histogram figure saved to: ' filename '\n']);
                
                filename_src_data = filename(1:end-3);
                filename_src_data = [filename_src_data 'mat'];
                save(filename_src_data, 'histogram_matrix', 'histogram_matrix_bh');
                
            end
        end
    end
    
end

