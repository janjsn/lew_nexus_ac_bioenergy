function [ obj ] = mergeOptimizedScenarioResultsWithBHexcludedIntoMainArray( obj )
%% Merging Optimized Scenarios no biodiversity hotspots results into main Optimized Scenarios array
%Jan Sandstad Næss, 13.11.2019

fprintf('Merging the estimated optimal crop combination results excluding biodiversity hotspots areas into main array..');
fprintf('\n');

%Generate identification vectors
for n_optimal_noBH = 1:length(obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray)
       obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH) = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).generateIdentificationVector();
end
   
for n_optimal = 1:length(obj.OptimalPrimaryEnergyOutput_scenarioArray)
    obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal) = obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).generateIdentificationVector();
    %Get corresponding results from no biodiversity hotspots estimation
    for n_optimal_noBH = 1:length(obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray)
        if obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).identificationVector == obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).identificationVector
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_CropTypeArray = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).CropType_array;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimizationMatrix_cropID_vector = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimizationMatrix_cropID_vector;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimizationMatrix_tonPerYear_fromGaezOutput = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimizationMatrix_tonPerYear_fromGaezOutput;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimizationMatrix_cropIDs_lhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimizationMatrix_cropIDs_lhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimizationMatrix_cropIDs_hhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimizationMatrix_cropIDs_hhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimizationMatrix_waterDeficit_lhv_mm = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimizationMatrix_waterDeficit_lhv_mm;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimizationMatrix_waterDeficit_hhv_mm = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimizationMatrix_waterDeficit_hhv_mm;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimizationMatrix_MJ_perYear_lhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimizationMatrix_MJ_perYear_lhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimizationMatrix_MJ_perYear_hhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimizationMatrix_MJ_perYear_hhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimization_total_MJ_perYear_lhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_total_MJ_perYear_lhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimization_total_MJ_perYear_hhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_total_MJ_perYear_hhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimization_total_EJ_perYear_lhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_total_EJ_perYear_lhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimization_total_EJ_perYear_hhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_total_EJ_perYear_hhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimization_hectaresPerCrop = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_hectaresPerCrop;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_spatialOptimization_tonPerCrop_fromGaezOutput = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_tonPerCrop_fromGaezOutput;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_primaryEnergy_vector_MJ_perCropPerYear_lhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_primaryEnergy_vector_MJ_perCropPerYear_lhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_primaryEnergy_vector_MJ_perCropPerYear_hhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_primaryEnergy_vector_MJ_perCropPerYear_hhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_primaryEnergy_vector_EJ_perCropPerYear_lhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_lhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_primaryEnergy_vector_EJ_perCropPerYear_hhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_hhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_zeroPrimaryEnergyPotential_lhv_hectares = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_zeroPrimaryEnergyPotential_lhv_hectares;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_zeroPrimaryEnergyPotential_hhv_hectares = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_zeroPrimaryEnergyPotential_hhv_hectares;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_primEnergyPotentialHistogramMatrix_cropEnergy_lhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_prEnPotentialHistogramMatrix_cropEnergy_lhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_primEnergyPotentialHistogramMatrix_cropEnergy_hhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_prEnPotentialHistogramMatrix_cropEnergy_hhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_primEnergyPotentialHistogram_bandsLimits_lhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_primEnergyPotentialHistogram_bandsLimits_hhv = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).spatialOptimization_prEnergyPotentialHistogram_bandsLimits_hhv;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_landAllocatedToEachCropType_lhv_vector_hectare = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).landAllocatedToEachCropType_lhv_vector_hectare;
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).excluded_BH_landAllocatedToEachCropType_hhv_vector_hectare = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(n_optimal_noBH).landAllocatedToEachCropType_hhv_vector_hectare;
            
            %Aggregating results to one degree
            obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).AggregatedResults_oneDegree = obj.OptimalPrimaryEnergyOutput_scenarioArray(n_optimal).aggregate2oneDegree(obj.identifiedLand_longitudeVector_centered, obj.identifiedLand_latitudeVector_centered);
            break;
        end
        
        
    end
end
   
end

