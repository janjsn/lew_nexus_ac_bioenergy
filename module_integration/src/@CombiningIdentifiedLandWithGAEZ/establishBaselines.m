function obj =  establishBaselines(obj, year, climateScenario_ID, waterSupplyLevel, inputLevel, landMatrix,fractionMatrix,latitudeVector_centered,longitudeVector_centered)
%Establishing baseline variants for GAEZ instances, primary energy
%optimization, water supply

%Input year, climateScenario_ID, waterSupplyLevel, inputLevel, landMatrix


obj.Baselines = Baseline;
obj.Baselines.landMatrix = landMatrix;
obj.Baselines.fractionMatrix = fractionMatrix;
obj.Baselines.latitudeVector_centered = latitudeVector_centered;
obj.Baselines.longitudeVector_centered = longitudeVector_centered;
obj.Baselines.year = year;
obj.Baselines.climateScenario_ID = climateScenario_ID;
obj.Baselines.waterSupplyLevel = waterSupplyLevel;
obj.Baselines.inputLevel = inputLevel;

%% GAEZ
obj.Baselines.GAEZ_variants = GAEZ_data;
gaez_counter = 1;
for i = 1:length(obj.GAEZ_array)
    if obj.GAEZ_array(i).year == year && obj.GAEZ_array(i).isIrrigated == waterSupplyLevel && obj.GAEZ_array(i).inputRate == inputLevel && obj.GAEZ_array(i).climateScenarioID == climateScenario_ID
                obj.Baselines.GAEZ_variants(gaez_counter) = obj.GAEZ_array(i);
                gaez_counter = gaez_counter+1;
    end
end
%Optimal crop mix
for i = 1:length(obj.OptimalPrimaryEnergyOutput_scenarioArray)
   if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).irrigationLevel == waterSupplyLevel && obj.OptimalPrimaryEnergyOutput_scenarioArray(i).fertilizerLevel == inputLevel && obj.OptimalPrimaryEnergyOutput_scenarioArray(i).year == year && obj.OptimalPrimaryEnergyOutput_scenarioArray(i).ClimateScenario.ID == climateScenario_ID
      obj.Baselines.OptimizedCropMix_forPrimaryEnergy_variant = obj.OptimalPrimaryEnergyOutput_scenarioArray(i);
   end
end
%Water supply
for i = 1:length(obj.WaterScarcity_scenarioArray)
    if obj.WaterScarcity_scenarioArray(i).year == year && obj.WaterScarcity_scenarioArray(i).fertilizerLevel == inputLevel && obj.WaterScarcity_scenarioArray(i).ClimateScenario.ID == climateScenario_ID
        obj.Baselines.WaterSupplyMix_variant = obj.WaterScarcity_scenarioArray(i);
    end
end


end

