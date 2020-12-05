classdef Settings
    %SETTINGS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        exportResults
        outputFolders
        dimName_latitude
        dimName_longitude
        
        filename_latlon
        varName_latitudeVector
        varName_longitudeVector
        filename_landAvailability
        varName_landFractionMatrix
        varName_landMatrix_ha
        filename_landAvailabilityOutsideBiodiversityHotspots
        varName_landFractionMatrixOutsideBiodiversityHotspots
        varName_landMatrixOutsideBiodiversityHotspots_ha
        filename_biodiversityHotspots
        varName_biodiversityHotspotFractions
        
        calculate_land_availability_outside_biod_hotspots_5arcmin
        
        yearsInAnalyses_GAEZ
        CropTypeArray
        useLHV
        useHHV
        ClimateScenarioArray
        fertilizerLevelsVector
        fertilizerLevelsDescription_string
        irrigationLevelsVector
        irrigationLevelsDescription_string
        
        baselineYear = 2020;
        baselineFertilizerLevel = 3;
        baselineIrrigationLevel = 0;
        baselineClimateID 
        
        exportGAEZscenarioResultsToNetcdf
        plotHistograms_GAEZ_specific_yields
        exportOptimalSolutions_primEnergy_toNetcdf 
        plotOptimalSolution_IDs_toMaps
        plotHistograms_optimalSolution_landDistributedIntoPrimEnergyPot
        plotBarChartOneYear_EJ_perYear_afterScenario_forAllTheYears
        energyYieldHistograms_standardBounds_GJperHa = [0 0 100 200 300 400 500 600 700
                                                0 100 200 300 400 500 600 700 800];
                                            
        filename_cropland
        
        yield_gap_categories
       	
        filename_nitrogen_use
        filename_gridded_nitrogen_use
        filename_gridded_phosphorus_use
        
        filename_irrigation_frequency
        
        filename_country_mask_IDs
        sheetname_country_mask_IDs
        filename_country_mask_gpw
        
    end
    
    methods
    end
    
end

