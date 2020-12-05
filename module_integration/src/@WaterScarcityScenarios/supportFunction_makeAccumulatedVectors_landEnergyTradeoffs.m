function [ accumulatedEnergyProduction_EJ, accumulatedLandUse_Mha ] = supportFunction_makeAccumulatedVectors_landEnergyTradeoffs(obj, energyProductionVector_unsorted_EJ, landRequirementVector_unsorted_Mha )
%Called by obj = estimateMarginalLandEnergyTradeoffs( obj, identifiedLandMatrix_hectare )
%JSN 26.04.20


if length(energyProductionVector_unsorted_EJ) ~= length(landRequirementVector_unsorted_Mha)
   error('Vectors not of same length'); 
end

energyYields_unsorted = energyProductionVector_unsorted_EJ./landRequirementVector_unsorted_Mha;

tempEnergyProductionVector_unsorted_EJ = energyProductionVector_unsorted_EJ;

accumulatedEnergyProduction_EJ = zeros(1,length(energyProductionVector_unsorted_EJ));
accumulatedLandUse_Mha = zeros(1,length(energyProductionVector_unsorted_EJ));

for i = 1:length(energyYields_unsorted )
    [value,idx] = max(energyYields_unsorted(:));
    
    if i == 1
       accumulatedEnergyProduction_EJ(i) = energyProductionVector_unsorted_EJ(idx);
       accumulatedLandUse_Mha(i) = landRequirementVector_unsorted_Mha(idx);
    else
        accumulatedEnergyProduction_EJ(i) = accumulatedEnergyProduction_EJ(i-1)+energyProductionVector_unsorted_EJ(idx);
        accumulatedLandUse_Mha(i) = accumulatedLandUse_Mha(i-1)+ landRequirementVector_unsorted_Mha(idx);
    end
    %Remove datapoint from energy yields vector, indicating taken
    energyYields_unsorted(idx) = NaN;
end



end

