classdef AggregatedResults_waterScarcityScenarios
    %AGGREGATEDRESULTS_WATERSCARCITYSCENARIOS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        description
        latitudeVector_centered
        longitudeVector_centered
        latitudeBounds
        longitudeBounds
        primaryEnergy_MJ_perYear_lhv
        primaryEnergy_PJ_perYear_lhv
        excluded_BH_primaryEnergy_MJ_perYear_lhv
        excluded_BH_primaryEnergy_PJ_perYear_lhv
        primaryEnergy_AllRainfed
        primaryEnergy_AllIrrigated
        percentageEnergyGainOfIrrigation

        identifiedLandMatrix_hectare
        identifiedLandMatrix_fractions
        excluded_BH_identifiedLandMatrix_hectare
        excluded_BH_identifiedLandMatrix_fractions
        waterUseToIrrigate_lhv_m3
        waterUse_cellAverage_mm
        deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear
        energyYieldGain_lhv_ir_rf_GJ_perYearHa
        energyYieldGainPerIrrigation_GJ_perHaMm
        
        
        waterUseToIrrigate_lowWaterScarceAreas
        
        delta_fromBaseline_primaryEnergy_MJ_perYear_lhv
        delta_fromBaseline_primaryEnergy_PJ_perYear_lhv
        fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv
        percentageChangesMatrix_fromBaseline_primaryEnergy_lhv
    end
    
    methods
        export2netcdf_aggregatedResults( obj, filename, outputFolder)
        
     
    end
    
end

