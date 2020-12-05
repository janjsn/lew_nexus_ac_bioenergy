%% ---- Code to integrate datasets and methods for lwe nexus study.----
% Quantifies bioenergy potentials, and associated land and energy water use
% on recently abandoned cropland.

%Settings are defined in: 
%%%%% MAIN NAMELIST FILE IS LOCATED: InputData/namelist_Input.m --> netcdf filenames, variables ++
%%%%% Input excel file for GAEZ crop data, 'GAEZ maps/Input/Import GAEZ files.xlsx' --> GAEZ data
%More information in namelist_Input.m

%Variable names are, in general, self explaining.
%Targeted output export and plot functions are located in /src/.. or as methods for
%individual classes (check @XXX folders).

%Written by: Jan Sandstad Næss, jan.s.nass@ntnu.no
%Last updated: Dec 2020
%-----------------------------------------------------------------------
tic

addpath(genpath(pwd())); %Added subfolders to path


namelist_Input; %Run namelist script.

clear Model
Nexus = CombiningIdentifiedLandWithGAEZ;


%% Generate array for GAEZ crop data
fprintf('Importing data from gaez. \n')
%Running gaez code
for i = 1:length(Nexus)
    Nexus(i).Settings = ModelSettings;
    if i == 1
        [Nexus(i).GAEZ_array, Nexus(i).GAEZ_waterScarcityData] = main_gaez;
    else
        Nexus(i).GAEZ_array = Nexus(1).GAEZ_array;
       Nexus(i).GAEZ_waterScarcityData =  Nexus(1).GAEZ_waterScarcityData;
    end
    Nexus(i).GAEZ_array_noBiodiversityHotspots = Nexus(i).GAEZ_array;
    
    Nexus(i).ClimateScenario_array = ModelSettings.ClimateScenarioArray;
    Nexus(i).CropType_array = ModelSettings.CropTypeArray;
    for j = 1:length(Nexus(i).GAEZ_array_noBiodiversityHotspots)
        Nexus(i).GAEZ_array_noBiodiversityHotspots(j).biodiversityHotspotsExcludedFromIdentifiedLand_binary = 1;
    end
end
 clear ModelSettings; %clearing from scope
for i = 1:length(Nexus)
%READ NC FILES

%areaMatrix_identifiedLand_gaezSize_m2

%% Open nc files to get data on dimensions, land availability, and biodiversity hotpots 
% Dimensions
fprintf(['Loading dimensions from nc file: ' Nexus(i).Settings.filename_latlon '\n']);
ncid = netcdf.open(Nexus(i).Settings.filename_latlon);
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
lastVarID = nvars-1;
for k = 0:lastVarID
    [varname0,xtype0,dimids0,natts0] = netcdf.inqVar(ncid,k);
    if strcmp(varname0, Nexus(i).Settings.varName_latitudeVector)
         Nexus(i).identifiedLand_latitudeVector_centered = netcdf.getVar(ncid,k);
    elseif strcmp(varname0, Nexus(i).Settings.varName_longitudeVector)
        Nexus(i).identifiedLand_longitudeVector_centered = netcdf.getVar(ncid,k);
    end
end
netcdf.close(ncid);
% Land availability
fprintf(['Loading available area from nc file: ' Nexus(i).Settings.filename_landAvailability '\n']);
ncid = netcdf.open(Nexus(i).Settings.filename_landAvailability);
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
lastVarID = nvars-1;
for k = 0:lastVarID
    [varname0,xtype0,dimids0,natts0] = netcdf.inqVar(ncid,k);
    if strcmp(varname0, Nexus(i).Settings.varName_landMatrix_ha)
       Nexus(i).identifiedLandMatrix_hectares = netcdf.getVar(ncid,k);
    elseif strcmp(varname0, Nexus(i).Settings.varName_landFractionMatrix)
        Nexus(i).identifiedLandMatrix_fractionOfCell = netcdf.getVar(ncid,k);
    end
    
end
netcdf.close(ncid);

