function [ obj ] = getWeightedCalorificValues_fromCropTypeArray( obj, CropTypeArray )
%GETWEIGHTEDCALORIFICVALUES_FROMCROPTYPEARRAY Summary of this function goes here
%   Detailed explanation goes here
cropID = obj.cropID;
ID_array = [CropTypeArray.ID];

posInCropTypeArray = [ID_array == cropID];

obj.calorificValue_weightedAllPlant_MJperKgFromGAEZ_lhv = CropTypeArray(posInCropTypeArray).calorificValue_weighted_MJperKgYieldModelOutput_lhv;
obj.calorificValue_weightedAllPlant_MJperKgFromGAEZ_hhv = CropTypeArray(posInCropTypeArray).calorificValue_weighted_MJperKgYieldModelOutput_hhv;

end

