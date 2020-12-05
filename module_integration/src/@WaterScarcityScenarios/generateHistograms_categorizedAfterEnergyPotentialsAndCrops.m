function obj  = generateHistograms_categorizedAfterEnergyPotentialsAndCrops( obj, identifiedLandMatrix_hectares )
%GENERATEHISTOGRAMS_CATEGORIZEDAFTERENERGYPOTENTIALSANDCROPS Summary of this function goes here
%   Detailed explanation goes here

%HistogramStep MJ/ha
histogramStep_GJperHA = 50;

%Finding max values

%Finding MJ/hectare optimized output
optimizedMatrix_GJ_perHectare_lhv = 10^-3*obj.primaryEnergyMatrix_MJ_perYear_lhv./identifiedLandMatrix_hectares;
optimizedMatrix_GJ_perHectare_hhv = 10^-3*obj.primaryEnergyMatrix_MJ_perYear_hhv./identifiedLandMatrix_hectares;

%% RAINFED/IRRIGATED
%prealloc rainfed/irrigated
identifiedLandMatrix_rainfed_hectares = identifiedLandMatrix_hectares;
identifiedLandMatrix_irrigated_hectares = identifiedLandMatrix_hectares;
%optimizedMatrix_GJ_perHectare_rainfed_lhv = optimizedMatrix_GJ_perHectare_lhv;
%optimizedMatrix_GJ_perHectare_rainfed_hhv = optimizedMatrix_GJ_perHectare_hhv;
%optimizedMatrix_GJ_perHectare_irrigated_lhv = optimizedMatrix_GJ_perHectare_lhv;
%optimizedMatrix_GJ_perHectare_irrigated_hhv = optimizedMatrix_GJ_perHectare_hhv;
%Finding irrigated/rainfed values
identifiedLandMatrix_rainfed_hectares(obj.irrigation_binaryMatrix == 1) = 0;
identifiedLandMatrix_irrigated_hectares(obj.irrigation_binaryMatrix == 0) = 0;


%optimizedMatrix_GJ_perHectare_rainfed_hhv(obj.irrigation_binaryMatrix == 1) = 0;
%optimizedMatrix_GJ_perHectare_rainfed_lhv(obj.irrigation_binaryMatrix == 1) = 0;
%optimizedMatrix_GJ_perHectare_irrigated_hhv(obj.irrigation_binaryMatrix == 0) = 0;
%optimizedMatrix_GJ_perHectare_irrigated_lhv(obj.irrigation_binaryMatrix == 0) = 0;


%% MAKE HISTOGRAM
%prealloc
highest_MJ_perHectare_lhv_all = 0;
highest_MJ_perHectare_hhv_all = 0;

%Finding max values for histogram, MJ/hectare
highestValue_lhv_GJ_perYear = max(max(optimizedMatrix_GJ_perHectare_lhv));
highestValue_hhv_GJ_perYear = max(max(optimizedMatrix_GJ_perHectare_hhv));

if highestValue_lhv_GJ_perYear > highest_MJ_perHectare_lhv_all
    highest_MJ_perHectare_lhv_all = highestValue_lhv_GJ_perYear;
end
if highestValue_hhv_GJ_perYear > highest_MJ_perHectare_hhv_all
    highest_MJ_perHectare_hhv_all = highestValue_hhv_GJ_perYear;
end



n_categories_lhv = ceil(highest_MJ_perHectare_lhv_all/histogramStep_GJperHA);
n_categories_hhv = ceil(highest_MJ_perHectare_hhv_all/histogramStep_GJperHA);

%LHV
    %Calculating for zero yield
    zeroYieldMatrix_binary = [optimizedMatrix_GJ_perHectare_lhv == 0];
    zeroYieldMatrix_hectares = identifiedLandMatrix_hectares.*zeroYieldMatrix_binary;
    obj.zeroPrimaryEnergyPotential_lhv_hectares = sum(sum(zeroYieldMatrix_hectares));
%HHV
    %Calculating for zero yield
    zeroYieldMatrix_binary = [optimizedMatrix_GJ_perHectare_hhv == 0];
    zeroYieldMatrix_hectares = identifiedLandMatrix_hectares.*zeroYieldMatrix_binary;
    obj.zeroPrimaryEnergyPotential_hhv_hectares = sum(sum(zeroYieldMatrix_hectares));

    
    %% Calculating the rest, yields > 0
%preallocation
histogramMatrix_lhv = zeros(length(obj.cropID_vector),n_categories_lhv);
histogramMatrix_hhv = zeros(length(obj.cropID_vector),n_categories_hhv);
histogramMatrix_irrigated_lhv = histogramMatrix_lhv;
histogramMatrix_irrigated_hhv = histogramMatrix_hhv;
histogramMatrix_rainfed_lhv = histogramMatrix_lhv;
histogramMatrix_rainfed_hhv = histogramMatrix_hhv;


