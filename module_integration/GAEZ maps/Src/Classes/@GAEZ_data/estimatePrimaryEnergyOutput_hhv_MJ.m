function [ obj ] = estimatePrimaryEnergyOutput_hhv_MJ( obj )
%ESTIMATEPRIMARYENERGYOUTPUT_HHV_MJ Summary of this function goes here
%   Detailed explanation goes here
obj.primaryEnergyOutput_spatial_hhv_MJ_perYear = obj.cropYield_identifiedLands_tonsPerYear*obj.calorificValue_weightedAllPlant_MJperKgFromGAEZ_hhv*10^3; %10^3 to get MJ/ton
obj.primaryEnergyOutput_total_hhv_MJ_perYear = sum(sum(obj.primaryEnergyOutput_spatial_hhv_MJ_perYear));
obj.primaryEnergyOutput_total_hhv_EJ_perYear = obj.primaryEnergyOutput_total_hhv_MJ_perYear*10^(-12);

obj.primaryEnergyOutput_excludingBH_spatial_hhv_MJ_perYear = obj.cropYield_identifiedLands_excludingBiodHotspots_tonsPerYear*obj.calorificValue_weightedAllPlant_MJperKgFromGAEZ_hhv*10^3;
obj.primaryEnergyOutput_excludingBH_total_hhv_MJ_perYear = sum(sum(obj.primaryEnergyOutput_excludingBH_spatial_hhv_MJ_perYear));
obj.primaryEnergyOutput_excludingBH_total_hhv_EJ_perYear = obj.primaryEnergyOutput_excludingBH_total_hhv_MJ_perYear*10^(-12);

end

