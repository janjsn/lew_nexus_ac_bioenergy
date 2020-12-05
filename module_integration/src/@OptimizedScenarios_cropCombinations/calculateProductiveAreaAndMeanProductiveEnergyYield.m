function [ productive_area_hectare, mean_productive_bioenergy_yield, mean_bioenergy_yield] = calculateProductiveAreaAndMeanProductiveEnergyYield( obj )
%CALCULATEPRODUCTIVEAREAANDMEANPRODUCTIVEENERGYYIELD Summary of this function goes here
%   Detailed explanation goes here

productive_area_hectare = 10^-6*sum(sum(obj.identifiedLandMatrix_hectare(obj.spatialOptimizationMatrix_MJ_perYear_lhv > 0)));
mean_productive_bioenergy_yield = 10^-9*sum(sum(obj.spatialOptimizationMatrix_MJ_perYear_lhv))/productive_area_hectare; 
mean_bioenergy_yield = 10^-3*sum(sum(obj.spatialOptimizationMatrix_MJ_perYear_lhv))/sum(sum(obj.identifiedLandMatrix_hectare));

sum(sum(obj.identifiedLandMatrix_hectare))

end