if Nexus(i).Settings.calculate_land_availability_outside_biod_hotspots_5arcmin ~= 1
    
    fprintf(['Loading available area outside biodiversity hotspots from nc file: ' Nexus(i).Settings.filename_landAvailabilityOutsideBiodiversityHotspots  '\n']);
    ncid = netcdf.open(Nexus(i).Settings.filename_landAvailabilityOutsideBiodiversityHotspots);
    [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
    lastVarID = nvars-1;
    for k = 0:lastVarID
        [varname0,xtype0,dimids0,natts0] = netcdf.inqVar(ncid,k);
        if strcmp(varname0, Nexus(i).Settings.varName_landMatrixOutsideBiodiversityHotspots_ha)
            Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares = netcdf.getVar(ncid,k);
        elseif strcmp(varname0, Nexus(i).Settings.varName_landFractionMatrixOutsideBiodiversityHotspots)
            Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_fractions = netcdf.getVar(ncid,k);
        end
        
    end
    netcdf.close(ncid);
else
    fprintf('Will use coarser 5arcmin biodiversity hotspots data to filter out areas. \n');
end

fprintf(['Loading biodiversity hotspots as fractions of grid cell from nc file: ' Nexus(i).Settings.filename_biodiversityHotspots '\n']);
ncid = netcdf.open(Nexus(i).Settings.filename_biodiversityHotspots);
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
lastVarID = nvars-1;
for k = 0:lastVarID
    [varname0,xtype0,dimids0,natts0] = netcdf.inqVar(ncid,k);
    if strcmp(varname0, Nexus(i).Settings.varName_biodiversityHotspotFractions)
       Nexus(i).biodiversityHotspots_fractions = netcdf.getVar(ncid,k);
    end
    
end
netcdf.close(ncid);

%% Calculating land availability outside biodiversity hotspots if switch is on
if Nexus(i).Settings.calculate_land_availability_outside_biod_hotspots_5arcmin == 1
    % Calculate areas outside biodiversity hotspots
    Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_fractions = Nexus(i).identifiedLandMatrix_fractionOfCell.*(1-Nexus(i).biodiversityHotspots_fractions) ;
    Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares = Nexus(i).identifiedLandMatrix_hectares.*(1-Nexus(i).biodiversityHotspots_fractions);
end


%% Import cropland areas
Nexus(i).Cropland = Cropland(Nexus(i).Settings.filename_cropland);


%% Estimate yields and process data
fprintf('Estimating yields. \n');


Nexus(i).GAEZ_array = generateCropYields_tonsPerYear(Nexus(i).GAEZ_array, Nexus(i).identifiedLandMatrix_hectares,Nexus(i).biodiversityHotspots_fractions, Nexus(i).GAEZ_waterScarcityData.waterScarcityIsLowMatrix_binary, Nexus(i).identifiedLandMatrix_fractionOfCell,Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares , Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_fractions);
Nexus(i).GAEZ_array_noBiodiversityHotspots = generateCropYields_tonsPerYear(Nexus(i).GAEZ_array_noBiodiversityHotspots, Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares,Nexus(i).biodiversityHotspots_fractions, Nexus(i).GAEZ_waterScarcityData.waterScarcityIsLowMatrix_binary, Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_fractions,Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares , Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_fractions);


%Make histograms of land yields, ha per yield category 

%%PRINT Histogram making???
if Nexus(i).Settings.exportResults == 1
        %Histograms
        if Nexus(i).Settings.plotHistograms_GAEZ_specific_yields == 1
            fprintf('Generating histogram plots and writing nc files, GAEZ. \n')
        end
end

%%ESTIMATIONS
for j = 1:length(Nexus(i).GAEZ_array)
    %Including Biodiversity hotspots
    Nexus(i).GAEZ_array(j) = Nexus(i).GAEZ_array(j).distributeCropYieldsToHistogram(Nexus(i).identifiedLandMatrix_hectares, Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares);
    Nexus(i).GAEZ_array_noBiodiversityHotspots(j) = Nexus(i).GAEZ_array_noBiodiversityHotspots(j).distributeCropYieldsToHistogram(Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares,Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares);
 
    %% Plotting histograms to files if export switch is turned on
    if Nexus(i).Settings.exportResults == 1
        %Histograms
        if Nexus(i).Settings.plotHistograms_GAEZ_specific_yields == 1
        %fprintf('Generating histogram plots and writes nc files. \n')
        Nexus(i).GAEZ_array(j).plotHistogram_areaAfterYield(Nexus(i).Settings.outputFolders{i});
        %Model(i).exportResults([outputFolders{i} '/' ]);
        
        %Excluding Biodiversity hotspots
        Nexus(i).GAEZ_array_noBiodiversityHotspots(j).plotHistogram_areaAfterYield(Nexus(i).Settings.outputFolders{i});
        end
        %NETCDF
        if Nexus(i).Settings.exportGAEZscenarioResultsToNetcdf == 1
            if exist([Nexus(i).Settings.outputFolders{i} '/NC files/'],'dir') ~= 7
                mkdir([Nexus(i).Settings.outputFolders{i} '/NC files/']);
            end
            timestamp = getTimestampString();
            filename_nc = ([Nexus(i).Settings.outputFolders{i} '/NC files/' Nexus(i).GAEZ_array(j).cropname '_' timestamp '.nc']);
            filename_noBiodiversityHotspots_nc = ([Nexus(i).Settings.outputFolders{i} '/NC files/' Nexus(i).GAEZ_array(j).cropname '_excludingBiodiversityHotspots_' timestamp '.nc']);
            
            
            Nexus(i).GAEZ_array(j).makeNcFile_cropYields_tonsPerYear_andMore(filename_nc, Nexus(i).Settings.outputFolders{i});
            Nexus(i).GAEZ_array_noBiodiversityHotspots(j).makeNcFile_cropYields_tonsPerYear_andMore(filename_noBiodiversityHotspots_nc, Nexus(i).Settings.outputFolders{i});
        end
    end %if export
end

%% Estimating primary energy output
fprintf('Estimating primary energy. \n');
for j = 1:length(Nexus.GAEZ_array)
    %Getting weighted calorific values. MJ/kg GAEZ output.
    %NB: For sugarcane GAEZ only provides ton/year of sugar output, not
    %including bagasse, straws etc.
    Nexus(i).GAEZ_array(j) = Nexus(i).GAEZ_array(j).getWeightedCalorificValues_fromCropTypeArray(Nexus(i).CropType_array);
    
    %Estimating spatial and total primary energy output using weighted lhv
    Nexus(i).GAEZ_array(j) = Nexus(i).GAEZ_array(j).estimatePrimaryEnergyOutput_lhv_MJ;
    %Estimating spatial and total primary energy output using weighted hhv
    Nexus(i).GAEZ_array(j) = Nexus(i).GAEZ_array(j).estimatePrimaryEnergyOutput_hhv_MJ;
    
end  %for j = 1:length(Model.GAEZ_array)
%Same when excluding biodiversity hotspots
for j = 1:length(Nexus.GAEZ_array_noBiodiversityHotspots)
    Nexus(i).GAEZ_array_noBiodiversityHotspots(j) = Nexus(i).GAEZ_array_noBiodiversityHotspots(j).getWeightedCalorificValues_fromCropTypeArray(Nexus(i).CropType_array);
    Nexus(i).GAEZ_array_noBiodiversityHotspots(j) = Nexus(i).GAEZ_array_noBiodiversityHotspots(j).estimatePrimaryEnergyOutput_lhv_MJ;
    Nexus(i).GAEZ_array_noBiodiversityHotspots(j) = Nexus(i).GAEZ_array_noBiodiversityHotspots(j).estimatePrimaryEnergyOutput_hhv_MJ;
end
end %for i = 1:length(Model)



%% Finding optimal solutions maximizing primary energy output including biodiversity hotspots and without biodiversity hotspots
for i = 1:length(Nexus)
   Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray = Nexus(i).generateOptimalSolutionsPerScenario_primaryEnergyOutput; 
   Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray = Nexus(i).generateOptimalSolutionsPerScenario_noBiodiversityHotspots_pEn;
   %Estimating hectares and EJ per crop and creating histogram vectors
   for j = 1:length(Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray)
       Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j) = Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).estimateHectaresPerCrop(Nexus(i).identifiedLandMatrix_hectares);
       Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j) = Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).estimatePrimaryEnergyPerCrop;
       Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j) = Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).generateHistograms_categorizedAfterEnergyPotentialsAndCrops(Nexus(i).identifiedLandMatrix_hectares);
       
       %Model(i).
       %Plotting histograms and exporting if switch is on in settings
       if Nexus(i).Settings.exportResults == 1
           if Nexus(i).Settings.plotHistograms_optimalSolution_landDistributedIntoPrimEnergyPot == 1
               Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_lhv(Nexus(i).Settings.outputFolders{i});
               Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_hhv(Nexus(i).Settings.outputFolders{i});
           end
           if Nexus(i).Settings.exportOptimalSolutions_primEnergy_toNetcdf  == 1
              Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).exportToNetCDF(Nexus(i).Settings.outputFolders{i}, Nexus(i).identifiedLand_latitudeVector_centered, Nexus(i).identifiedLand_longitudeVector_centered),Nexus(i).identifiedLandMatrix_fractionOfCell;
           end
           if Nexus(i).Settings.plotOptimalSolution_IDs_toMaps == 1
               Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).plotGriddedDataMap_IDs_lhv(obj, Nexus(i).identifiedLand_latitudeVector_centered, Nexus(i).identifiedLand_longitudeVector_centered, Nexus(i).Settings.CropTypeArray, Nexus(i).Settings.outputFolders{i});
               %plotGriddedDataMap( Model(i).identifiedLand_latitudeVector_centered, Model(i).identifiedLand_longitudeVector_centered, Model(i).OptimalPrimaryEnergyOutput_scenarioArray(j).spatialOptimizationMatrix_cropIDs_lhv', 'Crop IDs', [Model(i).Settings.outputFolders{i} 'Maps_optimal_solutions/LHV/' Model(i).OptimalPrimaryEnergyOutput_scenarioArray(j).scenarioDescription_string '_optimal_solutions_lhv.nc'])
           end
       end
       
   end
   for j = 1:length(Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray)
       Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j) = Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).estimateHectaresPerCrop(Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares);
       Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j) = Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).estimatePrimaryEnergyPerCrop;
       Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j) = Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).generateHistograms_categorizedAfterEnergyPotentialsAndCrops(Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares);
       %Plotting histograms and exporting if switch is on in settings
       if Nexus(i).Settings.exportResults == 1 
           if Nexus(i).Settings.plotHistograms_optimalSolution_landDistributedIntoPrimEnergyPot == 1
               
               Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_lhv(Nexus(i).Settings.outputFolders{i});
               Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_hhv(Nexus(i).Settings.outputFolders{i});
           end
           if Nexus(i).Settings.exportOptimalSolutions_primEnergy_toNetcdf  == 1
              Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).exportToNetCDF(Nexus(i).Settings.outputFolders{i}, Nexus(i).identifiedLand_latitudeVector_centered, Nexus(i).identifiedLand_longitudeVector_centered, Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_fractions);
           end
           if Nexus(i).Settings.plotOptimalSolution_IDs_toMaps == 1
               Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).plotGriddedDataMap_IDs_lhv(obj, Nexus(i).identifiedLand_latitudeVector_centered, Nexus(i).identifiedLand_longitudeVector_centered, Nexus(i).Settings.CropTypeArray, Nexus(i).Settings.outputFolders{i});
               %plotGriddedDataMap( Model(i).identifiedLand_latitudeVector_centered, Model(i).identifiedLand_longitudeVector_centered, Model(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).spatialOptimizationMatrix_cropIDs_lhv', 'Crop IDs', [Model(i).Settings.outputFolders{i} '/Maps_optimal_solutions/LHV/' Model(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(j).scenarioDescription_string '_optimal_solutions_lhv.nc'])
           end
       end
       
   end
   %Ploting bar chart primary energy output optimization scenarios
   if Nexus(i).Settings.exportResults == 1 
       if Nexus(i).Settings.plotBarChartOneYear_EJ_perYear_afterScenario_forAllTheYears == 1
           for nYears = 1:length(Nexus(i).Settings.yearsInAnalyses_GAEZ)
               Nexus(i).plotOptimizedScenarios_primaryEnergyOutputLHV_barChart_oneYear(Nexus(i).Settings.outputFolders{i}, Nexus(i).Settings.yearsInAnalyses_GAEZ(nYears));
           end
       end
   end
   %% Generate water scarcity scenarios using primary energy optimization
   Nexus(i).WaterScarcity_scenarioArray = Nexus(i).generateWaterScarcityScenarios_primaryEnergyOptimization( Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray, Nexus(i).GAEZ_waterScarcityData );
   Nexus(i).WaterScarcity_noBiodiversityHotspots_scenarioArray =  Nexus(i).generateWaterScarcityScenarios_primaryEnergyOptimization( Nexus(i).OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray, Nexus(i).GAEZ_waterScarcityData );
   %Generate histograms, water scarcity
   for j = 1:length(Nexus(i).WaterScarcity_scenarioArray)
   Nexus(i).WaterScarcity_scenarioArray(j) = Nexus(i).WaterScarcity_scenarioArray(j).generateHistograms_categorizedAfterEnergyPotentialsAndCrops( Nexus(i).identifiedLandMatrix_hectares );
   end
   for j = 1:length(Nexus(i).WaterScarcity_noBiodiversityHotspots_scenarioArray)
      Nexus(i).WaterScarcity_noBiodiversityHotspots_scenarioArray(j) = Nexus(i). WaterScarcity_noBiodiversityHotspots_scenarioArray(j).generateHistograms_categorizedAfterEnergyPotentialsAndCrops( Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares );
      %% SET CORRECT LAND MATRIX HERE.
   end
   %Plotting if exports are turned on
   if Nexus(i).Settings.exportResults == 1 
       for j = 1:length(Nexus(i).WaterScarcity_scenarioArray)
           Nexus(i).WaterScarcity_scenarioArray(j).plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_lhv( Nexus(i).Settings.outputFolders{i} )
       end
       %no biodiversity hotspots
       for j = 1:length(Nexus(i).WaterScarcity_scenarioArray)
           Nexus(i).WaterScarcity_noBiodiversityHotspots_scenarioArray(j).plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_lhv( Nexus(i).Settings.outputFolders{i} )
       end
       
   end
   
   %% Aggregating GAEZ results to one degree
   fprintf('Aggregating GAEZ results to one degree..')
   fprintf('\n');
   for n_GAEZ = 1:length(Nexus(i).GAEZ_array)
      Nexus(i).GAEZ_array(n_GAEZ).fractionsMatrix_biodiversityHotspots_oneIsAllHotspot_zeroIsNone = Nexus(i).biodiversityHotspots_fractions;
      Nexus(i).GAEZ_array(n_GAEZ).AggregatedProduction_oneDegree = GAEZ_data_aggregated( Nexus(i).GAEZ_array(n_GAEZ),360,180);
   end
   
   fprintf('Establishing baselines..')
   fprintf('\n');
   
   %% Merging Optimized Scenarios no biodiversity hotspots results into main Optimized Scenarios array
   Nexus(i) = Nexus(i).mergeOptimizedScenarioResultsWithBHexcludedIntoMainArray();
   
 %Get area per latitude vector from first instance in GAEZ array
   Nexus(i).areaPerLatitudeVector_hectare = Nexus(i).GAEZ_array(1).areaPerLatitudeVector_hectare;
   
   %Create standardized energy yield histogram data
   for j = 1:length(Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray)
       Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).identifiedLandMatrix_hectare = Nexus(i).identifiedLandMatrix_hectares;
       Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j) = Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).createStandardizedEnergyYieldHistogramData(Nexus(i).Settings.energyYieldHistograms_standardBounds_GJperHa);
   end %for Optimal primary energy output scenario array
   
    
   
   %% Aggregate some Optimized Scenarios results to one degree
   for j = 1:length(Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray)
       Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).identifiedLandMatrix_hectare = Nexus(i).identifiedLandMatrix_hectares;
       Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).areaPerLatitudeVector_hectare = Nexus(i).areaPerLatitudeVector_hectare;
       Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).AggregatedResults_oneDegree = Nexus(i).OptimalPrimaryEnergyOutput_scenarioArray(j).aggregate2oneDegree(Nexus(i).identifiedLand_longitudeVector_centered, Nexus(i).identifiedLand_latitudeVector_centered);
   end
   
   %% Establish baselines and estimate changed future energy production potential
   Nexus(i) = Nexus(i).establishBaselines(2020,2,0,3,Nexus(i).identifiedLandMatrix_hectares, Nexus(i).identifiedLandMatrix_fractionOfCell, Nexus(i).identifiedLand_latitudeVector_centered, Nexus(i).identifiedLand_longitudeVector_centered );
   Nexus(i) = Nexus(i).estimateDeltaEnergyProduction_comparedToBaseline_optimals();
   Nexus(i).Baselines.FutureBaselines_optimizedCropMix = Nexus(i).getFutureBaselines_optimizedCropMix;
   
   fprintf('Merging water scarcity scenarios and upscaling results to one degree.');
   fprintf('\n');
   %Merge WS scenarios
   Nexus(i) = Nexus(i).mergeWaterScarcityScenarios_withWithoutBH;

   %Upscale to 1 degree, WS scenarios
   for j = 1:length(Nexus(i).WaterScarcity_scenarioArray)
       if Nexus(i).WaterScarcity_scenarioArray(j).waterDeficitIsConsidered == 1
           Nexus(i).WaterScarcity_scenarioArray(j).areaPerLatitudeVector_hectare = Nexus(i).areaPerLatitudeVector_hectare;
           Nexus(i).WaterScarcity_scenarioArray(j).AggregatedResults = Nexus(i).WaterScarcity_scenarioArray(j).aggregate2oneDegree(Nexus(i).identifiedLand_longitudeVector_centered,  Nexus(i).identifiedLand_latitudeVector_centered, Nexus(i).identifiedLandMatrix_hectares, Nexus(i).identifiedLandMatrix_excludingBiodiversityHotspots_hectares);
       end
   end
   
   %Estimate mm ha GJ-1
   for ws = 1:length(Nexus(i).WaterScarcity_scenarioArray)
       if Nexus(i).WaterScarcity_scenarioArray(ws).waterDeficitIsConsidered == 1
           Nexus(i).WaterScarcity_scenarioArray(ws).WaterScarcityLevel = Nexus(i).GAEZ_waterScarcityData;
           Nexus(i).WaterScarcity_scenarioArray(ws) = Nexus(i).WaterScarcity_scenarioArray(ws).estimateWaterUsePerEnergyYieldGain(Nexus.identifiedLandMatrix_hectares, Nexus.identifiedLandMatrix_excludingBiodiversityHotspots_hectares);
       end
   end
   
   %% GET SSP DATA
   Nexus(i).SSP_data_array = import_SSP_data('InputData/SSP database bioenergy demand.xlsx');
   
   
   %% Get country masks
   Nexus(i).Country_array = getCountryMaskIDs(Nexus(i).Settings.filename_country_mask_IDs, Nexus(i).Settings.sheetname_country_mask_IDs);
   [ country_mask, country_mask_R] = getCountryMasks_gpw( Nexus(i).Settings.filename_country_mask_gpw);
   country_mask = country_mask';
   
   lat_mask = [country_mask_R.LatitudeLimits(2)- (country_mask_R.CellExtentInLatitude/2):-country_mask_R.CellExtentInLatitude:country_mask_R.LatitudeLimits(1)+(country_mask_R.CellExtentInLatitude/2)];
   lon_mask = [country_mask_R.LongitudeLimits(1)+country_mask_R.CellExtentInLongitude/2:country_mask_R.CellExtentInLongitude:country_mask_R.LongitudeLimits(2)-country_mask_R.CellExtentInLongitude/2];
   
   
   country_mask_model_res = zeros(length(Nexus(i).identifiedLand_longitudeVector_centered), length(Nexus(i).identifiedLand_latitudeVector_centered));
   mSize = size(country_mask_model_res);
   for lons = 1:mSize(1)
       [~, idx_lon] = min(abs(Nexus(i).identifiedLand_longitudeVector_centered(lons)-lon_mask));
       
       for lats = 1:mSize(2)
           [~, idx_lat] = min(abs(Nexus(i).identifiedLand_latitudeVector_centered(lats)-lat_mask));
           country_mask_model_res(lons, lats) = country_mask(idx_lon, idx_lat);
       end
   end
   
   Nexus(i).country_mask_gpw = country_mask_model_res;
   
   
   %% GET AND GRID NITROGEN FERTILIZER LEVELS
   Nexus(i).Country_array = get_FAO_fertilizer_data( Nexus(i).Settings.filename_nitrogen_use, Nexus(i).Country_array );
   Nexus(i).FAO_N_fertilizer_use_kg_per_ha = zeros(length(Nexus(i).identifiedLand_longitudeVector_centered), length(Nexus(i).identifiedLand_latitudeVector_centered));
   
   for n_countries = 1:length(Nexus(i).Country_array)
       if Nexus(i).Country_array(n_countries).FAO_cropland_nitrogen_use_2018_kg_per_ha > 0
           Nexus(i).FAO_N_fertilizer_use_kg_per_ha(Nexus(i).country_mask_gpw == Nexus(i).Country_array(n_countries).GPW_country_ISO_numeric) = Nexus(i).Country_array(n_countries).FAO_cropland_nitrogen_use_2018_kg_per_ha;
       elseif Nexus(i).Country_array(n_countries).FAO_cropland_nitrogen_use_2018_kg_per_ha == -999
           Nexus(i).FAO_N_fertilizer_use_kg_per_ha(Nexus(i).country_mask_gpw == Nexus(i).Country_array(n_countries).GPW_country_ISO_numeric) = -999;
       end
   end
   
   %% Generate mixed management intensity scenarios
   Nexus(i).Mixed_management = Nexus(i).generate_mixed_management_scenario_from_yield_gaps;
   
   
   
end %for Models

%Clearing some variables from scope
vars = {'dimids0','dimlen1','dimlen2','dimname1','dimname2','lastVarID','n_Lat','n_Lon','natts0','ncid','ndims','ngatts','nvars','unlimdimid','varname0','xtype0','i','j','k', 'n_GAEZ'};
clear(vars{:});
clear('vars');

toc





