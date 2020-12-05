function [ futureBaselineArray ] = getFutureBaselines_optimizedCropMix( obj )
%GETFUTUREBASELINES 

identificationVector_baseline = obj.Baselines.OptimizedCropMix_forPrimaryEnergy_variant.identificationVector;

%Counting number of instances to add
c=0;
for i = 1:length(obj.OptimalPrimaryEnergyOutput_scenarioArray)
    if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector(2) == identificationVector_baseline(2)
        if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector(3) == identificationVector_baseline(3)
            if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector(4) > identificationVector_baseline(4)
                c=c+1;
                
            end
        end
    end
end
%Creating array
if c > 0
    futureBaselineArray(1:c) = OptimizedScenarios_cropCombinations;
    
    c=1;
    for i = 1:length(obj.OptimalPrimaryEnergyOutput_scenarioArray)
        if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector(2) == identificationVector_baseline(2)
            if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector(3) == identificationVector_baseline(3)
                if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector(4) > identificationVector_baseline(4)
                    futureBaselineArray(c) = obj.OptimalPrimaryEnergyOutput_scenarioArray(i);
                    
                    c=c+1;
                    
                end
            end
        end
    end
end

end

