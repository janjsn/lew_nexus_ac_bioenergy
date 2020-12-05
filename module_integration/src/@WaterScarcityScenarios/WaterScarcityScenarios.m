classdef WaterScarcityScenarios
    %WATERSCARCITYSCENARIOS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        scenarioDescription_string
        ClimateScenario
        CropType_array
        fertilizerLevel
        year
        biodiversityHotspotsExcluded
        identificationVector
        waterDeficitIsConsidered = 0;
        areaPerLatitudeVector_hectare
        WaterScarcityLevel
        
        fractionsMatrix_spatialLocationIsBiodiversityHotspot
        primaryEnergyProductionMatrix_rainfed %NOTE MJ
        primaryEnergyProductionMatrix_irrigated %NOTE MJ
        
        irrigation_binaryMatrix
        waterDeficit_lhv_mm %for irrigated conditions
        waterDeficit_hhv_mm %for irrigated conditions
        waterUseToIrrigate_lhv_m3
        waterUseToIrrigate_lhv_total_m3
        waterUseToIrrigate_hhv_m3
        waterUseToIrrigate_hhv_total_m3
        deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear
        deltaPrimaryEnergy_hhv_ir_rf_MJ_perYear
        primaryEnergyGainPerIrrigation_lhv_MJ_per_mm 
        primaryEnergyGainPerIrrigation_hhv_MJ_per_mm
        primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare%MARGINAL ENERGY GAIN
        primaryEnergyGainPerIrrigation_hhv_MJ_per_mm_per_hectare%MARGINAL ENERGY GAIN
        marginalEnergyGain_histogram_after_GJ_per_mm_ha_inHectare
        marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds
        marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare
        marginalEnergyGain_mean_global_GJ_per_mm_ha
        marginalEnergyGain_mean_lowWaterScarcity_GJ_per_mm_ha
        marginalEnergyGain_mean_moderateWaterScarcity_GJ_per_mm_ha
        marginalEnergyGain_mean_highWaterScarcity_GJ_per_mm_ha
        marginalEnergyGain_mean_biodiversityHotspots_GJ_per_mm_ha
        
        waterUseToIrrigateMatrix_lowWaterScarcityAreas_lhv
        waterUseToIrrigateMatrix_lowWaterScarcityAreas_hhv
        waterUseToIrrigate_lhv_total_lowWaterScarcityAreas_m3
        waterUseToIrrigate_hhv_total_lowWaterScarcityAreas_m3
        
        waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ
        waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_hectare
        waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_ws_ha
        waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds
        
        waterUsePerEnergyGain_lhv_m3_perGJ
        waterUsePerEnergyGain_lhv_m3_perGJ_histogram_hectare
        waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha
        waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds
        
        
        waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_hectare
        waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha
        waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_bounds
        
        waterUse_lowWaterScarcity_total_m3
        waterUse_moderateWaterScarcity_total_m3
        waterUse_highWaterScarcity_total_m3
        
        waterUse_inBiodiversityHotspots_lowWaterScarcity_total_m3
        waterUse_inBiodiversityHotspots_moderateWaterScarcity_total_m3
        waterUse_inBiodiversityHotspots_highWaterScarcity_total_m3
        
        energyGain_total_EJ
        energyGain_lowWaterScarcity_total_EJ
        energyGain_moderateWaterScarcity_total_EJ
        energyGain_highWaterScarcity_total_EJ
        energyGain_inBiodiversityHotspots_tot_EJ
        energyGain_inBiodiversityHotspots_lowWaterScarcity_tot_EJ
        energyGain_inBiodiversityHotspots_moderateWaterScarcity_tot_EJ
        energyGain_inBiodiversityHotspots_highWaterScarcity_tot_EJ
        energyGain_noBiodiversityHotspots_tot_EJ
        energyGain_noBiodiversityHotspots_lowWaterScarcity_tot_EJ
        energyGain_noBiodiversityHotspots_moderateWaterScarcity_tot_EJ
        energyGain_noBiodiversityHotspots_highWaterScarcity_tot_EJ
        
        meanWaterFootprint_global_m3_perGJ
        meanWaterFootprint_lowWaterScarcity_m3_perGJ
        meanWaterFootprint_moderateWaterScarcity_m3_perGJ
        meanWaterFootprint_highWaterScarcity_m3_perGJ
        meanWaterFootprint_biodiversityHotspots
        
        meanWaterFootprint_noBiodiversityHotspots_m3_perGJ
        meanWaterFootprint_noBiodiversityHotspots_lowWS_m3_perGJ
        meanWaterFootprint_noBiodiversityHotspots_moderateWS_m3_perGJ
        meanWaterFootprint_noBiodiversityHotspots_highWS_m3_perGJ
        meanWaterFootprint_noBiodiversityHotspots_modAndhighWS_m3_perGJ
        
        primaryEnergyMatrix_MJ_perYear_lhv
        primaryEnergyMatrix_MJ_perYear_hhv
        primaryEnergyMatrix_cropIDs_lhv
        primaryEnergyMatrix_cropIDs_hhv
        
        primaryEnergy_perCrop_EJ
        
        primaryEnergy_total_MJ_perYear_lhv
        primaryEnergy_total_MJ_perYear_hhv
        primaryEnergy_total_EJ_perYear_lhv
        primaryEnergy_total_EJ_perYear_hhv
        
        primaryEnergyMatrix_irrigated_MJ_perYear_lhv
        primaryEnergyMatrix_rainfed_MJ_perYear_lhv
        primaryEnergyMatrix_irrigated_MJ_perYear_hhv
        primaryEnergyMatrix_rainfed_MJ_perYear_hhv
        
        primaryEnergy_total_MJ_perYear_rainfed_lhv
        primaryEnergy_total_MJ_perYear_irrigated_lhv
        primaryEnergy_total_MJ_perYear_rainfed_hhv
        primaryEnergy_total_MJ_perYear_irrigated_hhv
        
        primaryEnergy_total_EJ_perYear_rainfed_lhv
        primaryEnergy_total_EJ_perYear_irrigated_lhv
        primaryEnergy_total_EJ_perYear_rainfed_hhv
        primaryEnergy_total_EJ_perYear_irrigated_hhv
        
        zeroPrimaryEnergyPotential_lhv_hectares
        zeroPrimaryEnergyPotential_hhv_hectares
        cropID_vector
        
        primaryEnergyPotentialHistogram_bandsLimits_lhv
        primaryEnergyPotentialHistogram_bandsLimits_hhv
        primaryEnergyPotentialHistogramMatrix_cropEnergy_lhv
        primaryEnergyPotentialHistogramMatrix_cropEnergy_hhv
        
        primaryEnergyPotentialHistogramMatrix_rainfed_cropEnergy_lhv
        primaryEnergyPotentialHistogramMatrix_irrigated_cropEnergy_lhv
        primaryEnergyPotentialHistogramMatrix_rainfed_cropEnergy_hhv
        primaryEnergyPotentialHistogramMatrix_irrigated_cropEnergy_hhv
        
        exclBH_primaryEnergyMatrix_MJ_perYear
        exclBH_primaryEnergyMatrix_cropIDs_lhv
        exclBH_primaryEnergy_perCrop_EJ
        
        exclBH_zeroPrimaryEnergyPotential_lhv_hectares
        exclBH_zeroPrimaryEnergyPotential_hhv_hectares
        exclBH_cropID_vector
        
        exclBH_primEnPotentialHistogram_bandsLimits_lhv
        exclBH_primEnPotentialHistogram_bandsLimits_hhv
        exclBH_primEnPotentialHistogramMatrix_cropEnergy_lhv
        exclBH_primEnPotentialHistogramMatrix_cropEnergy_hhv
        
        exclBH_primEnPotentialHistogramMatrix_rainfed_cropEnergy_lhv
        exclBH_primEnPotentialHistogramMatrix_irrigated_cropEnergy_lhv
        exclBH_primEnPotentialHistogramMatrix_rainfed_cropEnergy_hhv
        exclBH_primEnPotentialHistogramMatrix_irrigated_cropEnergy_hhv
        
        exclBH_primaryEnergy_total_EJ_perYear_rainfed_lhv
        exclBH_primaryEnergy_total_EJ_perYear_irrigated_lhv
        
        EnergyYieldHistogramData_lhv
        EnergyProduction_histogramData
        AggregatedResults
    end
    
    methods
        obj = generateHistograms_categorizedAfterEnergyPotentialsAndCrops( obj, identifiedLandMatrix_hectares );
        obj = estimateWaterUsePerEnergyYieldGain( obj, identifiedLand_hectare, identifiedLand_outsideBiodiversityHotspots)
        plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_lhv( obj, outputFolder )
        plotHistogram_hectaresGroupedAfterWaterUsePerEnergyGain( obj, outputFolder )
        
        export2netcdf( obj, outputFolder, latitudeVector, longitudeVector, identifiedLand_fractions, identifiedLandMatrix_hectares  )
        
        obj = generateIdentificationVector(obj)
        
        plotStandardizedEnergyYieldHistogram( obj, outputFolder, addLegend_binary )
        plotHistogram_marginalEnergyGain( obj, outputFolder )
        plotHistogram_hectaresAfterWaterUsePerEnergyGain_m3_perGJ( obj, outputFolder )
        plotBarChart_waterUse( obj, outputFolder )
        
        [ AggregatedResults] = aggregate2oneDegree( obj,longitudeVector_centered,latitudeVector_centered, identifiedLandMatrix_hectares, identifiedLandMatrix_excludedBH_hectares )

        
        %% Estimate marginal water energy tradeoffs
        %main function:
        obj = estimateMarginalWaterEnergyTradeOffs( obj )
        %support function to reduce amount of lines, could not find a
        %logical name:
        [ global_accumulatedEnergyGainOfDeployment_GJ,global_accumulatedWaterUseOfDeployment_billion_m3,global_blueWaterFootprintOfDeployment_m3_perGJ ] = supportFunction_makeAccumulatedVectors_marginalTradeoffs(obj, global_energyGain_MJ,global_waterUse_m3 )
         
        %LAnd energy tradeoffs
        obj = estimateMarginalLandEnergyTradeoffs( obj, identifiedLandMatrix_hectare )
        [ accumulatedEnergyProduction_EJ, accumulatedLandUse_Mha ] = supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( obj, energyProductionVector_unsorted_EJ, landRequirementVector_unsorted_Mha )

    end
end



