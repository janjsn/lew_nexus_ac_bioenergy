function WaterScarcityScenarioArray = generateWaterScarcityScenarios_primaryEnergyOptimization(obj, OptimalPrimaryEnergyOutput_scenarioArray, GAEZ_waterScarcityData )

fprintf('Generating water scarcity scenarios \n');
%Getting water scarcity data
waterScarcityMatrix = GAEZ_waterScarcityData.dataMatrix_global;
lowWaterScarcityID = GAEZ_waterScarcityData.lowWaterScarcity_ID;
lowWaterScarcityMatrix_binary = waterScarcityMatrix == lowWaterScarcityID;


%Getting optimal primary energy output scenario array data
nOPEO_scenarios = length(OptimalPrimaryEnergyOutput_scenarioArray);

OPEO_scenarioArray_irrigationLevel = [OptimalPrimaryEnergyOutput_scenarioArray.irrigationLevel];
OPEO_scenarioArray_fertilizerLevel = [OptimalPrimaryEnergyOutput_scenarioArray.fertilizerLevel];
OPEO_scenarioArray_year = [OptimalPrimaryEnergyOutput_scenarioArray.year];

OPEO_scenarioArray_climateID = zeros(1,nOPEO_scenarios);

for i = 1:nOPEO_scenarios
    OptimalPrimaryEnergyOutput_scenarioArray(i).ClimateScenario;
    OPEO_scenarioArray_climateID(i) = OptimalPrimaryEnergyOutput_scenarioArray(i).ClimateScenario.ID;
end

uniqueIrrigationLevels = unique(OPEO_scenarioArray_irrigationLevel);
uniqueFertilizerLevels = unique(OPEO_scenarioArray_fertilizerLevel);
uniqueYears = unique(OPEO_scenarioArray_year);
uniqueClimateIDs = unique(OPEO_scenarioArray_climateID);

nCombinations = length(uniqueFertilizerLevels)*length(uniqueYears)*length(uniqueClimateIDs);

WaterScarcityScenarioArray(1:nCombinations) = WaterScarcityScenarios;

