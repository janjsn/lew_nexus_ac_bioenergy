function [ AggregatedResults] = aggregate2oneDegree( obj,longitudeVector_centered,latitudeVector_centered )
%AGGREGATE2ONEDEGREE Summary of this function goes here
%   Detailed explanation goes here

AggregatedResults = AggregatedResults_optimizedScenarios;
%Running aggregation algorithm and saving
[AggregatedResults.spatialOptimizationMatrix_MJ_perYear_lhv, AggregatedResults.latitudeVector_centered, AggregatedResults.longitudeVector_centered, AggregatedResults.latitudeBounds, AggregatedResults.longitudeBounds]  = aggregateMatrix2givenDimensions( obj.spatialOptimizationMatrix_MJ_perYear_lhv,longitudeVector_centered,latitudeVector_centered, 360, 180 );
AggregatedResults.spatialOptimizationMatrix_PJ_perYear_lhv = AggregatedResults.spatialOptimizationMatrix_MJ_perYear_lhv*10^-9;

%No biodiversity hotspots, same procedure
[AggregatedResults.excluded_BH_spatialOptimizationMatrix_MJ_perYear_lhv,~,~,~,~] = aggregateMatrix2givenDimensions( obj.excluded_BH_spatialOptimizationMatrix_MJ_perYear_lhv,longitudeVector_centered,latitudeVector_centered, 360, 180 );
AggregatedResults.excluded_BH_spatialOptimizationMatrix_PJ_perYear_lhv = 10^-9*AggregatedResults.excluded_BH_spatialOptimizationMatrix_MJ_perYear_lhv;

%Identified land
AggregatedResults.identifiedLandMatrix_hectare =  aggregateMatrix2givenDimensions( obj.identifiedLandMatrix_hectare,longitudeVector_centered,latitudeVector_centered, 360, 180 );
%Land fractions, calculate and upscale
mSize = size(obj.identifiedLandMatrix_hectare);
temp = ones(mSize(1), mSize(2)); %
aLat_hat = diag(obj.areaPerLatitudeVector_hectare); %Area per latitude diagonal matrix
area_global = temp*aLat_hat; %GAEZ dimensions, global areas per cell, hectare
area_global_oneDegree = aggregateMatrix2givenDimensions( area_global,longitudeVector_centered,latitudeVector_centered, 360, 180 );
AggregatedResults.identifiedLandMatrix_fractions = AggregatedResults.identifiedLandMatrix_hectare./area_global_oneDegree; %Fractions of grid cell, one degree

%Energy yields
AggregatedResults.spatialOptimizationMatrix_bioenergyYields_GJ_perHaYear_lhv = (AggregatedResults.spatialOptimizationMatrix_MJ_perYear_lhv*10^-3)./AggregatedResults.identifiedLandMatrix_hectare;
AggregatedResults.spatialOptimizationMatrix_bioenergyYields_GJ_perHaYear_lhv(isnan(AggregatedResults.spatialOptimizationMatrix_bioenergyYields_GJ_perHaYear_lhv)) = -999;

end

