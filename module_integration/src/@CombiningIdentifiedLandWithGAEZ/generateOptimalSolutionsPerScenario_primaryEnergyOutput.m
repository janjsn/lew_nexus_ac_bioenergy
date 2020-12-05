function [ optimalScenarios_primaryEnergyOutput_array ] = generateOptimalSolutionsPerScenario_primaryEnergyOutput( obj )
%Generating optimal solutions based on maximizing primary energy output.
%Coupled with the other similar function for non bidoiversity hotspots
%scenarios. (suboptimal, forgot those scenarios first time and it was a
%quickfix).
%130819 Jan Sandstad Næss

ModelSettings = obj.Settings;
CropTypeArray_fromSettings = ModelSettings.CropTypeArray;


%% Finding number of combinations
binaryVector_includeCropInOptimization = [CropTypeArray_fromSettings.includeInPrimaryEnergyOptimization];
cropIDs2Optimize = [CropTypeArray_fromSettings(binaryVector_includeCropInOptimization == 1).ID];

nCrops = sum(binaryVector_includeCropInOptimization);
nYears = length(ModelSettings.yearsInAnalyses_GAEZ);
nClimates = length(ModelSettings.ClimateScenarioArray);
nFertilizerLevels = length(ModelSettings.fertilizerLevelsVector);
nIrrigationLevels = length(ModelSettings.irrigationLevelsVector);

%fprintf( [num2str(nCrops) ' ' num2str(nYears) ' ' num2str(nClimates) ' ' num2str(nFertilizerLevels) ' ' num2str(nIrrigationLevels)]);

nCombinations = nYears*nClimates*nFertilizerLevels*nIrrigationLevels;

optimalScenarios_primaryEnergyOutput_array(1:nCombinations) = OptimizedScenarios_cropCombinations;
%area per latitude from first GAEZ array object
areaPerLatitudeVector_hectare = obj.GAEZ_array(1).areaPerLatitudeVector_hectare;

counter = 1;

IDs_GAEZ_climateScenario = [obj.GAEZ_array.climateScenarioID];
isIrrigated_GAEZ = [obj.GAEZ_array.isIrrigated];
isRainfed_GAEZ = [obj.GAEZ_array.isRainfed];
yearsVector_GAEZ = [obj.GAEZ_array.year];
fertilizerLevelVector_GAEZ = [obj.GAEZ_array.inputRate];
fprintf('Found a possible total of ')
fprintf(num2str(nCombinations));
fprintf(' combinations and scenarios, actual number might be smaller. Optimizing for primary energy output.. \n');
%fprintf('Analyzing each crop for given scenario. \n')

