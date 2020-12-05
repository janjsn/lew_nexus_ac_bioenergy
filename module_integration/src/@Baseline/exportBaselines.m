function exportBaselines( obj)
%EXPORTBASELINES Summary of this function goes here
%   Detailed explanation goes here
outputFolder = 'Output/Baselines/';
 if exist([outputFolder ],'dir') ~= 7
                mkdir([outputFolder]);
 end
timestamp = getTimestampString();

for i = 1:length(obj.GAEZ_variants)
    filename = ([outputFolder  obj.GAEZ_variants(i).cropname '_' timestamp '.nc']);
    
    obj.GAEZ_variants(i).primaryEnergyOutput_spatial_lhv_TJ_perYear=(10^-6)*obj.GAEZ_variants(i).primaryEnergyOutput_spatial_lhv_MJ_perYear;
    obj.GAEZ_variants(i).primaryEnergyOutput_spatial_hhv_TJ_perYear=(10^-6)*obj.GAEZ_variants(i).primaryEnergyOutput_spatial_hhv_MJ_perYear;
    obj.GAEZ_variants(i).primaryEnergyOutput_excludingBH_spatial_lhv_TJ_perYear=(10^-6)*obj.GAEZ_variants(i).primaryEnergyOutput_excludingBH_spatial_lhv_MJ_perYear;
    obj.GAEZ_variants(i).primaryEnergyOutput_excludingBH_spatial_hhv_TJ_perYear=(10^-6)*obj.GAEZ_variants(i).primaryEnergyOutput_excludingBH_spatial_hhv_MJ_perYear;
    
    
  obj.GAEZ_variants(i).makeNcFile_cropYields_tonsPerYear_andMore(filename, outputFolder)
end

for i = 1:length(obj.OptimizedCropMix_forPrimaryEnergy_variant)
    obj.OptimizedCropMix_forPrimaryEnergy_variant(i).exportToNetCDF(outputFolder, obj.latitudeVector_centered, obj.longitudeVector_centered, obj.fractionMatrix )
end

for i = 1:length(obj.WaterSupplyMix_variant)
   obj.WaterSupplyMix_variant.export2netcdf( outputFolder, obj.latitudeVector_centered, obj.longitudeVector_centered, obj.fractionMatrix  ) 
    
end


end

