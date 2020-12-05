classdef AggregatedResults_optimizedScenarios
    %AGGREGATEDRESULTS_OPTIMIZEDSCENARIOS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        description
        latitudeVector_centered
        longitudeVector_centered
        latitudeBounds
        longitudeBounds
        spatialOptimizationMatrix_MJ_perYear_lhv
        spatialOptimizationMatrix_PJ_perYear_lhv
        excluded_BH_spatialOptimizationMatrix_MJ_perYear_lhv
        excluded_BH_spatialOptimizationMatrix_PJ_perYear_lhv
        
        identifiedLandMatrix_hectare
        identifiedLandMatrix_fractions
        spatialOptimizationMatrix_bioenergyYields_GJ_perHaYear_lhv
        
        delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv
        delta_fromBaseline_spatialOptimizationMatrix_PJ_perYear_lhv
        fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv
        percentageChangesMatrix_fromBaseline_primaryEnergy_lhv
        
    end
    
    methods
        export2netcdf_aggregatedResults( obj, filename, outputFolder, identificationVector)
    end
    
end