%% Finding optimal solutions
for i = 1:nClimates
    for j = 1:nFertilizerLevels
        for k = 1:nIrrigationLevels
            for l = 1:nYears
                
                %Getting information from Model settings
                optimalScenarios_primaryEnergyOutput_array(counter).ClimateScenario = ModelSettings.ClimateScenarioArray(i);
                optimalScenarios_primaryEnergyOutput_array(counter).fertilizerLevel = ModelSettings.fertilizerLevelsVector(j);
                optimalScenarios_primaryEnergyOutput_array(counter).irrigationLevel = ModelSettings.irrigationLevelsVector(k);
                
                
                optimalScenarios_primaryEnergyOutput_array(counter).year = ModelSettings.yearsInAnalyses_GAEZ(l);
                optimalScenarios_primaryEnergyOutput_array(counter).CropType_array = ModelSettings.CropTypeArray(binaryVector_includeCropInOptimization == 1);
                
                climateScenarioID = optimalScenarios_primaryEnergyOutput_array(counter).ClimateScenario.ID;
                
                
                %% Finding gaez data combinations valid for given scenario and
                %analyzing those
                
                %Checking climate scenario
                identifiedWithCorrectClimateScenario_GAEZ_logicalVector = [IDs_GAEZ_climateScenario] == climateScenarioID;
                %Checking fertilizer level (input level)
                identifiedWithCorrectFertilizerLevel_GAEZ_logicalVector = [fertilizerLevelVector_GAEZ] == optimalScenarios_primaryEnergyOutput_array(counter).fertilizerLevel;
                %Checking irrigation
                if optimalScenarios_primaryEnergyOutput_array(counter).irrigationLevel == 0
                    identifiedWithCorrectIrrigation_GAEZ_logicalVector = [isRainfed_GAEZ] == 1;
                elseif optimalScenarios_primaryEnergyOutput_array(counter).irrigationLevel == 1
                    identifiedWithCorrectIrrigation_GAEZ_logicalVector = [isIrrigated_GAEZ] == 1;
                else
                    error('Model is built for irrigation on/off only. Not multiple levels. Input or code must be fixed.')
                end
                %Checking year
                identifiedWithCorrectYear_GAEZ_logicalVector = [yearsVector_GAEZ] == optimalScenarios_primaryEnergyOutput_array(counter).year;
                
                %Finding all accepted combos
                identified_GAEZ_logicalVector = identifiedWithCorrectClimateScenario_GAEZ_logicalVector & identifiedWithCorrectFertilizerLevel_GAEZ_logicalVector & identifiedWithCorrectIrrigation_GAEZ_logicalVector & identifiedWithCorrectYear_GAEZ_logicalVector;
                %Getting the specific GAEZ data identified
                if sum(identified_GAEZ_logicalVector) > 0
                    optimalScenarios_primaryEnergyOutput_array(counter).dataBelongingToScenarioHasBeenIdentified = 1;
                    identifiedGAEZ_array = obj.GAEZ_array(identified_GAEZ_logicalVector);
                    
                    %Removing unwanted crops
                    wantedFromIdentifiedGAEZ = zeros(1,length(identifiedGAEZ_array));
                    for identifiedGAEZ_c = 1:length(identifiedGAEZ_array)
                       for cropIDs2Optimize_c = 1:length(cropIDs2Optimize)
                           if identifiedGAEZ_array(identifiedGAEZ_c).cropID == cropIDs2Optimize(cropIDs2Optimize_c)
                              wantedFromIdentifiedGAEZ(identifiedGAEZ_c) = 1;
                           end
                       end
                    end
                    
                    identifiedGAEZ_array = identifiedGAEZ_array(wantedFromIdentifiedGAEZ == 1);
                    
                    %% Analyzing each crop for given scenario to find optimal solution
                    
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimizationMatrix_cropID_vector = [identifiedGAEZ_array.cropID];
                    
                    %Checking if matrix dimensions match from primary energy
                    %output for different crops
                    if length(identifiedGAEZ_array) > 1
                        for c_1 = 2:length(identifiedGAEZ_array)
                            if size(identifiedGAEZ_array(c_1).primaryEnergyOutput_spatial_lhv_MJ_perYear) ~= size(identifiedGAEZ_array(1).primaryEnergyOutput_spatial_lhv_MJ_perYear)
                                error('Spatial dimensions of lhv primary energy output matrixes dont match for different crops. Fix.')
                            elseif size(identifiedGAEZ_array(c_1).primaryEnergyOutput_spatial_hhv_MJ_perYear) ~= size(identifiedGAEZ_array(1).primaryEnergyOutput_spatial_hhv_MJ_perYear)
                                error('Spatial dimensions of hhv primary energy output matrixes dont match for different crops. Fix.')
                            end %if
                        end %for
                    end %if
                    
                    mSize = size(identifiedGAEZ_array(c_1).primaryEnergyOutput_spatial_lhv_MJ_perYear);
                    %preallocation
                    matrix_cropWithHighestSpatialPrimaryEnergyPotential_lhv_ID = zeros(mSize(1),mSize(2));
                    matrix_cropWithHighestSpatialPrimaryEnergyPotential_hhv_ID = zeros(mSize(1),mSize(2));
                    %matrix_spatialPrimaryEnergyPotential_optimal_lhv_MJ_perYear = zeros(mSize(1),mSize(2));
                    %matrix_spatialPrimaryEnergyPotential_optimal_hhv_MJ_perYear = zeros(mSize(1),mSize(2));
                    
                    %Finding otpimal combination maximizing primary energy
                    %output

                    %Preallocating with results from first object
                    binary_spatialPrimEnergyPotentialHigherThanZero_firstCrop_lhv = [identifiedGAEZ_array(1).primaryEnergyOutput_spatial_lhv_MJ_perYear > 0];
                    binary_spatialPrimEnergyPotentialHigherThanZero_firstCrop_hhv = [identifiedGAEZ_array(1).primaryEnergyOutput_spatial_hhv_MJ_perYear > 0];
                    matrix_cropWithHighestSpatialPrimaryEnergyPotential_lhv_ID(binary_spatialPrimEnergyPotentialHigherThanZero_firstCrop_lhv) = identifiedGAEZ_array(1).cropID;
                    matrix_cropWithHighestSpatialPrimaryEnergyPotential_hhv_ID(binary_spatialPrimEnergyPotentialHigherThanZero_firstCrop_hhv) = identifiedGAEZ_array(1).cropID;
                    matrix_spatialPrimaryEnergyPotential_optimal_lhv_MJ_perYear = identifiedGAEZ_array(1).primaryEnergyOutput_spatial_lhv_MJ_perYear;
                    matrix_spatialPrimaryEnergyPotential_optimal_hhv_MJ_perYear = identifiedGAEZ_array(1).primaryEnergyOutput_spatial_hhv_MJ_perYear;
                    matrix_waterDeficit_lhv = zeros(mSize(1),mSize(2));
                    matrix_waterDeficit_hhv = zeros(mSize(1),mSize(2));
                    
                    
                    spatialOutput_MJ_perYear_rowColCrop_lhv = zeros(mSize(1),mSize(2),length(identifiedGAEZ_array));
                    spatialOutput_MJ_perYear_rowColCrop_hhv = zeros(mSize(1),mSize(2),length(identifiedGAEZ_array));
                    for nG = 1:length(identifiedGAEZ_array)
                       spatialOutput_MJ_perYear_rowColCrop_lhv(:,:,nG) =  identifiedGAEZ_array(nG).primaryEnergyOutput_spatial_lhv_MJ_perYear;
                       spatialOutput_MJ_perYear_rowColCrop_hhv(:,:,nG) =  identifiedGAEZ_array(nG).primaryEnergyOutput_spatial_hhv_MJ_perYear;
                    end
                    
                    
                    %Water deficit
                    if optimalScenarios_primaryEnergyOutput_array(counter).irrigationLevel == 1
                        waterDeficit_binaryVec = [identifiedGAEZ_array.waterDeficitDataIsGiven_binary];
                        if sum(sum(waterDeficit_binaryVec)) == length(waterDeficit_binaryVec)
                            optimalScenarios_primaryEnergyOutput_array(counter).waterDeficitIsConsidered = 1;
                            matrix_waterDeficit_lhv = identifiedGAEZ_array(1).waterDeficitMatrix_mm;
                            matrix_waterDeficit_hhv = identifiedGAEZ_array(1).waterDeficitMatrix_mm;
                        end
                    end
                    
                    %% Get optimal results
                    % This part should be recoded with logical indexing.
                    if length(identifiedGAEZ_array) > 1
                        for row = 1:mSize(1)
                            for col = 1:mSize(2)
                                for nG = 2:length(identifiedGAEZ_array)
                                    if  spatialOutput_MJ_perYear_rowColCrop_lhv(row,col,nG) >  matrix_spatialPrimaryEnergyPotential_optimal_lhv_MJ_perYear(row,col)
                                        matrix_spatialPrimaryEnergyPotential_optimal_lhv_MJ_perYear(row,col) = spatialOutput_MJ_perYear_rowColCrop_lhv(row,col,nG);
                                        matrix_cropWithHighestSpatialPrimaryEnergyPotential_lhv_ID(row,col) = identifiedGAEZ_array(nG).cropID;
                                        if optimalScenarios_primaryEnergyOutput_array(counter).waterDeficitIsConsidered == 1
                                            matrix_waterDeficit_lhv(row,col) = identifiedGAEZ_array(nG).waterDeficitMatrix_mm(row,col);
                                        end
                                    end %if
                                    if spatialOutput_MJ_perYear_rowColCrop_hhv(row,col,nG) > matrix_spatialPrimaryEnergyPotential_optimal_hhv_MJ_perYear(row,col)
                                        matrix_spatialPrimaryEnergyPotential_optimal_hhv_MJ_perYear(row,col) = spatialOutput_MJ_perYear_rowColCrop_hhv(row,col,nG);
                                        matrix_cropWithHighestSpatialPrimaryEnergyPotential_hhv_ID(row,col) = identifiedGAEZ_array(nG).cropID;
                                        if optimalScenarios_primaryEnergyOutput_array(counter).waterDeficitIsConsidered == 1
                                            matrix_waterDeficit_hhv(row,col) = identifiedGAEZ_array(nG).waterDeficitMatrix_mm(row,col);
                                        end
                                    end %if
                                end %for nGAEZ                                
                            end %for col
                        end %for row
                    end %if length GAEZ
                    
                    %% Get globally best crop for every grid cell, and energy yields
                    if ~isempty(identifiedGAEZ_array)
                        %Preallocation
                        optimalScenarios_primaryEnergyOutput_array(counter).globalGrid_allLand_lhv_optimalCropID =  zeros(mSize(1),mSize(2));
                        optimalScenarios_primaryEnergyOutput_array(counter).globalGrid_allLand_lhv_optimalCropID(:,:) = -999; %Missing value
                        optimalScenarios_primaryEnergyOutput_array(counter).globalGrid_allLand_lhv_bioenergyYields_GJ_perHaYear = zeros(mSize(1),mSize(2));
                        %Water check
                        if optimalScenarios_primaryEnergyOutput_array(counter).waterDeficitIsConsidered == 1
                            optimalScenarios_primaryEnergyOutput_array(counter).globalGrid_allLand_lhv_waterDeficit_mm_perYear =  zeros(mSize(1),mSize(2));
                        end
                        
                        %Get optimals
                        for i_gaez = 1:length(identifiedGAEZ_array)
                            %Find locations were current crop show better
                            %energy yields:
                            binary_betterEnergyYields = optimalScenarios_primaryEnergyOutput_array(counter).globalGrid_allLand_lhv_bioenergyYields_GJ_perHaYear < identifiedGAEZ_array(i_gaez).globalEnergyYields_lhv_GJperHectarePerYear;
                            %Replace values and crop ID
                            optimalScenarios_primaryEnergyOutput_array(counter).globalGrid_allLand_lhv_bioenergyYields_GJ_perHaYear(binary_betterEnergyYields) = identifiedGAEZ_array(i_gaez).globalEnergyYields_lhv_GJperHectarePerYear(binary_betterEnergyYields);
                            optimalScenarios_primaryEnergyOutput_array(counter).globalGrid_allLand_lhv_optimalCropID(binary_betterEnergyYields) = identifiedGAEZ_array(i_gaez).cropID;
                            if optimalScenarios_primaryEnergyOutput_array(counter).waterDeficitIsConsidered == 1
                                optimalScenarios_primaryEnergyOutput_array(counter).globalGrid_allLand_lhv_waterDeficit_mm_perYear(binary_betterEnergyYields) =  identifiedGAEZ_array(i_gaez).waterDeficitMatrix_mm(binary_betterEnergyYields);
                            end
                        end
                        
                    end

                    
                    %Save results to array
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimizationMatrix_MJ_perYear_lhv = matrix_spatialPrimaryEnergyPotential_optimal_lhv_MJ_perYear; %MJ/y lhv
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimizationMatrix_MJ_perYear_hhv = matrix_spatialPrimaryEnergyPotential_optimal_hhv_MJ_perYear; % MJ/y hhv
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimizationMatrix_cropIDs_lhv = matrix_cropWithHighestSpatialPrimaryEnergyPotential_lhv_ID;%IDs lhv
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimizationMatrix_cropIDs_hhv = matrix_cropWithHighestSpatialPrimaryEnergyPotential_hhv_ID; %IDs hhv
                    
                    %calc totals MJ/year
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimization_total_MJ_perYear_lhv = sum(sum(matrix_spatialPrimaryEnergyPotential_optimal_lhv_MJ_perYear)); %lhv
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimization_total_MJ_perYear_hhv = sum(sum(matrix_spatialPrimaryEnergyPotential_optimal_hhv_MJ_perYear)); %hhv
                    
                    %Calc totals EJ/year
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimization_total_EJ_perYear_lhv = optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimization_total_MJ_perYear_lhv*10^-12; %lhv
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimization_total_EJ_perYear_hhv = optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimization_total_MJ_perYear_hhv*10^-12;%hhv
                    
                    %Save water deficit
                    if optimalScenarios_primaryEnergyOutput_array(counter).waterDeficitIsConsidered == 1
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimizationMatrix_waterDeficit_lhv_mm = matrix_waterDeficit_lhv;
                    optimalScenarios_primaryEnergyOutput_array(counter).spatialOptimizationMatrix_waterDeficit_hhv_mm = matrix_waterDeficit_hhv;
                    end
                    %Moving on to next scenario
                    counter = counter +1;
                    fprintf(num2str(counter));
                    fprintf(', ');
                end %if found scenarios number is >0
            end %for l= nYears
        end %for irrigation
    end %for fertilizer
    
end %for climates

binaryVector_scenariosWithContent = [optimalScenarios_primaryEnergyOutput_array.dataBelongingToScenarioHasBeenIdentified];
optimalScenarios_primaryEnergyOutput_array = optimalScenarios_primaryEnergyOutput_array(binaryVector_scenariosWithContent == 1);

for i = 1:length(optimalScenarios_primaryEnergyOutput_array)
    %Generating description string
    optimalScenarios_primaryEnergyOutput_array(i).scenarioDescription_string = optimalScenarios_primaryEnergyOutput_array(i).generateScenarioDescriptionString;
    
end


fprintf(' Finished generating ')
fprintf(num2str(length(optimalScenarios_primaryEnergyOutput_array)));
fprintf(' optimal solutions. \n');

end

