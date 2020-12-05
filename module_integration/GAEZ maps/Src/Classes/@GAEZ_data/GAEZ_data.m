classdef GAEZ_data
    %GAEZ_DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cropname
        cropID
        ID
        inputID_unique
        year
        climateScenarioID
        crop_higherHeatingValue
        crop_lowerHeatingValue
        biodiversityHotspotsExcludedFromIdentifiedLand_binary = 0;
        dataMatrix_raw
        multiplicationFactor
        dataMatrix_estimated_sameLatLonSteps %raw*multiplicationFactor
        dataMatrix_estimated_wholeWorld_sameLatLonSteps
        dataMatrix_lonXlat_multiplicationFactorAccounted
        yieldsLargerThanZero_binaryMatrix
        numberOfDatapointsWithYieldsHigherThanZero
        fractionsMatrix_spatialLocationIsBiodiversityHotspot
        binaryMatrix_spatialLocationHasLowWaterScarcity % 0 = not scarce, 1 = scarce
        filename_waterDeficit
        waterDeficitDataIsGiven_binary
        waterDeficitMatrix_mm
        globalYields_estimated_tonPerYear
        globalYields_estimated_tonPerYear_afterLatitude
        globalYields_estimated_tonPerHectareAndYear
        globalYields_estimated_tonPerHectareAndYear_afterLatitude
        globalEnergyYields_lhv_GJperHectarePerYear
        globalEnergyYields_hhv_GJperHectarePerYear
        areaPerLatitudeVector_shareOfEarth
        areaPerLatitudeVector_m2
        areaPerLatitudeVector_km2
        areaPerLatitudeVector_hectare
        latitudeVector_upperCorner
        longitudeVector_leftCorner
        latitudeVector_centered
        longitudeVector_centered
        cellExtent_latitude
        cellExtent_longitude
        latitudeLimits
        longitudeLimits
        angleUnit %string
        columnStartFrom %string
        rowsStartFrom %string
        rasterExtent_longitude
        rasterExtent_latitude
        coordinateSystemType %string
        isTifData %binary
        isAscData %binary
        inputRate
        isIrrigated %binary
        isRainfed %binary
        isConsideringCO2Fertilization %binary
        
        fractionsMatrix_identifiedLand
        fractionsMatrix_biodiversityHotspots_oneIsAllHotspot_zeroIsNone
        areaMatrix_identifiedLand_ha
        fractionsMatrix_excludingBiodiversityHotspots_identifiedLand
        areaMatrix_excludingBiodiversityHotspots_identifiedLand_ha
        cropYield_identifiedLands_tonsPerYear
        cropYield_identifiedLands_tonsPerYear_sum
        cropYield_identifiedLands_histogram_ha
        cropYields_identifiedLands_histogram_outputOfType_tonsPerYear
        cropYield_identifiedLands_histDescription_tonsPerYear_lessEqual
        
        cropYield_identifiedLands_excludingBiodHotspots_tonsPerYear
        cropYield_identifiedLands_excludingBiodHotspots_tonsPerYear_sum
        cropYield_iLands_excludBH_histogram_ha
        cropYields_iLands_excludBH_histogram_outputOfType_tonsPerYear
        cropYield_iLands_excludBH_histDescription_tonsPerYear_lessEqual
        
        
        calorificValue_weightedAllPlant_MJperKgFromGAEZ_lhv
        calorificValue_weightedAllPlant_MJperKgFromGAEZ_hhv
        
        primaryEnergyOutput_spatial_lhv_global_MJ_perYear
        primaryEnergyOutput_spatial_hhv_global_MJ_perYear
        
        primaryEnergyOutput_spatial_lhv_MJ_perYear
        primaryEnergyOutput_spatial_hhv_MJ_perYear
        primaryEnergyOutput_spatial_lhv_TJ_perYear
        primaryEnergyOutput_spatial_hhv_TJ_perYear
        primaryEnergyOutput_total_lhv_MJ_perYear
        primaryEnergyOutput_total_hhv_MJ_perYear
        primaryEnergyOutput_total_lhv_EJ_perYear
        primaryEnergyOutput_total_hhv_EJ_perYear
        
        %No biodiversity hotspots
        
        primaryEnergyOutput_excludingBH_spatial_lhv_MJ_perYear
        primaryEnergyOutput_excludingBH_spatial_hhv_MJ_perYear
        primaryEnergyOutput_excludingBH_spatial_lhv_TJ_perYear
        primaryEnergyOutput_excludingBH_spatial_hhv_TJ_perYear
        primaryEnergyOutput_excludingBH_total_lhv_MJ_perYear
        primaryEnergyOutput_excludingBH_total_hhv_MJ_perYear
        primaryEnergyOutput_excludingBH_total_lhv_EJ_perYear
        primaryEnergyOutput_excludingBH_total_hhv_EJ_perYear
        
        AggregatedProduction_oneDegree

    end
    
    methods
        data = getDataFromLatitudeLongitude_rawMatrix(obj, latitude, longitude)
        
        yieldMatrix = createYieldMatrix_fromBinaryMatrixLatitudeVectorLongitudeVector(obj, binaryMatrix_longitudeLatitude, latitudeVector, longitudeVector)    
    
        obj = generateAreaPerLongitudeVector(obj)
        
        obj = estimateGlobalYields(obj)
        
        obj = distributeCropYieldsToHistogram(obj, landMatrix_hectares, landMatrix_hectares_excludingBiodiversityHotspots);
        
        plotHistogram_areaAfterYield( obj, outputFolder )
		
		makeNcFile_cropYields_tonsPerYear_andMore(obj, filename, outputFolder)
			
        obj = estimatePrimaryEnergyOutput_hhv_MJ(obj)
        
        obj = estimatePrimaryEnergyOutput_lhv_MJ(obj)
        
        obj = getWeightedCalorificValues_fromCropTypeArray(obj,CropTypeArray)
        
        export2netcdf_boxLatsLons(obj, longitudeCoordinates_border ,latitudeCoordinates_border  )
        
        makeNcFile_oneDegree( obj, filename, outputFolder )
        
        export2netcdf_globalData( obj )
        
    end
    
end

