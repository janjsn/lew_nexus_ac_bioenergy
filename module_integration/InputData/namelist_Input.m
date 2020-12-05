%% NAMELISTS/SETTINGS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Last updated: 22.10.2020.
%Updated by: JSN

%Usage notes:
%If the Settings class has been updated since, this namelist also must be updated accordingly.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ModelSettings = Settings;

%% OUTPUT FOLDER
ModelSettings.outputFolders = {'Output/Output_2019_09_30'};
%% SET INPUT LAND FILES
%These files are provided in GIT as it is processed output data from previous CCI and biodiversity hotspots step.
ModelSettings.filename_latlon = 'InputData/abandoned_cropland_1992_2015_5arcmin_timestamp_2020_08_24_1448.nc';
ModelSettings.filename_landAvailability = 'InputData/abandoned_cropland_1992_2015_5arcmin_timestamp_2020_08_24_1448.nc';
ModelSettings.filename_landAvailabilityOutsideBiodiversityHotspots = 'InputData/abandoned_cropland_1992_2015_5arcmin_outside_biodiversity_hotspots.nc';
ModelSettings.filename_biodiversityHotspots = 'InputData/Biodiversity_hotspots_5arcmin.nc';
ModelSettings.filename_cropland = 'InputData/Croplands_Global_2015_5arcmin_timestamp_2020_07_01_0040.nc'; %Uses the Cropland() constructor.


%% SET VARIABLE NAMES IN INPUT LAND FILES
ModelSettings.dimName_latitude = 'lat';
ModelSettings.dimName_longitude = 'lon';
ModelSettings.varName_latitudeVector = 'lat';
ModelSettings.varName_longitudeVector = 'lon';
ModelSettings.varName_landFractionMatrix = 'abandoned_cropland_fractions';
ModelSettings.varName_landMatrix_ha = 'abandoned_cropland_hectare';
ModelSettings.varName_biodiversityHotspotFractions = 'Biodiversity_hotspots_fractions';
ModelSettings.varName_landMatrixOutsideBiodiversityHotspots_ha = 'abandoned_cropland_outside_biodiversity_hotspots';
ModelSettings.varName_landFractionMatrixOutsideBiodiversityHotspots = 'abandoned_cropland_outside_biodiversity_hotspots_fractions';

%% Switch to use coarser 5arcmin data to calculate land availability outside biodiversity hotspots
% Turn on if biodiversity hotspots have not been filtered out at higher
% resolution.
%
% Turning this switch on will overrule this file:
% ModelSettings.filename_landAvailabilityOutsideBiodiversityHotspots 

ModelSettings.calculate_land_availability_outside_biod_hotspots_5arcmin = 0;

%% Plots and exports
% THESE SWITCHES MIGHT NEED UPDATE. MOST SOURCE FILES HAVE BEEN PRODUCED
% WITH TARGETED FUNCTIONS.
%Master switch
ModelSettings.exportResults = 0;
%GAEZ
ModelSettings.plotHistograms_GAEZ_specific_yields = 0;
ModelSettings.exportGAEZscenarioResultsToNetcdf  = 0;
%Optimal scenarios, combinations
ModelSettings.plotHistograms_optimalSolution_landDistributedIntoPrimEnergyPot = 0;
ModelSettings.plotBarChartOneYear_EJ_perYear_afterScenario_forAllTheYears = 0;
ModelSettings.exportOptimalSolutions_primEnergy_toNetcdf = 0;
ModelSettings.plotOptimalSolution_IDs_toMaps = 0;

%% GAEZ analysis characteristics.
%Note that GAEZ input files must be downloaded from GAEZ 3.0 website (due to copyrights), put in GAEZ maps/Data/ and
%mapped in the Excel dictionary at /GAEZ maps/Import GAEZ files.xlsx.

ModelSettings.yearsInAnalyses_GAEZ = [1975 2020 2050 2080];
ModelSettings.fertilizerLevelsVector = [1 2 3];
ModelSettings.fertilizerLevelsDescription_string = {'low', 'medium', 'high'}; %Equals Agricultural Management Intensity. Consider to update variable names.
ModelSettings.irrigationLevelsVector = [0 1];
ModelSettings.irrigationLevelsDescription_string = {'rainfed', 'irrigated'};

%For baseline comparison (deltas)
ModelSettings.baselineYear = 2020;
ModelSettings.baselineFertilizerLevel = 3;
ModelSettings.baselineIrrigationLevel = 0;
ModelSettings.baselineClimateID = 2;

%% CROP TYPES
%Edit this one to change crop type classes/input
%Crop type IDs must match IDs in Excel input
ModelSettings.CropTypeArray = makeCropTypeArray(); 

%Pick either LHV or HHV (calorific values)
ModelSettings.useLHV = 1;
ModelSettings.useHHV = 0;



%% Climate scenarios 
%Edit this one to change climate scenario classes/input
%Climate scenario IDs must match IDs in GAEZ Excel input
%/src/makeClimateScenarioArray
ModelSettings.ClimateScenarioArray = makeClimateScenarioArray(); 

%% Yield gaps
%Edit this one to change input file location, gap allocation method, etc.
%/src/getYieldGapRatios
%Input filename for yield gaps is set within the function. Data must be
%downloaded from GAEZ website.
ModelSettings.yield_gap_categories = getYieldGapRatios();

%% Nitrogen
%For comparison with gridded fertilizer use. Data must be downloaded from
%FAOSTAT country inventories, and Potter et al. (2012)
%https://doi.org/10.7927/H49Z92TD.
ModelSettings.filename_nitrogen_use  = 'InputData/FAOSTAT_country_fertilizer_use.xlsx';
ModelSettings.filename_gridded_nitrogen_use = 'InputData/Yield gaps/nitrogen-fertilizer-global-geotif/NFertilizer_global_geotif/nfertilizer_global.tif';
ModelSettings.filename_gridded_phosphorus_use = 'InputData/Yield gaps/phosphorus-fertilizer-global-geotif/PFertilizer_global_geotif/pfertilizer_global.tif';


%% Country masks, filenames and sheetname for dictionary
%Download data from: https://doi.org/10.7927/H4TD9VDP
ModelSettings.filename_country_mask_IDs = 'InputData/gpw-v4-national-identifier-grid-rev11_2pt5_min_tif/gpw-v4-country-level-summary-rev11.xlsx';
ModelSettings.sheetname_country_mask_IDs = 'GPWv4 Rev11 Summary';
ModelSettings.filename_country_mask_gpw =  'InputData/gpw-v4-national-identifier-grid-rev11_2pt5_min_tif/gpw_v4_national_identifier_grid_rev11_2pt5_min.tif';