for i = 1:length(obj.cropID_vector)
    binaryMatrix_identifiedAsGivenID_lhv = ([obj.primaryEnergyMatrix_cropIDs_lhv == obj.cropID_vector(i)]);
    binaryMatrix_identifiedAsGivenID_hhv = ([obj.primaryEnergyMatrix_cropIDs_hhv == obj.cropID_vector(i)]);

    %highestValue_lhv_MJ_perYear = max(max(obj.spatialOptimizationMatrix_MJ_perYear_lhv));
    %highestValue_hhv_MJ_perYear = max(max(obj.spatialOptimizationMatrix_MJ_perYear_hhv));
    
    %Grouping land after energy output to make histogram, LHV
    lowerBand = 0;
    upperBand = histogramStep_GJperHA;
    c=1;
    %highest_MJ_perHectare_lhv_all
    while upperBand < highest_MJ_perHectare_lhv_all
       binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand = [binaryMatrix_identifiedAsGivenID_lhv] & ([optimizedMatrix_GJ_perHectare_lhv] > lowerBand) & ([optimizedMatrix_GJ_perHectare_lhv <= upperBand]);
        histogramMatrix_lhv(i,c) = sum(sum([binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand.*identifiedLandMatrix_hectares]));
        histogramMatrix_irrigated_lhv(i,c) = sum(sum([binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand.*identifiedLandMatrix_irrigated_hectares]));
        histogramMatrix_rainfed_lhv(i,c) = sum(sum([binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand.*identifiedLandMatrix_rainfed_hectares]));
        c=c+1;
        lowerBand = upperBand;
        upperBand = upperBand + histogramStep_GJperHA;
    end
    
    lowerBand = 0;
    upperBand = histogramStep_GJperHA;
    %Grouping land after energy output to make histogram, HHV
    c=1;
    while upperBand < highest_MJ_perHectare_hhv_all
       binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand = [binaryMatrix_identifiedAsGivenID_hhv & (optimizedMatrix_GJ_perHectare_hhv > lowerBand) & (optimizedMatrix_GJ_perHectare_hhv <= upperBand)];
        histogramMatrix_hhv(i,c) = sum(sum([binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand.*identifiedLandMatrix_hectares]));
        histogramMatrix_irrigated_hhv(i,c) = sum(sum([binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand.*identifiedLandMatrix_irrigated_hectares]));
        histogramMatrix_rainfed_hhv(i,c) = sum(sum([binaryMatrix_identifiedAsGivenID_andPrimaryEnergyOutput_inBand.*identifiedLandMatrix_rainfed_hectares]));
        c=c+1;  
        lowerBand = upperBand;
        upperBand = upperBand + histogramStep_GJperHA;
    end
end

obj.primaryEnergyPotentialHistogramMatrix_cropEnergy_lhv = histogramMatrix_lhv;
obj.primaryEnergyPotentialHistogramMatrix_cropEnergy_hhv = histogramMatrix_hhv;
obj.primaryEnergyPotentialHistogram_bandsLimits_lhv = [0:histogramStep_GJperHA:(n_categories_lhv*histogramStep_GJperHA)];
obj.primaryEnergyPotentialHistogram_bandsLimits_hhv = [0:histogramStep_GJperHA:(n_categories_hhv*histogramStep_GJperHA)];

obj.primaryEnergyPotentialHistogramMatrix_rainfed_cropEnergy_lhv = histogramMatrix_rainfed_lhv;
obj.primaryEnergyPotentialHistogramMatrix_irrigated_cropEnergy_lhv = histogramMatrix_irrigated_lhv;
obj.primaryEnergyPotentialHistogramMatrix_rainfed_cropEnergy_hhv = histogramMatrix_rainfed_hhv;
obj.primaryEnergyPotentialHistogramMatrix_irrigated_cropEnergy_hhv = histogramMatrix_irrigated_hhv;

obj.primaryEnergyMatrix_irrigated_MJ_perYear_lhv = obj.primaryEnergyMatrix_MJ_perYear_lhv;
obj.primaryEnergyMatrix_irrigated_MJ_perYear_lhv(obj.irrigation_binaryMatrix == 0) = 0;
obj.primaryEnergyMatrix_rainfed_MJ_perYear_lhv = obj.primaryEnergyMatrix_MJ_perYear_lhv;
obj.primaryEnergyMatrix_rainfed_MJ_perYear_lhv(obj.irrigation_binaryMatrix == 1) = 0;

obj.primaryEnergyMatrix_irrigated_MJ_perYear_hhv = obj.primaryEnergyMatrix_MJ_perYear_hhv;
obj.primaryEnergyMatrix_irrigated_MJ_perYear_hhv(obj.irrigation_binaryMatrix == 0) = 0;
obj.primaryEnergyMatrix_rainfed_MJ_perYear_hhv = obj.primaryEnergyMatrix_MJ_perYear_hhv;
obj.primaryEnergyMatrix_rainfed_MJ_perYear_hhv(obj.irrigation_binaryMatrix == 1) = 0;

obj.primaryEnergy_total_MJ_perYear_rainfed_lhv = sum(sum(obj.primaryEnergyMatrix_rainfed_MJ_perYear_lhv));
obj.primaryEnergy_total_MJ_perYear_irrigated_lhv = sum(sum(obj.primaryEnergyMatrix_irrigated_MJ_perYear_lhv));
obj.primaryEnergy_total_MJ_perYear_rainfed_hhv = sum(sum(obj.primaryEnergyMatrix_rainfed_MJ_perYear_hhv));
obj.primaryEnergy_total_MJ_perYear_irrigated_hhv = sum(sum(obj.primaryEnergyMatrix_irrigated_MJ_perYear_hhv));

obj.primaryEnergy_total_EJ_perYear_rainfed_lhv = obj.primaryEnergy_total_MJ_perYear_rainfed_lhv*10^-12;
obj.primaryEnergy_total_EJ_perYear_irrigated_lhv = obj.primaryEnergy_total_MJ_perYear_irrigated_lhv*10^-12;
obj.primaryEnergy_total_EJ_perYear_rainfed_hhv = obj.primaryEnergy_total_MJ_perYear_rainfed_hhv*10^-12;
obj.primaryEnergy_total_EJ_perYear_irrigated_hhv = obj.primaryEnergy_total_MJ_perYear_irrigated_hhv*10^-12;


end

