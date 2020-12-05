function obj = createStandardizedEnergyYieldHistogramData( obj, energyYieldHistograms_standardBounds_GJperHa)
histogramMatrix_old = obj.spatialOptimization_prEnPotentialHistogramMatrix_cropEnergy_lhv'*10^-6;
histogramMatrix_exclBH_old = obj.excluded_BH_primEnergyPotentialHistogramMatrix_cropEnergy_lhv'*10^-6; 

%
mSize_bounds = size(energyYieldHistograms_standardBounds_GJperHa);
mSize_histogramMatrix_old = size(histogramMatrix_old);
mSize_histogramMatrix_exclBH_old = size(histogramMatrix_exclBH_old);

n_crops = length(obj.CropType_array);

%preallocation
histogramMatrix_all = zeros(mSize_bounds(2),n_crops+1);
histogramMatrix_excluded_biodiversityHotspots = histogramMatrix_all;

%% Make matrix
%Get no yield land areas
histogramMatrix_all(1,end) = obj.spatialOptimization_zeroPrimaryEnergyPotential_lhv_hectares*10^-6;
histogramMatrix_excluded_biodiversityHotspots(1,end) = obj.excluded_BH_zeroPrimaryEnergyPotential_lhv_hectares*10^-6;

cropIDs = {obj.CropType_array.ID};
cropIDs_vec = [obj.CropType_array.ID];

%Get yielded areas
for crop = 1:n_crops
    
   for bounds = 1:mSize_bounds(2) 
       %Get data for given crop and within given bounds
       
       %All land
       if sum([obj.spatialOptimizationMatrix_cropID_vector] == cropIDs{crop}) > 0
           
           for yieldGroup = 1:mSize_histogramMatrix_old(1)
               obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv(yieldGroup)
               obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv(yieldGroup+1)
               
               if obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv(yieldGroup) >= energyYieldHistograms_standardBounds_GJperHa(1,bounds)
                   if obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv(yieldGroup+1) <= energyYieldHistograms_standardBounds_GJperHa(2,bounds)
                       
                       pos_old = find([obj.spatialOptimizationMatrix_cropID_vector] == cropIDs{crop});
                       pos_new = find(cropIDs_vec==obj.spatialOptimizationMatrix_cropID_vector(pos_old));
                       
                  
                       histogramMatrix_all(bounds,pos_new) = histogramMatrix_all(bounds,pos_new)+histogramMatrix_old(yieldGroup,pos_old);
                   end
               end
           end
           
       end
       %Excluding BH
       if sum(obj.excluded_BH_spatialOptimizationMatrix_cropID_vector == cropIDs{crop}) > 0
           for yieldGroup = 1:mSize_histogramMatrix_exclBH_old(1)
               if obj.excluded_BH_primEnergyPotentialHistogram_bandsLimits_lhv(yieldGroup) >= energyYieldHistograms_standardBounds_GJperHa(1,bounds)
                   if obj.excluded_BH_primEnergyPotentialHistogram_bandsLimits_lhv(yieldGroup+1) <= energyYieldHistograms_standardBounds_GJperHa(2,bounds)
                       pos_old = find([obj.spatialOptimizationMatrix_cropID_vector] == cropIDs{crop});
                       pos_new = find(cropIDs_vec==obj.spatialOptimizationMatrix_cropID_vector(pos_old));
                       
                       histogramMatrix_excluded_biodiversityHotspots(bounds,pos_new) = histogramMatrix_excluded_biodiversityHotspots(bounds,pos_new)+histogramMatrix_exclBH_old(yieldGroup,pos_old);
                   else
                       % error('Interval outside bounds, fix input or function.')
                   end
               end
           end
       end
   end
end


obj.EnergyYieldHistogramData_lhv = EnergyYieldHistogram;
obj.EnergyYieldHistogramData_lhv.bounds_GJperHa = energyYieldHistograms_standardBounds_GJperHa;
obj.EnergyYieldHistogramData_lhv.legendNames = {obj.CropType_array.name};
obj.EnergyYieldHistogramData_lhv.histogramMatrix_all_Mha = histogramMatrix_all;
obj.EnergyYieldHistogramData_lhv.histogramMatrix_insideBiodiversityHotspots_Mha = histogramMatrix_all-histogramMatrix_excluded_biodiversityHotspots;
obj.EnergyYieldHistogramData_lhv.histogramMatrix_outsideBiodiversityHotspots_Mha = histogramMatrix_excluded_biodiversityHotspots;

%sum(sum(obj.EnergyYieldHistogramData_lhv.histogramMatrix_all_Mha))

obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv

end

