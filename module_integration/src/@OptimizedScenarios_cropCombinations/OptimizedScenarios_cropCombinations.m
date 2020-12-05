classdef OptimizedScenarios_cropCombinations
    %OPTIMIZEDSCENARIOS_CROPCOMBINATIONS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        scenarioDescription_string
        ClimateScenario
        CropType_array
        irrigationLevel
        fertilizerLevel
        year
        identificationVector
        isBaseline_forComparison
        biodiversityHotspotsExcluded = 0;
        waterDeficitIsConsidered = 0;
        areaPerLatitudeVector_hectare
        identifiedLandMatrix_hectare
        
        matrix_spatialLocationIsBiodiversityHotspot_fractions
        binaryMatrix_spatialLocationHasLowWaterScarcity
        
        globalGrid_allLand_lhv_optimalCropID
        globalGrid_allLand_lhv_bioenergyYields_GJ_perHaYear
        globalGrid_allLand_lhv_waterDeficit_mm_perYear
        
        spatialOptimizationMatrix_cropID_vector
        spatialOptimizationMatrix_tonPerYear_fromGaezOutput
        spatialOptimizationMatrix_cropIDs_lhv
        spatialOptimizationMatrix_cropIDs_hhv
        spatialOptimizationMatrix_waterDeficit_lhv_mm=0;
        spatialOptimizationMatrix_waterDeficit_hhv_mm=0;
        spatialOptimizationMatrix_MJ_perYear_lhv
        spatialOptimizationMatrix_MJ_perYear_hhv
        spatialOptimization_total_MJ_perYear_lhv
        spatialOptimization_total_MJ_perYear_hhv
        spatialOptimization_total_EJ_perYear_lhv
        spatialOptimization_total_EJ_perYear_hhv
        
        spatialOptimization_hectaresPerCrop
        spatialOptimization_tonPerCrop_fromGaezOutput
        spatialOptimization_primaryEnergy_vector_MJ_perCropPerYear_lhv
        spatialOptimization_primaryEnergy_vector_MJ_perCropPerYear_hhv
        spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_lhv
        spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_hhv
        
        spatialOptimization_zeroPrimaryEnergyPotential_lhv_hectares
        spatialOptimization_zeroPrimaryEnergyPotential_hhv_hectares
        spatialOptimization_prEnPotentialHistogramMatrix_cropEnergy_lhv %GJ/ha
        spatialOptimization_prEnPotentialHistogramMatrix_cropEnergy_hhv %GJ/ha
        prEnPotentialHistogramMatrix_description = 'distributed in groups after GJ/hectare';
        spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv
        spatialOptimization_prEnergyPotentialHistogram_bandsLimits_hhv
        
        landAllocatedToEachCropType_lhv_vector_hectare
        landAllocatedToEachCropType_hhv_vector_hectare
        
        dataBelongingToScenarioHasBeenIdentified = 0;
        
        excluded_BH_CropTypeArray
        excluded_BH_spatialOptimizationMatrix_cropID_vector
        excluded_BH_spatialOptimizationMatrix_tonPerYear_fromGaezOutput
        excluded_BH_spatialOptimizationMatrix_cropIDs_lhv
        excluded_BH_spatialOptimizationMatrix_cropIDs_hhv
        excluded_BH_spatialOptimizationMatrix_waterDeficit_lhv_mm=0;
        excluded_BH_spatialOptimizationMatrix_waterDeficit_hhv_mm=0;
        excluded_BH_spatialOptimizationMatrix_MJ_perYear_lhv
        excluded_BH_spatialOptimizationMatrix_MJ_perYear_hhv
        excluded_BH_spatialOptimization_total_MJ_perYear_lhv
        excluded_BH_spatialOptimization_total_MJ_perYear_hhv
        excluded_BH_spatialOptimization_total_EJ_perYear_lhv
        excluded_BH_spatialOptimization_total_EJ_perYear_hhv
        excluded_BH_spatialOptimization_hectaresPerCrop
        excluded_BH_spatialOptimization_tonPerCrop_fromGaezOutput
        excluded_BH_primaryEnergy_vector_MJ_perCropPerYear_lhv
        excluded_BH_primaryEnergy_vector_MJ_perCropPerYear_hhv
        excluded_BH_primaryEnergy_vector_EJ_perCropPerYear_lhv
        excluded_BH_primaryEnergy_vector_EJ_perCropPerYear_hhv
        excluded_BH_zeroPrimaryEnergyPotential_lhv_hectares
        excluded_BH_zeroPrimaryEnergyPotential_hhv_hectares
        excluded_BH_primEnergyPotentialHistogramMatrix_cropEnergy_lhv
        excluded_BH_primEnergyPotentialHistogramMatrix_cropEnergy_hhv
        excluded_BH_primEnergyPotentialHistogram_bandsLimits_lhv
        excluded_BH_primEnergyPotentialHistogram_bandsLimits_hhv
        excluded_BH_landAllocatedToEachCropType_lhv_vector_hectare
        excluded_BH_landAllocatedToEachCropType_hhv_vector_hectare
        
        delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv
        EnergyYieldHistogramData_lhv
        AggregatedResults_oneDegree
        
    end
    
    methods
        obj = estimateHectaresPerCrop(obj,identifiedLandMatrix_hectares)
        
        obj = estimatePrimaryEnergyPerCrop(obj);
        
        obj = generateHistograms_categorizedAfterEnergyPotentialsAndCrops(obj, identifiedLandMatrix_hectares);
        plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_lhv(obj,outputFolder)
        plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_hhv( obj, outputFolder )
        exportToNetCDF( obj, outputFolder, latitudeVector, longitudeVector, identifiedLand_fractions )
        plotGriddedDataMap_IDs_lhv(obj, latVector, lonVector, CropType_array, outputFolder)
        [ AggregatedResults] = aggregate2oneDegree( obj,longitudeVector_centered,latitudeVector_centered )
        
        obj = generateIdentificationVector(obj)
        
        obj = createStandardizedEnergyYieldHistogramData( obj, energyYieldHistograms_standardBounds_GJperHa)
        
        plotStandardizedEnergyYieldHistogram( obj, outputFolder, addLegend_binary )
        
        getLatLonBox(obj, regionName, outputFolder,lat_bounds, lon_bounds, latitudeVector_centered, longitudeVector_centered  )
        
        exportGlobalGrid_cropIDsAndEnergyYield( obj, latitudeVector, longitudeVector )
        
        [ productive_area_hectare, mean_productive_bioenergy_yield, mean_bioenergy_yield] = calculateProductiveAreaAndMeanProductiveEnergyYield( obj )
        
    end
    
end

