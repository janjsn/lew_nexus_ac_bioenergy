function exportOptimizedScenarios_primaryEnergy_lhv_toMAT(obj, filename )
%EXPORTOPTIMIZEDSCENARIOS_PRIMARYENERGY_TOMAT Summary of this function goes here
%   Detailed explanation goes here

%% ALL LAND
nCols = length(obj.Settings.CropTypeArray);
nRows = length(obj.OptimalPrimaryEnergyOutput_scenarioArray);

cropIDs = [obj.Settings.CropTypeArray.ID];
histogramMatrix_hectaresPerCropAndScenario = zeros(nRows,nCols);
spatialOptimization_EJ_perYear_perScenario = zeros(1,nRows);
hectaresWithNoYield_perScenario = zeros(1,nRows);
histogramMatrix_EJPerCropAndScenario = zeros(nRows,nCols);

scenarioDescriptions = cell(1,nRows);
for i = 1:nRows
   scenarioDescriptions{i} = obj.OptimalPrimaryEnergyOutput_scenarioArray(i).scenarioDescription_string;
   
   for j = 1:nCols
       pos = 0;
       for k = 1:length(obj.OptimalPrimaryEnergyOutput_scenarioArray(i).spatialOptimizationMatrix_cropID_vector)
           if  obj.OptimalPrimaryEnergyOutput_scenarioArray(i).spatialOptimizationMatrix_cropID_vector(k) == cropIDs(j)
               pos = k;
               
           end
       end
       if pos > 0
       histogramMatrix_hectaresPerCropAndScenario(i,j) = obj.OptimalPrimaryEnergyOutput_scenarioArray(i).landAllocatedToEachCropType_lhv_vector_hectare(pos);
       histogramMatrix_EJPerCropAndScenario(i,j) = obj.OptimalPrimaryEnergyOutput_scenarioArray(i).spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_lhv(pos);
       end
       
   end
   
   spatialOptimization_EJ_perYear_perScenario(i) = obj.OptimalPrimaryEnergyOutput_scenarioArray(i).spatialOptimization_total_EJ_perYear_lhv;
    hectaresWithNoYield_perScenario(i) = obj.OptimalPrimaryEnergyOutput_scenarioArray(i).spatialOptimization_zeroPrimaryEnergyPotential_lhv_hectares;
end

save(filename, 'scenarioDescriptions', 'histogramMatrix_hectaresPerCropAndScenario', 'histogramMatrix_EJPerCropAndScenario', 'spatialOptimization_EJ_perYear_perScenario', 'hectaresWithNoYield_perScenario')


%% NO BIODIVERSITY HOTSPOTS
nCols = length(obj.Settings.CropTypeArray);
nRows = length(obj.OptimalPrimaryEnergyOutput_scenarioArray);

cropIDs = [obj.Settings.CropTypeArray.ID];
histogramMatrix_hectaresPerCropAndScenario_nBH = zeros(nRows,nCols);
spatialOptimization_EJ_perYear_perScenario_nBH = zeros(1,nRows);
hectaresWithNoYield_perScenario_nBH = zeros(1,nRows);
histogramMatrix_EJPerCropAndScenario_nBH = zeros(nRows,nCols);

scenarioDescriptions_nBH = cell(1,nRows);
for i = 1:nRows
   scenarioDescriptions_nBH{i} = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(i).scenarioDescription_string;
   
   for j = 1:nCols
       pos = 0;
       for k = 1:length(obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(i).spatialOptimizationMatrix_cropID_vector)
           if  obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(i).spatialOptimizationMatrix_cropID_vector(k) == cropIDs(j)
               pos = k;
               
           end
       end
       if pos > 0
       histogramMatrix_hectaresPerCropAndScenario_nBH(i,j) = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(i).landAllocatedToEachCropType_lhv_vector_hectare(pos);
       histogramMatrix_EJPerCropAndScenario_nBH(i,j) = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(i).spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_lhv(pos);
       end
       
   end
   
   spatialOptimization_EJ_perYear_perScenario_nBH(i) = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(i).spatialOptimization_total_EJ_perYear_lhv;
    hectaresWithNoYield_perScenario_nBH(i) = obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(i).spatialOptimization_zeroPrimaryEnergyPotential_lhv_hectares;
end
save(['nBH_' filename], 'scenarioDescriptions_nBH', 'histogramMatrix_hectaresPerCropAndScenario_nBH', 'histogramMatrix_EJPerCropAndScenario_nBH', 'spatialOptimization_EJ_perYear_perScenario_nBH', 'hectaresWithNoYield_perScenario_nBH')


end

