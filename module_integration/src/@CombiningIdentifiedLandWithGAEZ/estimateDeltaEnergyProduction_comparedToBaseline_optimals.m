function [ obj ] = estimateDeltaEnergyProduction_comparedToBaseline_optimals( obj )

for i = 1:length(obj.OptimalPrimaryEnergyOutput_scenarioArray)
    
    obj.OptimalPrimaryEnergyOutput_scenarioArray(i).delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv =  obj.OptimalPrimaryEnergyOutput_scenarioArray(i).spatialOptimizationMatrix_MJ_perYear_lhv-obj.Baselines.OptimizedCropMix_forPrimaryEnergy_variant.spatialOptimizationMatrix_MJ_perYear_lhv;
    obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv = obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.spatialOptimizationMatrix_MJ_perYear_lhv-obj.Baselines.OptimizedCropMix_forPrimaryEnergy_variant.AggregatedResults_oneDegree.spatialOptimizationMatrix_MJ_perYear_lhv;
    obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.delta_fromBaseline_spatialOptimizationMatrix_PJ_perYear_lhv = 10^-9*obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv;
    
    %preallocation, estimations of fractional changes compared to baseline
    mSize = size(obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.delta_fromBaseline_spatialOptimizationMatrix_MJ_perYear_lhv);
    fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv = zeros(mSize(1), mSize(2));
    
    %Estimating fractional and percentage change from baseline
    binaryMatrix_productionLargerThanZero = obj.Baselines.OptimizedCropMix_forPrimaryEnergy_variant.AggregatedResults_oneDegree.spatialOptimizationMatrix_MJ_perYear_lhv > 0;
    binaryMatrix_noProductionBefore_productionNow = obj.Baselines.OptimizedCropMix_forPrimaryEnergy_variant.AggregatedResults_oneDegree.spatialOptimizationMatrix_MJ_perYear_lhv == 0 & obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.spatialOptimizationMatrix_MJ_perYear_lhv > 0;
    

    
    for n_rows = 1:mSize(1)
        for n_cols = 1:mSize(2)
            if binaryMatrix_noProductionBefore_productionNow(n_rows,n_cols) == 1
                fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv(n_rows,n_cols) = -999;
                
            elseif binaryMatrix_productionLargerThanZero(n_rows,n_cols) == 1
                fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv(n_rows,n_cols) = -1+(obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.spatialOptimizationMatrix_MJ_perYear_lhv(n_rows,n_cols)/obj.Baselines.OptimizedCropMix_forPrimaryEnergy_variant.AggregatedResults_oneDegree.spatialOptimizationMatrix_MJ_perYear_lhv(n_rows,n_cols));
           
            else
                fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv(n_rows,n_cols) = 0;
            end
        end
    end
    
    %Saving to object
    obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv = fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv;
    %Estimating percentage change
    obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv = 100*obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv;
    obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv(obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv == -99900) = -999;
    %obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv(binaryMatrix_productionLargerThanZero) = -1+(obj.OptimalPrimaryEnergyOutput_scenarioArray(i).spatialOptimizationMatrix_MJ_perYear_lhv(binaryMatrix_productionLargerThanZero)/obj.Baselines.OptimizedCropMix_forPrimaryEnergy_variant.spatialOptimizationMatrix_MJ_perYear_lhv(binaryMatrix_productionLargerThanZero));
    %obj.OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.fractionalChangesMatrix_fromBaseline_primaryEnergy_lhv(binaryMatrix_noProductionBefore_productionNow) = -999;
  
end


end

