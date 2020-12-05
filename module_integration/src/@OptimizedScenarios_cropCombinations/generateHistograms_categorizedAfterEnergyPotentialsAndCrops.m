function [ obj ] = generateHistograms_categorizedAfterEnergyPotentialsAndCrops( obj, identifiedLandMatrix_hectares )
%GENERATEHISTOGRAMS_CATEGORIZEDAFTERENERGYPOTENTIALSANDCROPS Summary of this function goes here
%   Detailed explanation goes here

%HistogramStep MJ/ha
histogramStep_GJperHA = 50;

%Finding max values

%Finding MJ/hectare optimized output
optimizedMatrix_GJ_perHectare_lhv = 10^-3*obj.spatialOptimizationMatrix_MJ_perYear_lhv./identifiedLandMatrix_hectares;
optimizedMatrix_GJ_perHectare_hhv = 10^-3*obj.spatialOptimizationMatrix_MJ_perYear_hhv./identifiedLandMatrix_hectares;

%prealloc
highest_GJ_perHectare_lhv_all = 0;
highest_GJ_perHectare_hhv_all = 0;

%Finding max values for histogram, MJ/hectare
highestValue_lhv_GJ_perHa = max(max(optimizedMatrix_GJ_perHectare_lhv));
highestValue_hhv_GJ_perHa = max(max(optimizedMatrix_GJ_perHectare_hhv));

if highestValue_lhv_GJ_perHa > highest_GJ_perHectare_lhv_all
    highest_GJ_perHectare_lhv_all = highestValue_lhv_GJ_perHa;
end
if highestValue_hhv_GJ_perHa > highest_GJ_perHectare_hhv_all
    highest_GJ_perHectare_hhv_all = highestValue_hhv_GJ_perHa;
end



n_categories_lhv = ceil(highest_GJ_perHectare_lhv_all/histogramStep_GJperHA);
n_categories_hhv = ceil(highest_GJ_perHectare_hhv_all/histogramStep_GJperHA);

%LHV
    %Calculating for zero yield
    zeroYieldMatrix_binary = [optimizedMatrix_GJ_perHectare_lhv == 0];
    zeroYieldMatrix_hectares = identifiedLandMatrix_hectares.*zeroYieldMatrix_binary;
    obj.spatialOptimization_zeroPrimaryEnergyPotential_lhv_hectares = sum(sum(zeroYieldMatrix_hectares));
    
%HHV
    %Calculating for zero yield
    zeroYieldMatrix_binary = [optimizedMatrix_GJ_perHectare_hhv == 0];
    zeroYieldMatrix_hectares = identifiedLandMatrix_hectares.*zeroYieldMatrix_binary;
    obj.spatialOptimization_zeroPrimaryEnergyPotential_hhv_hectares = sum(sum(zeroYieldMatrix_hectares));

    
    %% Calculating the rest, yields > 0
%preallocation
histogramMatrix_lhv = zeros(length(obj.spatialOptimizationMatrix_cropID_vector),n_categories_lhv);
histogramMatrix_hhv = zeros(length(obj.spatialOptimizationMatrix_cropID_vector),n_categories_hhv);


for i = 1:length(obj.spatialOptimizationMatrix_cropID_vector)
    binaryMatrix_identifiedAsGivenID_lhv = ([obj.spatialOptimizationMatrix_cropIDs_lhv == obj.spatialOptimizationMatrix_cropID_vector(i)]);
    binaryMatrix_identifiedAsGivenID_hhv = ([obj.spatialOptimizationMatrix_cropIDs_hhv == obj.spatialOptimizationMatrix_cropID_vector(i)]);

    %highestValue_lhv_MJ_perYear = max(max(obj.spatialOptimizationMatrix_MJ_perYear_lhv));
    %highestValue_hhv_MJ_perYear = max(max(obj.spatialOptimizationMatrix_MJ_perYear_hhv));
    
    %Grouping land after energy output to make histogram, LHV
    lowerBand = 0;
    upperBand = histogramStep_GJperHA;
    c=1;
    %highest_MJ_perHectare_lhv_all
    while lowerBand < highest_GJ_perHectare_lhv_all
       binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand = binaryMatrix_identifiedAsGivenID_lhv & (optimizedMatrix_GJ_perHectare_lhv > lowerBand) & (optimizedMatrix_GJ_perHectare_lhv <= upperBand);
        histogramMatrix_lhv(i,c) = sum(sum(binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand.*identifiedLandMatrix_hectares));
       
        c=c+1;
        lowerBand = upperBand;
        upperBand = upperBand + histogramStep_GJperHA;
    end
    
    lowerBand = 0;
    upperBand = histogramStep_GJperHA;
    %Grouping land after energy output to make histogram, HHV
    c=1;
    while lowerBand < highest_GJ_perHectare_hhv_all
       binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand = [binaryMatrix_identifiedAsGivenID_hhv & (optimizedMatrix_GJ_perHectare_hhv > lowerBand) & (optimizedMatrix_GJ_perHectare_hhv <= upperBand)];
        histogramMatrix_hhv(i,c) = sum(sum([binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand.*identifiedLandMatrix_hectares]));
        c=c+1;  
        lowerBand = upperBand;
        upperBand = upperBand + histogramStep_GJperHA;
    end
end

obj.spatialOptimization_prEnPotentialHistogramMatrix_cropEnergy_lhv = histogramMatrix_lhv;
obj.spatialOptimization_prEnPotentialHistogramMatrix_cropEnergy_hhv = histogramMatrix_hhv;
obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv = [0:histogramStep_GJperHA:(n_categories_lhv*histogramStep_GJperHA)];
obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_hhv = [0:histogramStep_GJperHA:(n_categories_hhv*histogramStep_GJperHA)];



end

