function obj = estimateHectaresPerCrop(obj,identifiedLandMatrix_hectares)
%ESTIMATEHECTARESPERCROP Summary of this function goes here
%   Detailed explanation goes here
obj.landAllocatedToEachCropType_lhv_vector_hectare = zeros(1,length(obj.spatialOptimizationMatrix_cropID_vector));
obj.landAllocatedToEachCropType_hhv_vector_hectare = zeros(1,length(obj.spatialOptimizationMatrix_cropID_vector));
for i = 1:length(obj.spatialOptimizationMatrix_cropID_vector)
    binaryMatrix_identifiedAsGivenID_lhv = ([obj.spatialOptimizationMatrix_cropIDs_lhv == obj.spatialOptimizationMatrix_cropID_vector(i)]);
    binaryMatrix_identifiedAsGivenID_hhv = ([obj.spatialOptimizationMatrix_cropIDs_hhv == obj.spatialOptimizationMatrix_cropID_vector(i)]);
    
    obj.landAllocatedToEachCropType_lhv_vector_hectare(i) = sum(sum(identifiedLandMatrix_hectares(binaryMatrix_identifiedAsGivenID_lhv)));
    obj.landAllocatedToEachCropType_hhv_vector_hectare(i) = sum(sum(identifiedLandMatrix_hectares(binaryMatrix_identifiedAsGivenID_hhv)));
    
end

end

