function [ AggregatedResults] = aggregate2oneDegree( obj,longitudeVector_centered,latitudeVector_centered, identifiedLandMatrix_hectares, identifiedLandMatrix_excludedBH_hectares )
%Aggregates water scarcity results to one degree resolution (360x180)


AggregatedResults = AggregatedResults_waterScarcityScenarios;
%Running aggregation algorithm and saving
[AggregatedResults.primaryEnergy_MJ_perYear_lhv, AggregatedResults.latitudeVector_centered, AggregatedResults.longitudeVector_centered, AggregatedResults.latitudeBounds, AggregatedResults.longitudeBounds]  = aggregateMatrix2givenDimensions( obj.primaryEnergyMatrix_MJ_perYear_lhv,longitudeVector_centered,latitudeVector_centered, 360, 180 );
AggregatedResults.primaryEnergy_PJ_perYear_lhv = AggregatedResults.primaryEnergy_MJ_perYear_lhv*10^-9;

%No biodiversity hotspots, same procedure
[AggregatedResults.excluded_BH_primaryEnergy_MJ_perYear_lhv,~,~,~,~] = aggregateMatrix2givenDimensions( obj.exclBH_primaryEnergyMatrix_MJ_perYear,longitudeVector_centered,latitudeVector_centered, 360, 180 );
AggregatedResults.excluded_BH_primaryEnergy_PJ_perYear_lhv = 10^-9*AggregatedResults.excluded_BH_primaryEnergy_MJ_perYear_lhv;

%Aggregate land matrix
AggregatedResults.identifiedLandMatrix_hectare = aggregateMatrix2givenDimensions( identifiedLandMatrix_hectares,longitudeVector_centered,latitudeVector_centered, 360, 180 );
AggregatedResults.excluded_BH_identifiedLandMatrix_hectare = aggregateMatrix2givenDimensions( identifiedLandMatrix_excludedBH_hectares,longitudeVector_centered,latitudeVector_centered, 360, 180 );

%Calculate land fractions
globe_landArea_hectare = ones(4320,2160);
areaPerLat_hat = diag(obj.areaPerLatitudeVector_hectare);
globe_landArea_hectare = globe_landArea_hectare*areaPerLat_hat;
globe_landArea_hectare_oneDegree = aggregateMatrix2givenDimensions( globe_landArea_hectare,longitudeVector_centered,latitudeVector_centered, 360, 180 );
AggregatedResults.identifiedLandMatrix_fractions = AggregatedResults.identifiedLandMatrix_hectare./globe_landArea_hectare_oneDegree;
AggregatedResults.excluded_BH_identifiedLandMatrix_fractions = AggregatedResults.excluded_BH_identifiedLandMatrix_hectare./globe_landArea_hectare_oneDegree;

%Estimate water use and aggregate
waterUseToIrrigate_30arcsec_m3 = (obj.waterDeficit_lhv_mm*10^-3).*(identifiedLandMatrix_hectares*10^4); %m*m2=m3
sum(sum(waterUseToIrrigate_30arcsec_m3))
AggregatedResults.waterUseToIrrigate_lhv_m3 = aggregateMatrix2givenDimensions( waterUseToIrrigate_30arcsec_m3,longitudeVector_centered,latitudeVector_centered, 360, 180 );
sum(sum(AggregatedResults.waterUseToIrrigate_lhv_m3))
%Aggregate energy gains when moving from rainfed to irrigated
AggregatedResults.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear = aggregateMatrix2givenDimensions(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear,longitudeVector_centered,latitudeVector_centered,360,180);

%Preallocation
energyYieldGainPerWaterUse_GJ_perHaMm = zeros(360,180);
waterUse_mm = zeros(360,180);

%Estimate average water use [mm]
binary_identifiedLandLargerThanZero = AggregatedResults.identifiedLandMatrix_hectare > 0;
waterUse_mm(binary_identifiedLandLargerThanZero) = 10^3*(AggregatedResults.waterUseToIrrigate_lhv_m3(binary_identifiedLandLargerThanZero)./(AggregatedResults.identifiedLandMatrix_hectare(binary_identifiedLandLargerThanZero)*10^4));
AggregatedResults.waterUse_cellAverage_mm = waterUse_mm;
                                                                                                                                                                                                                                                                                                                                    
%Estimate energy yield gains
AggregatedResults.energyYieldGain_lhv_ir_rf_GJ_perYearHa = (10^-3*AggregatedResults.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear)./AggregatedResults.identifiedLandMatrix_hectare;

%Estimate energy yield gains per water use
binary_waterUse_mmLargerThanZero = waterUse_mm > 0;
energyYieldGainPerWaterUse_GJ_perHaMm(binary_waterUse_mmLargerThanZero) = AggregatedResults.energyYieldGain_lhv_ir_rf_GJ_perYearHa(binary_waterUse_mmLargerThanZero)./waterUse_mm(binary_waterUse_mmLargerThanZero);
AggregatedResults.energyYieldGainPerIrrigation_GJ_perHaMm = energyYieldGainPerWaterUse_GJ_perHaMm;

%Aggregate primary energy for all rainfed and irrigated conditions


end