c=1;
for i = 1:length(uniqueYears)
    
    for j = 1:length(uniqueFertilizerLevels)
        
        for k = 1:length(uniqueClimateIDs)
            %Estimating potential primary energy for given
            %time, fertilizer, climate parameters
            temp_OPEO_binaryVector = zeros(1,nOPEO_scenarios);
            %Checking which optimal scenarios fits conditions
            for l = 1:length(temp_OPEO_binaryVector)
                if OPEO_scenarioArray_year(l) == uniqueYears(i)
                    if OPEO_scenarioArray_fertilizerLevel(l) == uniqueFertilizerLevels(j)
                        if OPEO_scenarioArray_climateID(l) == uniqueClimateIDs(k)
                            temp_OPEO_binaryVector(l) = 1;
                        end
                    end
                    
                end
            end
            
            %Checking if scenarios found is actually two and estimating and generating
            %output
            if sum(temp_OPEO_binaryVector) == 2
                temp_OPEO_scenarioArray = OptimalPrimaryEnergyOutput_scenarioArray(temp_OPEO_binaryVector == 1);
                
                %error check
                if sum([temp_OPEO_scenarioArray.irrigationLevel]) ~= 1
                    temp_OPEO_scenarioArray(1).ClimateScenario.ID
                    temp_OPEO_scenarioArray(2).ClimateScenario.ID
                    error('Need one scenario with irrigation and one without. Check code.')
                end
                
                WaterScarcityScenarioArray(c).scenarioDescription_string = [num2str(uniqueYears(i)) '_' temp_OPEO_scenarioArray(1).ClimateScenario.name '_fertilizerLevel_' num2str(uniqueFertilizerLevels(j)) ];
                WaterScarcityScenarioArray(c).ClimateScenario = temp_OPEO_scenarioArray.ClimateScenario;
                WaterScarcityScenarioArray(c).fertilizerLevel = uniqueFertilizerLevels(j);
                WaterScarcityScenarioArray(c).year = uniqueYears(i);
                WaterScarcityScenarioArray(c).irrigation_binaryMatrix = lowWaterScarcityMatrix_binary;
                
                %Water deficit
                irrigationVec = [temp_OPEO_scenarioArray.waterDeficitIsConsidered];
                irrigationPos = find(irrigationVec== 1);
                rainfedPos = find(irrigationVec == 0);
                if temp_OPEO_scenarioArray(1).waterDeficitIsConsidered == 1 || temp_OPEO_scenarioArray(2).waterDeficitIsConsidered == 1
                    waterDeficitIsConsidered = 1;
                    WaterScarcityScenarioArray(c).waterDeficitIsConsidered = 1;
                elseif temp_OPEO_scenarioArray(1).waterDeficitIsConsidered == 0
                    waterDeficitIsConsidered = 0;
                end
                if waterDeficitIsConsidered
                    WaterScarcityScenarioArray(c).waterDeficit_lhv_mm = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_waterDeficit_lhv_mm;
                    WaterScarcityScenarioArray(c).waterDeficit_hhv_mm = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_waterDeficit_hhv_mm;
                    WaterScarcityScenarioArray(c).waterUseToIrrigate_lhv_total_m3 = sum(sum((10^-3*WaterScarcityScenarioArray(c).waterDeficit_lhv_mm).*(10^4*obj.identifiedLandMatrix_hectares)));
                    WaterScarcityScenarioArray(c).waterUseToIrrigate_hhv_total_m3 = sum(sum((10^-3*WaterScarcityScenarioArray(c).waterDeficit_hhv_mm).*(10^4*obj.identifiedLandMatrix_hectares)));
                    %Get primary bioenergy production at rain-fed and
                    %irrigated water supply
                    WaterScarcityScenarioArray(c).primaryEnergyProductionMatrix_rainfed = temp_OPEO_scenarioArray(rainfedPos).spatialOptimizationMatrix_MJ_perYear_lhv;
                    WaterScarcityScenarioArray(c).primaryEnergyProductionMatrix_irrigated = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_MJ_perYear_lhv;
                    %Delta energy output
                    WaterScarcityScenarioArray(c).deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_MJ_perYear_lhv-temp_OPEO_scenarioArray(rainfedPos).spatialOptimizationMatrix_MJ_perYear_lhv;
                    WaterScarcityScenarioArray(c).deltaPrimaryEnergy_hhv_ir_rf_MJ_perYear = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_MJ_perYear_hhv-temp_OPEO_scenarioArray(rainfedPos).spatialOptimizationMatrix_MJ_perYear_hhv;
                    %MJ per mm irrigation
                    binary_waterDeficitZero_lhv = WaterScarcityScenarioArray(c).waterDeficit_lhv_mm == 0;
                    binary_waterDeficitZero_hhv = WaterScarcityScenarioArray(c).waterDeficit_hhv_mm == 0;
                    WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_lhv_MJ_per_mm = WaterScarcityScenarioArray(c).deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear./WaterScarcityScenarioArray(c).waterDeficit_lhv_mm;
                    WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_hhv_MJ_per_mm = WaterScarcityScenarioArray(c).deltaPrimaryEnergy_hhv_ir_rf_MJ_perYear./WaterScarcityScenarioArray(c).waterDeficit_hhv_mm;
                    %fixing if any cells where divided by zero
                    WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_lhv_MJ_per_mm(binary_waterDeficitZero_lhv) = 0;
                    WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_hhv_MJ_per_mm(binary_waterDeficitZero_hhv) = 0;
                    
                    %Water use of low water scarcity areas irrigation
                    WaterScarcityScenarioArray(c).waterUseToIrrigateMatrix_lowWaterScarcityAreas_lhv = WaterScarcityScenarioArray(c).waterDeficit_lhv_mm;
                    WaterScarcityScenarioArray(c).waterUseToIrrigateMatrix_lowWaterScarcityAreas_lhv(WaterScarcityScenarioArray(c).irrigation_binaryMatrix == 0) = 0;
                    WaterScarcityScenarioArray(c).waterUseToIrrigateMatrix_lowWaterScarcityAreas_hhv = WaterScarcityScenarioArray(c).waterDeficit_hhv_mm;
                    WaterScarcityScenarioArray(c).waterUseToIrrigateMatrix_lowWaterScarcityAreas_hhv(WaterScarcityScenarioArray(c).irrigation_binaryMatrix == 0) = 0;
                    %Water use of low water scarcity areas irrigation
                    WaterScarcityScenarioArray(c).waterUseToIrrigate_lhv_total_lowWaterScarcityAreas_m3 = sum(sum((WaterScarcityScenarioArray(c).waterUseToIrrigateMatrix_lowWaterScarcityAreas_lhv*10^-3).*(10^4*obj.identifiedLandMatrix_hectares)));
                    WaterScarcityScenarioArray(c).waterUseToIrrigate_hhv_total_lowWaterScarcityAreas_m3 = sum(sum((WaterScarcityScenarioArray(c).waterUseToIrrigateMatrix_lowWaterScarcityAreas_hhv*10^-3).*(10^4*obj.identifiedLandMatrix_hectares)));
                end
