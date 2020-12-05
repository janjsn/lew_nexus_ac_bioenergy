function [ obj ] = estimatePrimaryEnergyPerCrop( obj )
%ESTIMATEPRIMARYENERGYPERCROP Summary of this function goes here
%   Detailed explanation goes here

energy_lhv_MJ_perYear_perCropVector = zeros(1,length(obj.spatialOptimizationMatrix_cropID_vector));
energy_hhv_MJ_perYear_perCropVector = zeros(1,length(obj.spatialOptimizationMatrix_cropID_vector));

for i = 1:length(obj.spatialOptimizationMatrix_cropID_vector)
   binaryMatrix_givenCropID_lhv = [obj.spatialOptimizationMatrix_cropIDs_lhv] == obj.spatialOptimizationMatrix_cropID_vector(i);
   binaryMatrix_givenCropID_hhv = [obj.spatialOptimizationMatrix_cropIDs_hhv] == obj.spatialOptimizationMatrix_cropID_vector(i);
   
  energy_lhv_MJ_perYear_perCropVector(i) = sum(sum(binaryMatrix_givenCropID_lhv.*obj.spatialOptimizationMatrix_MJ_perYear_lhv));
  energy_hhv_MJ_perYear_perCropVector(i) = sum(sum(binaryMatrix_givenCropID_hhv.*obj.spatialOptimizationMatrix_MJ_perYear_hhv)); 

end

obj.spatialOptimization_primaryEnergy_vector_MJ_perCropPerYear_lhv = energy_lhv_MJ_perYear_perCropVector;
obj.spatialOptimization_primaryEnergy_vector_MJ_perCropPerYear_hhv = energy_hhv_MJ_perYear_perCropVector;
obj.spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_lhv = energy_lhv_MJ_perYear_perCropVector*10^-12;
obj.spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_hhv = energy_hhv_MJ_perYear_perCropVector*10^-12;

end

