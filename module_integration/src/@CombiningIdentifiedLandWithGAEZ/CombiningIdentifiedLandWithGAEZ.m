classdef CombiningIdentifiedLandWithGAEZ
    %COMBININGIDENITFIEDLANDWITHGAEZ Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Settings
        GAEZ_array
        GAEZ_array_noBiodiversityHotspots
        GAEZ_waterScarcityData
        Baselines
        
        ClimateScenario_array
        CropType_array
        areaPerLatitudeVector_hectare
        identifiedLandMatrix_hectares
        identifiedLandMatrix_fractionOfCell
        identifiedLand_latitudeVector_centered
        identifiedLand_longitudeVector_centered
        identifiedLand_latitudeVector_northCorner
        identifiedLand_longitudeVector_westCorner
        identifiedLandMatrix_excludingBiodiversityHotspots_hectares
        identifiedLandMatrix_excludingBiodiversityHotspots_fractions
        biodiversityHotspots_fractions
        Cropland
        RUSLE
        
        OptimalPrimaryEnergyOutput_scenarioArray
        OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray
        
        WaterScarcity_scenarioArray
        WaterScarcity_noBiodiversityHotspots_scenarioArray
        Mixed_management
        DPI_array
        Country_array
        country_mask_gpw
        SSP_data_array
        FAO_N_fertilizer_use_kg_per_ha
        N_use_gridded_Potter
        P_use_gridded_Potter
        
    end
    
    methods
        
        
        function exportResults(obj, filename)
            
            exportNoBiodiversityHotspots = 1;
            
           strings = {obj.GAEZ_array.cropname} ;
           strings = strings';
           
           nHistogramCategories = length(obj.GAEZ_array(1).cropYield_identifiedLands_histogram_ha);
           nGaez = length(obj.GAEZ_array);
           
           outMatrix(nGaez, nHistogramCategories) = 0 ;
           
           
           for i = 1:nGaez
               outMatrix(i,:) = obj.GAEZ_array(i).cropYield_identifiedLands_histogram_ha;
           end
          
           headersVector = obj.GAEZ_array(1).cropYield_identifiedLands_histDescription_tonsPerYear_lessEqual;
           
           cropnames = char({obj.GAEZ_array.cropname});
           
           sum_yields = [obj.GAEZ_array.cropYield_identifiedLands_tonsPerYear_sum];
           
           save('Output/exported.mat', 'cropnames', 'strings', 'outMatrix', 'headersVector', 'sum_yields' )
           
%           csvwrite(filename, strings, 'Histogram, yields', 'A2');  
%           csvwrite(filename, strings, 2,1);  
%           csvwrite(filename, outMatrix, 2,2);  
%           csvwrite(filename, headersVector, 1,1);
           
          %           writematrix(outMatrix,filename,'Histogram, yields',1,'Range','B2')
          %           writematrix(strings, filename, 'Histogram, yields', 1, 'Range', 'A2')
          %           writematrix(headersVector, filename, 'Histogram, yields', 1, 'Range', 'A1');
          
          
          %% WITHOUT BIODIVERSITY HOTSPOTS
          if exportNoBiodiversityHotspots == 1
              strings = {[obj.GAEZ_array.cropname '_excludingBiodiversityHotspots']} ;
           strings = strings';
           
           nHistogramCategories = length(obj.GAEZ_array_noBiodiversityHotspots(1).cropYield_identifiedLands_histogram_ha);
           nGaez = length(obj.GAEZ_array);
           
           outMatrix(nGaez, nHistogramCategories) = 0 ;
           
           
           for i = 1:nGaez
               outMatrix(i,:) = obj.GAEZ_array_noBiodiversityHotspots(i).cropYield_identifiedLands_histogram_ha;
           end
          
           headersVector = obj.GAEZ_array_noBiodiversityHotspots(1).cropYield_identifiedLands_histDescription_tonsPerYear_lessEqual;
           
           cropnames = char({obj.GAEZ_array_noBiodiversityHotspots.cropname});
           
           sum_yields = [obj.GAEZ_array_noBiodiversityHotspots.cropYield_identifiedLands_tonsPerYear_sum];
           
           save('Output/exported_noBH.mat', 'cropnames', 'strings', 'outMatrix', 'headersVector', 'sum_yields' )
           
           filename_2 = ['noBH_' filename];
%           csvwrite(filename_2, strings, 'Histogram, yields', 'A2');  
%           csvwrite(filename_2, strings, 2,1);  
%           csvwrite(filename_2, outMatrix, 2,2);  
%           csvwrite(filename_2, headersVector, 1,1);
          end



        end
        
        optimalScenarios_array = generateOptimalSolutionsPerScenario_primaryEnergyOutput(obj)
        
        plotOptimizedScenarios_primaryEnergyOutputLHV_barChart_oneYear( obj, outputFolder, year )
        
         exportOptimizedScenarios_primaryEnergy_lhv_toMAT(obj, filename )
         
         exportIdentifiedLandMatrix_andGAEZyields_boxWithGivenLatsLons(obj, lat1, lat2, lon1, lon2)
         
         WaterScarcityScenarioArray = generateWaterScarcityScenarios_primaryEnergyOptimization(obj, OptimalPrimaryEnergyOutput_scenarioArray, GAEZ_waterScarcityData )
         
         plotWaterScarcityScenarios_primaryEnergyLHV_barChart( obj, outputFolder )
         
         exportLandMatrices2netcdf( obj )
         
         obj =  establishBaselines(obj, year, climateScenario_ID, waterSupplyLevel, inputLevel, landMatrix,fractionMatrix,latitudeVector_centered,longitudeVector_centered)
         %add2GaezArray_excludedBiodiversityHotspotsData(obj)
         
         [ obj ] = mergeOptimizedScenarioResultsWithBHexcludedIntoMainArray( obj )
         
         [ obj ] = estimateDeltaEnergyProduction_comparedToBaseline_optimals( obj )
         [ futureBaselineArray ] = getFutureBaselines_optimizedCropMix( obj )
         obj = mergeWaterScarcityScenarios_withWithoutBH( obj )
         
         plotPresentOptimizedScenariosTogetherWithMixedWaterSupply( obj, outputFolder )
         plot_potentials_all_scenarios( obj, outputFolder )
         
         plotEnergyProductionAsShareOfSSP2100Demand( obj, outputFolder, year, climateScenarioID )
         
         bulkExport2Mat(obj)
         
         plot_SSP_comparisons( obj )
         
         mixed_management_scenario = generate_mixed_management_scenario_from_yield_gaps( obj )
    end
    
end