%                 
                if temp_OPEO_scenarioArray(1).irrigationLevel == 0
                    rainfedPos = 1;
                    irrigationPos = 2;
                elseif temp_OPEO_scenarioArray(1).irrigationLevel == 1
                    rainfedPos = 2;
                    irrigationPos = 1;
                end

                
                
                tempPrimaryEnergyMatrix_lhv = temp_OPEO_scenarioArray(rainfedPos).spatialOptimizationMatrix_MJ_perYear_lhv;
                tempPrimaryEnergyMatrix_hhv = temp_OPEO_scenarioArray(rainfedPos).spatialOptimizationMatrix_MJ_perYear_hhv;
                tempCropIDs_lhv = temp_OPEO_scenarioArray(rainfedPos).spatialOptimizationMatrix_cropIDs_lhv;
                tempCropIDs_hhv = temp_OPEO_scenarioArray(rainfedPos).spatialOptimizationMatrix_cropIDs_hhv;
                %Adding irrigated results where water scarcity is low
                tempPrimaryEnergyMatrix_lhv(lowWaterScarcityMatrix_binary == 1) = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_MJ_perYear_lhv(lowWaterScarcityMatrix_binary == 1);
                tempPrimaryEnergyMatrix_hhv(lowWaterScarcityMatrix_binary == 1) = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_MJ_perYear_hhv(lowWaterScarcityMatrix_binary);
                tempCropIDs_lhv(lowWaterScarcityMatrix_binary == 1) = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_cropIDs_lhv(lowWaterScarcityMatrix_binary == 1);
                tempCropIDs_hhv(lowWaterScarcityMatrix_binary == 1) = temp_OPEO_scenarioArray(irrigationPos).spatialOptimizationMatrix_cropIDs_hhv(lowWaterScarcityMatrix_binary == 1);
                %Saving to object
                WaterScarcityScenarioArray(c).primaryEnergyMatrix_MJ_perYear_lhv = tempPrimaryEnergyMatrix_lhv;
                WaterScarcityScenarioArray(c).primaryEnergyMatrix_MJ_perYear_hhv = tempPrimaryEnergyMatrix_hhv;
                WaterScarcityScenarioArray(c).primaryEnergyMatrix_cropIDs_lhv = tempCropIDs_lhv;
                WaterScarcityScenarioArray(c).primaryEnergyMatrix_cropIDs_hhv = tempCropIDs_hhv;
                
                WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_lhv = sum(sum(tempPrimaryEnergyMatrix_lhv));
                WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_hhv = sum(sum(tempPrimaryEnergyMatrix_hhv));
                
                WaterScarcityScenarioArray(c).primaryEnergy_total_EJ_perYear_lhv = WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_lhv*10^-12;
                WaterScarcityScenarioArray(c).primaryEnergy_total_EJ_perYear_hhv = WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_hhv*10^-12;
                
                %Finding unique crop ids
                uniqueCropIDs_lhv = unique(tempCropIDs_lhv);
                uniqueCropIDs_hhv = unique(tempCropIDs_hhv);
                
                uniqueCropIDs_all = zeros(1,length(uniqueCropIDs_lhv)+length(uniqueCropIDs_hhv));
                uniqueCropIDs_all(1:length(uniqueCropIDs_lhv)) = uniqueCropIDs_lhv;
                uniqueCropIDs_all(length(uniqueCropIDs_lhv)+1:end) = uniqueCropIDs_hhv;
                uniqueCropIDs_all = unique(uniqueCropIDs_all(uniqueCropIDs_all > 0));
                
                %getting crop array
                c2=1; %counter crop type array
                tempCropTypeArray = CropType; %reset
                tempCropTypeArray(1:length(uniqueCropIDs_all)) = CropType; %prealloc
                for m = 1:length(uniqueCropIDs_all)
                   for n = 1:length(obj.CropType_array)
                      if uniqueCropIDs_all(m) == obj.CropType_array(n).ID
                         tempCropTypeArray(c2) = obj.CropType_array(n);
                         c2=c2+1; %count
                      end
                   end
                end
                %tempCropTypeArray = tempCropTypeArray(
                WaterScarcityScenarioArray(c).CropType_array = tempCropTypeArray;
                WaterScarcityScenarioArray(c).cropID_vector = [tempCropTypeArray.ID];
                
                WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_rainfed_lhv = sum(sum(tempPrimaryEnergyMatrix_lhv(lowWaterScarcityMatrix_binary == 0)));
                WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_irrigated_lhv = sum(sum(tempPrimaryEnergyMatrix_lhv(lowWaterScarcityMatrix_binary == 1)));
                WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_rainfed_hhv = sum(sum(tempPrimaryEnergyMatrix_hhv(lowWaterScarcityMatrix_binary == 0)));
                WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_irrigated_hhv = sum(sum(tempPrimaryEnergyMatrix_hhv(lowWaterScarcityMatrix_binary == 1)));
                WaterScarcityScenarioArray(c).primaryEnergy_total_EJ_perYear_rainfed_lhv = WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_rainfed_lhv*10^-12;
                WaterScarcityScenarioArray(c).primaryEnergy_total_EJ_perYear_rainfed_hhv = WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_rainfed_hhv*10^-12;
                WaterScarcityScenarioArray(c).primaryEnergy_total_EJ_perYear_irrigated_lhv = WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_irrigated_lhv*10^-12;
                WaterScarcityScenarioArray(c).primaryEnergy_total_EJ_perYear_irrigated_hhv = WaterScarcityScenarioArray(c).primaryEnergy_total_MJ_perYear_irrigated_hhv*10^-12;
                
                mSize_primaryEnergyGain = size(WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_lhv_MJ_per_mm);
                
                if mSize_primaryEnergyGain(1) > 0
                    if mSize_primaryEnergyGain(2) > 0
                        WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare = WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_lhv_MJ_per_mm./obj.identifiedLandMatrix_hectares;
                        WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_hhv_MJ_per_mm_per_hectare = WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_hhv_MJ_per_mm./obj.identifiedLandMatrix_hectares;
                        
                        %Fixing if any elements where divided by zero
                        %WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare(obj.identifiedLandMatrix_hectares == 0) = 0;
                        %WaterScarcityScenarioArray(c).primaryEnergyGainPerIrrigation_hhv_MJ_per_mm_per_hectare(obj.identifiedLandMatrix_hectares == 0) = 0;
                
                    end
                end
                %counter
                c=c+1;
                
            end %if
            
            
        end %for climate
    end %for fertilizer
end %for years
%Getting only objects filled
WaterScarcityScenarioArray = WaterScarcityScenarioArray(1:c-1);
end%function