function mixed_management_scenario = generate_mixed_management_scenario_from_yield_gaps( obj )
%GENERATE_MIXED_MANAGEMENT_SCENARIO_FROM_YIELD_GAPS Summary of this function goes here
%   Detailed explanation goes here

n_scen = 1;

mixed_management_scenario(1:n_scen) = IntegratedArray;


for scen = 1:n_scen

    mixed_management_scenario(scen).scenarioDescription_string = 'Scenario with mixed management based on current local yield gaps';

    
    mixed_management_scenario(scen).year = 2020;
    mixed_management_scenario(scen).lat = obj.identifiedLand_latitudeVector_centered;
    mixed_management_scenario(scen).lon = obj.identifiedLand_longitudeVector_centered;
    
    mixed_management_scenario(scen).ClimateScenario = obj.ClimateScenario_array(2);
    mixed_management_scenario(scen).identification_vector = [2 2020];
    mixed_management_scenario(scen).CropType_array = obj.Settings.CropTypeArray;
    mixed_management_scenario(scen).land_grid_hectare = obj.identifiedLandMatrix_hectares;
    mixed_management_scenario(scen).land_nc_grid_hectare = obj.identifiedLandMatrix_excludingBiodiversityHotspots_hectares;
    
    mixed_management_scenario(scen).irrigated_mixed_fraction_grid = obj.GAEZ_waterScarcityData.waterScarcityIsLowMatrix_binary;
    
    
    mSize = size(mixed_management_scenario(scen).irrigated_mixed_fraction_grid);
    
    yield_gap_cats = obj.Settings.yield_gap_categories;
    
    %% Preallocations
    mixed_management_scenario(scen).management_intensity_grid = zeros(mSize(1),mSize(2));
    %mixed_management_scenario.management_intensity_grid(:,:) = 2;
    
    mixed_management_scenario(scen).eo_rf_crop_allocation = zeros(mSize(1), mSize(2));
    mixed_management_scenario(scen).eo_mixed_crop_allocation = zeros(mSize(1), mSize(2));
    mixed_management_scenario(scen).eo_ir_crop_allocation = zeros(mSize(1), mSize(2));
    
    mixed_management_scenario(scen).pe_eo_mixed = zeros(mSize(1), mSize(2));
    mixed_management_scenario(scen).pe_eo_rf = zeros(mSize(1),mSize(2));
    mixed_management_scenario(scen).pe_eo_ir = zeros(mSize(1),mSize(2));
    
    mixed_management_scenario(scen).pe_eo_nc_mixed = zeros(mSize(1), mSize(2));
    mixed_management_scenario(scen).pe_eo_nc_rf = zeros(mSize(1),mSize(2));
    mixed_management_scenario(scen).pe_eo_nc_ir = zeros(mSize(1),mSize(2));
    
    %% Management distribution
    binary_low_management = (0 < yield_gap_cats) &  (yield_gap_cats < 3);
    binary_med_management = (2 < yield_gap_cats) & (yield_gap_cats < 5);
    binary_high_management = (yield_gap_cats > 4);
    
    
    mixed_management_scenario(scen).management_intensity_grid(binary_low_management) = 1;
    mixed_management_scenario(scen).management_intensity_grid(binary_med_management) = 2;
    mixed_management_scenario(scen).management_intensity_grid(binary_high_management) = 3;
    
    management_country_level = zeros(mSize(1),mSize(2));
    
    nitrogen_use = [obj.Country_array.FAO_cropland_nitrogen_use_2018_kg_per_ha];
    sorted_nitrogen_use = sort(nitrogen_use(nitrogen_use >-999));
    median_nitrogen_use = median(sorted_nitrogen_use);
    high_end_lowest_quartile = sorted_nitrogen_use(round(length(sorted_nitrogen_use)/4));
    low_end_highest_quartile = sorted_nitrogen_use(round(length(sorted_nitrogen_use)-length(sorted_nitrogen_use)/4));
    low_end_highest_third = sorted_nitrogen_use(round(length(sorted_nitrogen_use)-length(sorted_nitrogen_use)/3));
    high_end_lowest_third = sorted_nitrogen_use(round(length(sorted_nitrogen_use)/3));
    
    for i = 1:length(obj.Country_array)
        country_mask = obj.country_mask_gpw == obj.Country_array(i).GPW_country_ISO_numeric;
        
        hectares_at_given_management_intensity = zeros(1,3);
        hectares_at_given_management_intensity(1) = sum(sum(mixed_management_scenario(scen).land_grid_hectare.*binary_low_management.*country_mask));
        hectares_at_given_management_intensity(2) = sum(sum(mixed_management_scenario(scen).land_grid_hectare.*binary_med_management.*country_mask));
        hectares_at_given_management_intensity(3) = sum(sum(mixed_management_scenario(scen).land_grid_hectare.*binary_high_management.*country_mask));
        
        obj.Country_array(i).country_name;
        obj.Country_array(i).mean_management_intensity = (hectares_at_given_management_intensity(1)+2*hectares_at_given_management_intensity(2)+3*hectares_at_given_management_intensity(3))/sum(sum(mixed_management_scenario(scen).land_grid_hectare.*country_mask.*(mixed_management_scenario(scen).management_intensity_grid > 0)));
        
        %% If nitrogen should be accounted for, make changes here
        if obj.Country_array(i).FAO_cropland_nitrogen_use_2018_kg_per_ha > low_end_highest_third
            management_country_level(country_mask) = round(obj.Country_array(i).mean_management_intensity );
            %mixed_management_scenario.management_intensity_grid(country_mask & yield_gap_cats > 4) = 3;
        elseif obj.Country_array(i).FAO_cropland_nitrogen_use_2018_kg_per_ha > high_end_lowest_third
            management_country_level(country_mask) = round(obj.Country_array(i).mean_management_intensity );
            %mixed_management_scenario.management_intensity_grid(country_mask & yield_gap_cats < 5) = 2;
        else
            management_country_level(country_mask) = round(obj.Country_array(i).mean_management_intensity );
        end
        
    end
    
    %[obj.Country_array.mean_management_intensity]
    
    
    %% Get data
    mixed_management_scenario(scen).management_intensity_grid(mixed_management_scenario(scen).management_intensity_grid == 0) = management_country_level(mixed_management_scenario(scen).management_intensity_grid == 0);
    mixed_management_scenario(scen).management_intensity_grid(isnan(mixed_management_scenario(scen).management_intensity_grid)) = -999;
   mixed_management_scenario(scen).management_intensity_grid(mixed_management_scenario(scen).management_intensity_grid == -999 & mixed_management_scenario(scen).land_grid_hectare > 0) = 2;
   mixed_management_scenario(scen).management_intensity_grid(mixed_management_scenario(scen).management_intensity_grid == 0) = 2;
   
    
    eo_scenarios_2020 = obj.OptimalPrimaryEnergyOutput_scenarioArray([obj.OptimalPrimaryEnergyOutput_scenarioArray.year] == 2020);
    
    %{eo_scenarios_2020.scenarioDescription_string}
    
    %% Update binary management matrixes
    binary_low_management = mixed_management_scenario(scen).management_intensity_grid == 1;
    binary_med_management = mixed_management_scenario(scen).management_intensity_grid == 2;
    binary_high_management = mixed_management_scenario(scen).management_intensity_grid == 3;
    
    %% Do calculations to quantify bioenergy potentials
    for i = 1:length(eo_scenarios_2020)
        if eo_scenarios_2020(i).identificationVector(1) == mixed_management_scenario(scen).ClimateScenario.ID
            if eo_scenarios_2020(i).identificationVector(3) == 1
                eo_scenarios_2020(i)
                mixed_management_scenario(scen).pe_eo_mixed(binary_low_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_low_management);
                mixed_management_scenario(scen).pe_eo_rf(binary_low_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_low_management);
                
                mixed_management_scenario(scen).eo_mixed_crop_allocation(binary_low_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_low_management);
                mixed_management_scenario(scen).eo_rf_crop_allocation(binary_low_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_low_management);
                
                sum(sum(mixed_management_scenario(scen).land_grid_hectare(mixed_management_scenario(scen).pe_eo_rf == 0 & binary_low_management)))
     
            elseif eo_scenarios_2020(i).identificationVector(3) == 2 % medium management intensity
                if eo_scenarios_2020(i).identificationVector(2) == 0 % rain-fed water supply
                    %eo_scenarios_2020(i)
                    mixed_management_scenario(scen).pe_eo_mixed(binary_med_management) = mixed_management_scenario(scen).pe_eo_mixed(binary_med_management) + eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_med_management).*(1-mixed_management_scenario(scen).irrigated_mixed_fraction_grid(binary_med_management));
                    mixed_management_scenario(scen).eo_mixed_crop_allocation(binary_med_management & mixed_management_scenario(scen).irrigated_mixed_fraction_grid < 0.5) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_med_management & mixed_management_scenario(scen).irrigated_mixed_fraction_grid < 0.5);
                    
                    mixed_management_scenario(scen).pe_eo_rf(binary_med_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_med_management);
                    mixed_management_scenario(scen).eo_rf_crop_allocation(binary_med_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_med_management);
                    
                    sum(sum(mixed_management_scenario(scen).land_grid_hectare(mixed_management_scenario(scen).pe_eo_rf == 0 & binary_med_management)))
                    
                elseif eo_scenarios_2020(i).identificationVector(2) == 1 %irrigated water supply
                    mixed_management_scenario(scen).pe_eo_mixed(binary_med_management) = mixed_management_scenario(scen).pe_eo_mixed(binary_med_management) + eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_med_management).*(mixed_management_scenario(scen).irrigated_mixed_fraction_grid(binary_med_management));
                    mixed_management_scenario(scen).eo_mixed_crop_allocation(binary_med_management & mixed_management_scenario(scen).irrigated_mixed_fraction_grid > 0.5) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_med_management & mixed_management_scenario(scen).irrigated_mixed_fraction_grid > 0.5);
                    
                    mixed_management_scenario(scen).pe_eo_ir(binary_med_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_med_management);
                    mixed_management_scenario(scen).eo_ir_crop_allocation(binary_med_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_med_management);
                end
            elseif eo_scenarios_2020(i).identificationVector(3) == 3 %h high management intenstiy
                if eo_scenarios_2020(i).identificationVector(2) == 0 % rain-fed water supply
                    %eo_scenarios_2020(i)
                    mixed_management_scenario(scen).pe_eo_mixed(binary_high_management) = mixed_management_scenario(scen).pe_eo_mixed(binary_high_management) + eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_high_management).*(1-mixed_management_scenario(scen).irrigated_mixed_fraction_grid(binary_high_management));
                    mixed_management_scenario(scen).eo_mixed_crop_allocation(binary_high_management & mixed_management_scenario(scen).irrigated_mixed_fraction_grid < 0.5) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_high_management & mixed_management_scenario(scen).irrigated_mixed_fraction_grid < 0.5);
                    
                    mixed_management_scenario(scen).pe_eo_rf(binary_high_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_high_management);
                    mixed_management_scenario(scen).eo_rf_crop_allocation(binary_high_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_high_management);
                    
                    sum(sum(mixed_management_scenario(scen).land_grid_hectare(mixed_management_scenario(scen).pe_eo_rf == 0 & binary_high_management)))
                    
                elseif eo_scenarios_2020(i).identificationVector(2) == 1 % irrigated water supply
                    mixed_management_scenario(scen).pe_eo_mixed(binary_high_management) = mixed_management_scenario(scen).pe_eo_mixed(binary_high_management) + eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_high_management).*(mixed_management_scenario(scen).irrigated_mixed_fraction_grid(binary_high_management));
                    mixed_management_scenario(scen).eo_mixed_crop_allocation(binary_high_management & mixed_management_scenario(scen).irrigated_mixed_fraction_grid > 0.5) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_high_management & mixed_management_scenario(scen).irrigated_mixed_fraction_grid > 0.5);
                    
                    mixed_management_scenario(scen).pe_eo_ir(binary_high_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_MJ_perYear_lhv(binary_high_management);
                    mixed_management_scenario(scen).eo_ir_crop_allocation(binary_high_management) = eo_scenarios_2020(i).spatialOptimizationMatrix_cropIDs_lhv(binary_high_management);
                end
            end
            
            
        end
    end
    
    sum(sum(mixed_management_scenario(scen).land_grid_hectare(mixed_management_scenario(scen).pe_eo_rf == 0 )))
    
    sum(sum(mixed_management_scenario(scen).land_grid_hectare(binary_low_management)))
    sum(sum(mixed_management_scenario(scen).land_grid_hectare(binary_med_management)))
    sum(sum(mixed_management_scenario(scen).land_grid_hectare(binary_high_management)))
    
    mixed_management_scenario.management_intensity_grid(mixed_management_scenario(scen).land_grid_hectare <= 0) = -999;
    
    %% Mixed
    mixed_management_scenario(scen).pe_eo_nc_mixed = (mixed_management_scenario(scen).pe_eo_mixed./mixed_management_scenario(scen).land_grid_hectare).*mixed_management_scenario(scen).land_nc_grid_hectare;
    mixed_management_scenario(scen).pe_eo_nc_mixed(isnan(mixed_management_scenario(scen).pe_eo_nc_mixed)) = 0;
    
    mixed_management_scenario(scen).pe_yield_eo_mixed = 10^-3*mixed_management_scenario(scen).pe_eo_mixed./mixed_management_scenario(scen).land_grid_hectare;
    mixed_management_scenario(scen).pe_yield_eo_mixed(isnan(mixed_management_scenario(scen).pe_yield_eo_mixed)) = 0;
    
    %% Rain-fed
    mixed_management_scenario(scen).pe_eo_nc_rf = (mixed_management_scenario(scen).pe_eo_rf./mixed_management_scenario(scen).land_grid_hectare).*mixed_management_scenario(scen).land_nc_grid_hectare;
    mixed_management_scenario(scen).pe_eo_nc_rf(isnan(mixed_management_scenario(scen).pe_eo_nc_rf)) = 0;
    
    mixed_management_scenario(scen).pe_yield_eo_rf = 10^-3*mixed_management_scenario(scen).pe_eo_rf./mixed_management_scenario(scen).land_grid_hectare;
    mixed_management_scenario(scen).pe_yield_eo_rf(isnan(mixed_management_scenario(scen).pe_yield_eo_rf)) = 0;
    
    %% Irrigated
    mixed_management_scenario(scen).pe_eo_nc_ir = (mixed_management_scenario(scen).pe_eo_ir./mixed_management_scenario(scen).land_grid_hectare).*mixed_management_scenario(scen).land_nc_grid_hectare;
    mixed_management_scenario(scen).pe_eo_nc_ir(isnan(mixed_management_scenario(scen).pe_eo_nc_ir)) = 0;
    
    mixed_management_scenario(scen).pe_yield_eo_ir = 10^-3*mixed_management_scenario(scen).pe_eo_ir./mixed_management_scenario(scen).land_grid_hectare;
    mixed_management_scenario(scen).pe_yield_eo_ir(isnan(mixed_management_scenario(scen).pe_yield_eo_ir)) = 0;
    
    %% Totals
    mixed_management_scenario(scen).pe_eo_rf_tot = 10^-12*sum(sum(mixed_management_scenario(scen).pe_eo_rf));
    mixed_management_scenario(scen).pe_eo_ir_tot = 10^-12*sum(sum(mixed_management_scenario(scen).pe_eo_ir));
    mixed_management_scenario(scen).pe_eo_mixed_tot = 10^-12*sum(sum(mixed_management_scenario(scen).pe_eo_mixed));
    
    mixed_management_scenario(scen).pe_eo_nc_rf_tot = 10^-12*sum(sum(mixed_management_scenario(scen).pe_eo_nc_rf));
    mixed_management_scenario(scen).pe_eo_nc_ir_tot = 10^-12*sum(sum(mixed_management_scenario(scen).pe_eo_nc_ir));
    mixed_management_scenario(scen).pe_eo_nc_mixed_tot = 10^-12*sum(sum(mixed_management_scenario(scen).pe_eo_nc_mixed));
    
    mixed_management_scenario(scen).pe_eo_mixed_ir_contribution_tot = 10^-12*sum(sum(mixed_management_scenario(scen).pe_eo_mixed.*mixed_management_scenario(scen).irrigated_mixed_fraction_grid));
    mixed_management_scenario(scen).pe_eo_mixed_rf_contribution_tot = mixed_management_scenario(scen).pe_eo_mixed_tot - mixed_management_scenario(scen).pe_eo_mixed_ir_contribution_tot;
    
    mixed_management_scenario(scen).pe_eo_nc_mixed_ir_contribution_tot = 10^-12*sum(sum(mixed_management_scenario(scen).pe_eo_nc_mixed.*mixed_management_scenario(scen).irrigated_mixed_fraction_grid));
    mixed_management_scenario(scen).pe_eo_nc_mixed_rf_contribution_tot = mixed_management_scenario(scen).pe_eo_nc_mixed_tot - mixed_management_scenario(scen).pe_eo_nc_mixed_ir_contribution_tot;
    
    mixed_management_scenario(scen).land_tot = 10^-6*sum(sum(mixed_management_scenario(scen).land_grid_hectare));
    mixed_management_scenario(scen).land_nc_tot = 10^-6*sum(sum(mixed_management_scenario(scen).land_nc_grid_hectare));
    
    mixed_management_scenario(scen).land_eo_prod_rf_tot = 10^-6*sum(sum(mixed_management_scenario(scen).land_grid_hectare.*(mixed_management_scenario(scen).pe_eo_rf > 0)));
    mixed_management_scenario(scen).land_eo_prod_ir_tot = 10^-6*sum(sum(mixed_management_scenario(scen).land_grid_hectare.*(mixed_management_scenario(scen).pe_eo_ir > 0)));
    mixed_management_scenario(scen).land_eo_prod_mixed_tot = 10^-6*sum(sum(mixed_management_scenario(scen).land_grid_hectare.*(mixed_management_scenario(scen).pe_eo_mixed > 0)));
    
    mixed_management_scenario(scen).land_eo_nc_prod_rf_tot = 10^-6*sum(sum(mixed_management_scenario(scen).land_nc_grid_hectare.*(mixed_management_scenario(scen).pe_eo_nc_rf > 0)));
    mixed_management_scenario(scen).land_eo_nc_prod_ir_tot = 10^-6*sum(sum(mixed_management_scenario(scen).land_nc_grid_hectare.*(mixed_management_scenario(scen).pe_eo_nc_ir > 0)));
    mixed_management_scenario(scen).land_eo_nc_prod_mixed_tot = 10^-6*sum(sum(mixed_management_scenario(scen).land_nc_grid_hectare.*(mixed_management_scenario(scen).pe_eo_nc_mixed > 0)));
    
    %% Means
    mixed_management_scenario(scen).pe_yield_eo_rf_mean = 10^3*mixed_management_scenario(scen).pe_eo_rf_tot/mixed_management_scenario(scen).land_tot;
    mixed_management_scenario(scen).pe_yield_eo_ir_mean = 10^3*mixed_management_scenario(scen).pe_eo_ir_tot/mixed_management_scenario(scen).land_tot;
    mixed_management_scenario(scen).pe_yield_eo_mixed_mean = 10^3*mixed_management_scenario(scen).pe_eo_mixed_tot/mixed_management_scenario(scen).land_tot;
    mixed_management_scenario(scen).pe_yield_eo_prod_rf_mean = 10^3*mixed_management_scenario(scen).pe_eo_rf_tot/mixed_management_scenario(scen).land_eo_prod_rf_tot;
    mixed_management_scenario(scen).pe_yield_eo_prod_ir_mean = 10^3*mixed_management_scenario(scen).pe_eo_ir_tot/mixed_management_scenario(scen).land_eo_prod_ir_tot;
    mixed_management_scenario(scen).pe_yield_eo_prod_mixed_mean = 10^3*mixed_management_scenario(scen).pe_eo_mixed_tot/mixed_management_scenario(scen).land_eo_prod_mixed_tot;
    
    mixed_management_scenario(scen).pe_yield_eo_nc_rf_mean = 10^3*mixed_management_scenario(scen).pe_eo_nc_rf_tot/mixed_management_scenario(scen).land_nc_tot;
    mixed_management_scenario(scen).pe_yield_eo_nc_ir_mean = 10^3*mixed_management_scenario(scen).pe_eo_nc_ir_tot/mixed_management_scenario(scen).land_nc_tot;
    mixed_management_scenario(scen).pe_yield_eo_nc_mixed_mean = 10^3*mixed_management_scenario(scen).pe_eo_nc_mixed_tot/mixed_management_scenario(scen).land_nc_tot;
    mixed_management_scenario(scen).pe_yield_eo_nc_prod_rf_mean = 10^3*mixed_management_scenario(scen).pe_eo_nc_rf_tot/mixed_management_scenario(scen).land_eo_nc_prod_rf_tot;
    mixed_management_scenario(scen).pe_yield_eo_nc_prod_ir_mean = 10^3*mixed_management_scenario(scen).pe_eo_nc_ir_tot/mixed_management_scenario(scen).land_eo_nc_prod_ir_tot;
    mixed_management_scenario(scen).pe_yield_eo_nc_prod_mixed_mean = 10^3*mixed_management_scenario(scen).pe_eo_nc_mixed_tot/mixed_management_scenario(scen).land_eo_nc_prod_mixed_tot;
    

    
end
end

