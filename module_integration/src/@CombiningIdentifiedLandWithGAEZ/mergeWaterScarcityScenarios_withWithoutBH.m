function obj = mergeWaterScarcityScenarios_withWithoutBH( obj )
%Merging data from the two arrays (all/outside biodiversity hotspots (BH)) into main array

%Make identification vectors
for i = 1:length(obj.WaterScarcity_scenarioArray)
   obj.WaterScarcity_scenarioArray(i) = obj.WaterScarcity_scenarioArray(i).generateIdentificationVector; 
end
for i = 1:length(obj.WaterScarcity_noBiodiversityHotspots_scenarioArray)
   obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(i) = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(i).generateIdentificationVector; 
end

%% Merge data
for i = 1:length(obj.WaterScarcity_scenarioArray)
    %Find corresponding outside BH data
    pos=0;
    for j = 1:length(obj.WaterScarcity_noBiodiversityHotspots_scenarioArray)
        if obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).identificationVector == obj.WaterScarcity_scenarioArray(i).identificationVector
           pos = j;
           break
        end
    end
    
    if pos == 0
       fprintf('Could not find data to merge for case: ');
       fprintf(obj.WaterScarcity_scenarioArray(i).scenarioDescription_string);
       fprintf('\n');
       continue
    end
    
    obj.WaterScarcity_scenarioArray(i).exclBH_zeroPrimaryEnergyPotential_lhv_hectares = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).zeroPrimaryEnergyPotential_lhv_hectares;
    obj.WaterScarcity_scenarioArray(i).exclBH_zeroPrimaryEnergyPotential_hhv_hectares = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).zeroPrimaryEnergyPotential_hhv_hectares;
    obj.WaterScarcity_scenarioArray(i).exclBH_cropID_vector = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).cropID_vector;
    obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogram_bandsLimits_lhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyPotentialHistogram_bandsLimits_lhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogram_bandsLimits_hhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyPotentialHistogram_bandsLimits_hhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogramMatrix_cropEnergy_lhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyPotentialHistogramMatrix_cropEnergy_lhv;
    
    obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogramMatrix_cropEnergy_hhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyPotentialHistogramMatrix_cropEnergy_hhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogramMatrix_rainfed_cropEnergy_lhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyPotentialHistogramMatrix_rainfed_cropEnergy_lhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogramMatrix_irrigated_cropEnergy_lhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyPotentialHistogramMatrix_irrigated_cropEnergy_lhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogramMatrix_rainfed_cropEnergy_hhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyPotentialHistogramMatrix_rainfed_cropEnergy_hhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogramMatrix_irrigated_cropEnergy_hhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyPotentialHistogramMatrix_irrigated_cropEnergy_hhv;
    
    
    obj.WaterScarcity_scenarioArray(i).EnergyYieldHistogramData_lhv = EnergyYieldHistogram;
    obj.WaterScarcity_scenarioArray(i).EnergyYieldHistogramData_lhv.bounds_GJperHa = obj.Settings.energyYieldHistograms_standardBounds_GJperHa;
    
    %% Make new histogram matrices
    energyYieldHistograms_standardBounds_GJperHa = obj.Settings.energyYieldHistograms_standardBounds_GJperHa;
    %Convert to million ha
    histogramMatrix_old = obj.WaterScarcity_scenarioArray(i).primaryEnergyPotentialHistogramMatrix_cropEnergy_lhv'*10^-6;
    histogramMatrix_exclBH_old = obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogramMatrix_cropEnergy_lhv'*10^-6;
    %
    mSize_bounds = size(energyYieldHistograms_standardBounds_GJperHa);
    mSize_histogramMatrix_old = size(histogramMatrix_old);
    mSize_histogramMatrix_exclBH_old = size(histogramMatrix_exclBH_old);
    n_crops = length(obj.WaterScarcity_scenarioArray(i).CropType_array);
    
    %preallocation
    histogramMatrix_all = zeros(mSize_bounds(2),n_crops+1);
    histogramMatrix_excluded_biodiversityHotspots = histogramMatrix_all;
    
    %Get no yield land areas
    histogramMatrix_all(1,end) = obj.WaterScarcity_scenarioArray(i).zeroPrimaryEnergyPotential_lhv_hectares*10^-6;
    histogramMatrix_excluded_biodiversityHotspots(1,end) = obj.WaterScarcity_scenarioArray(i).exclBH_zeroPrimaryEnergyPotential_lhv_hectares*10^-6;
    
    cropIDs = {obj.WaterScarcity_scenarioArray(i).CropType_array.ID};
    cropIDs_vec = [obj.WaterScarcity_scenarioArray(i).CropType_array.ID];
    
    %Get yielded areas
    for crop = 1:n_crops
        
        for bounds = 1:mSize_bounds(2)
            %Get data for given crop and within given bounds
            
            %All land
            if sum([obj.WaterScarcity_scenarioArray(i).cropID_vector] == cropIDs{crop}) > 0
                
                for yieldGroup = 1:mSize_histogramMatrix_old(1)-1
                    
                    
                    if obj.WaterScarcity_scenarioArray(i).primaryEnergyPotentialHistogram_bandsLimits_lhv(yieldGroup) >= energyYieldHistograms_standardBounds_GJperHa(1,bounds)
                        if obj.WaterScarcity_scenarioArray(i).primaryEnergyPotentialHistogram_bandsLimits_lhv(yieldGroup+1) <= energyYieldHistograms_standardBounds_GJperHa(2,bounds)
                            
                            pos_old = find([obj.WaterScarcity_scenarioArray(i).cropID_vector] == cropIDs{crop});
                            pos_new = find(cropIDs_vec==obj.WaterScarcity_scenarioArray(i).cropID_vector(pos_old));
                            
                            
                            histogramMatrix_all(bounds,pos_new) = histogramMatrix_all(bounds,pos_new)+histogramMatrix_old(yieldGroup,pos_old);
                        end
                    end
                end
                
            end
            %Excluding BH
            if sum(obj.WaterScarcity_scenarioArray(i).exclBH_cropID_vector == cropIDs{crop}) > 0
                for yieldGroup = 1:mSize_histogramMatrix_exclBH_old(1)-1
                    if obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogram_bandsLimits_lhv(yieldGroup) >= energyYieldHistograms_standardBounds_GJperHa(1,bounds)
                        if obj.WaterScarcity_scenarioArray(i).exclBH_primEnPotentialHistogram_bandsLimits_lhv(yieldGroup+1) <= energyYieldHistograms_standardBounds_GJperHa(2,bounds)
                            pos_old = find([obj.WaterScarcity_scenarioArray(i).cropID_vector] == cropIDs{crop});
                            pos_new = find(cropIDs_vec==obj.WaterScarcity_scenarioArray(i).cropID_vector(pos_old));
                            
                            histogramMatrix_excluded_biodiversityHotspots(bounds,pos_new) = histogramMatrix_excluded_biodiversityHotspots(bounds,pos_new)+histogramMatrix_exclBH_old(yieldGroup,pos_old);
                        else
                            % error('Interval outside bounds, fix input or function.')
                        end
                    end
                end
            end
        end
    end
    
    obj.WaterScarcity_scenarioArray(i).EnergyYieldHistogramData_lhv.legendNames = {obj.WaterScarcity_scenarioArray(i).CropType_array.name};
    obj.WaterScarcity_scenarioArray(i).EnergyYieldHistogramData_lhv.histogramMatrix_all_Mha = histogramMatrix_all;
    obj.WaterScarcity_scenarioArray(i).EnergyYieldHistogramData_lhv.histogramMatrix_insideBiodiversityHotspots_Mha = histogramMatrix_all-histogramMatrix_excluded_biodiversityHotspots;
    obj.WaterScarcity_scenarioArray(i).EnergyYieldHistogramData_lhv.histogramMatrix_outsideBiodiversityHotspots_Mha = histogramMatrix_excluded_biodiversityHotspots;
    
    obj.WaterScarcity_scenarioArray(i).exclBH_primaryEnergyMatrix_MJ_perYear = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyMatrix_MJ_perYear_lhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primaryEnergyMatrix_cropIDs_lhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergyMatrix_cropIDs_lhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primaryEnergy_total_EJ_perYear_rainfed_lhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergy_total_EJ_perYear_rainfed_lhv;
    obj.WaterScarcity_scenarioArray(i).exclBH_primaryEnergy_total_EJ_perYear_irrigated_lhv = obj.WaterScarcity_noBiodiversityHotspots_scenarioArray(j).primaryEnergy_total_EJ_perYear_irrigated_lhv;
    
    %% FIND PRIMARY ENERGY PER CROP
    for crop = 1:length(obj.WaterScarcity_scenarioArray(i).cropID_vector)
        binaryIdentified = obj.WaterScarcity_scenarioArray(i).primaryEnergyMatrix_cropIDs_lhv == obj.WaterScarcity_scenarioArray(i).cropID_vector(crop);
        obj.WaterScarcity_scenarioArray(i).primaryEnergy_perCrop_EJ(crop) = sum(sum(obj.WaterScarcity_scenarioArray(i).primaryEnergyMatrix_MJ_perYear_lhv(binaryIdentified)))*10^-12;
        binaryIdentified_BH = obj.WaterScarcity_scenarioArray(i).exclBH_primaryEnergyMatrix_cropIDs_lhv == obj.WaterScarcity_scenarioArray(i).cropID_vector(crop);
        obj.WaterScarcity_scenarioArray(i).exclBH_primaryEnergy_perCrop_EJ(crop) = sum(sum(obj.WaterScarcity_scenarioArray(i).exclBH_primaryEnergyMatrix_MJ_perYear(binaryIdentified_BH)))*10^-12;
    end
    
    
end %for WS scenarios




end

