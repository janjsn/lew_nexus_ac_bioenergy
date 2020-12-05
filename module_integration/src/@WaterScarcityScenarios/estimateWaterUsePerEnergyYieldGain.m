function obj = estimateWaterUsePerEnergyYieldGain( obj, identifiedLand_hectare, identifiedLand_outsideBiodiversityHotspots)


biodiversityHotspots_fractions = 1-(identifiedLand_outsideBiodiversityHotspots./identifiedLand_hectare);
biodiversityHotspots_fractions(isnan(biodiversityHotspots_fractions)) = 0;

mSize = size(obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare);
%Preallocation
obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ = ones(mSize(1), mSize(2));
%Estimate mm ha GJ-1
obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ = obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ./(obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare*(10^-3));
%Set to zero if infinite
obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ(obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare == 0) = 0;

%Set bounds
obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds = [0 0 2 4 6 8 
                                                               0 2 4 6 8 inf]; 
mSize = size(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds);

binary_lowWaterScarcity = obj.WaterScarcityLevel.dataMatrix_global <=1;
binary_moderateWaterScarcity = obj.WaterScarcityLevel.dataMatrix_global == 2;
binary_highWaterScarcity = obj.WaterScarcityLevel.dataMatrix_global > 2;

obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_ws_ha = zeros(3,mSize(2));

%Estimate histogram data
for n_parts = 1:mSize(2)
    if n_parts == 1
        obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_hectare(n_parts) = sum(sum(identifiedLand_hectare.*(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ <= 0)));
        %Low ws
        obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_ws_ha(1,n_parts) = sum(sum(identifiedLand_hectare.*(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ <= 0).*binary_lowWaterScarcity));
        %Moderate ws
        obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_ws_ha(2,n_parts) = sum(sum(identifiedLand_hectare.*(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ <= 0).*binary_moderateWaterScarcity));
        %High ws
        obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_ws_ha(3,n_parts) = sum(sum(identifiedLand_hectare.*(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ <= 0).*binary_highWaterScarcity));
    else
        binary_identified = (obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds(1,n_parts) < obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ) & (obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ <= obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds(2,n_parts));
        obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_hectare(n_parts) = sum(sum(identifiedLand_hectare.*binary_identified));
        %Low ws
        obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_ws_ha(1,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_lowWaterScarcity));
        %Moderate ws
        obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_ws_ha(2,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_moderateWaterScarcity));
        %High ws
        obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_ws_ha(3,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_highWaterScarcity));
    end
end

%% Marginal energy gain
%Set bounds
obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds = [0 0 0.2 0.4 0.6 0.8
                                                          0 0.2 0.4 0.6 0.8 inf];
%Get size   
mSize = size(obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds);

%Preallocate
obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_inHectare(mSize(2)) = 0;
obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare = zeros(3,mSize(2));

%Estimate histogram data
for n_parts = 1:mSize(2)
    if n_parts == 1
        obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_inHectare(n_parts) = sum(sum(identifiedLand_hectare.*(10^-3*obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare <= 0)));
        obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare(1,n_parts) = sum(sum(identifiedLand_hectare.*(10^-3*obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare <= 0).*binary_lowWaterScarcity));
        obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare(2,n_parts) = sum(sum(identifiedLand_hectare.*(10^-3*obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare <= 0).*binary_moderateWaterScarcity));
        obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare(3,n_parts) = sum(sum(identifiedLand_hectare.*(10^-3*obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare <= 0).*binary_highWaterScarcity));
    else
        binary_identified = (obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds(1,n_parts) < 10^-3*obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare) & (obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds(2,n_parts) >= 10^-3*obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare);
        obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_inHectare(n_parts) = sum(sum(identifiedLand_hectare.*binary_identified));
        obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare(1,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_lowWaterScarcity));
        obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare(2,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_moderateWaterScarcity));
        obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare(3,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_highWaterScarcity));
    end
end

%Add biodiversity hotspot fractions to object
obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot = biodiversityHotspots_fractions;

%% Mean marginal energy gains
%Remove converging values and missing data
marginalEnergyGain_cleaned = obj.primaryEnergyGainPerIrrigation_lhv_MJ_per_mm_per_hectare*10^-3;
marginalEnergyGain_cleaned(marginalEnergyGain_cleaned > 10) = 0; %Remove top 1%
marginalEnergyGain_cleaned(marginalEnergyGain_cleaned < 0) = 0;
marginalEnergyGain_cleaned(isnan(marginalEnergyGain_cleaned)) = 0;

%Calculate means
obj.marginalEnergyGain_mean_global_GJ_per_mm_ha = sum(sum(marginalEnergyGain_cleaned.*identifiedLand_hectare))/sum(sum(identifiedLand_hectare));
obj.marginalEnergyGain_mean_lowWaterScarcity_GJ_per_mm_ha = sum(sum(marginalEnergyGain_cleaned.*identifiedLand_hectare.*binary_lowWaterScarcity))/sum(sum(identifiedLand_hectare.*binary_lowWaterScarcity));
obj.marginalEnergyGain_mean_moderateWaterScarcity_GJ_per_mm_ha = sum(sum(marginalEnergyGain_cleaned.*identifiedLand_hectare.*binary_moderateWaterScarcity))/sum(sum(identifiedLand_hectare.*binary_moderateWaterScarcity));
obj.marginalEnergyGain_mean_highWaterScarcity_GJ_per_mm_ha = sum(sum(marginalEnergyGain_cleaned.*identifiedLand_hectare.*binary_highWaterScarcity))/sum(sum(identifiedLand_hectare.*binary_highWaterScarcity));
obj.marginalEnergyGain_mean_biodiversityHotspots_GJ_per_mm_ha = sum(sum(marginalEnergyGain_cleaned.*identifiedLand_hectare.*biodiversityHotspots_fractions))/sum(sum(identifiedLand_hectare.*biodiversityHotspots_fractions));

%% water use m3
obj.waterUseToIrrigate_lhv_m3 = (obj.waterDeficit_lhv_mm.*0.001).*(identifiedLand_hectare.*10000);


%% water use m3 per GJ, water footprint
obj.waterUsePerEnergyGain_lhv_m3_perGJ = obj.waterUseToIrrigate_lhv_m3./(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*10^-3);
obj.waterUsePerEnergyGain_lhv_m3_perGJ(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear == 0) = 0;
%Set bounds
obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds = [0 0 20 40 60 80
                                                          0 20 40 60 80 inf];
obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_bounds = obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds;                                         
                                                      
%Get size   
mSize = size(obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds);

%Preallocate
obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_hectare(mSize(2)) = 0;
obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha = zeros(3,mSize(2));
obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_hectare(mSize(2)) = 0;
obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha = zeros(3,mSize(2));

%Estimate histogram data
for n_parts = 1:mSize(2)
    if n_parts == 1
        %All
        obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_hectare(n_parts) = sum(sum(identifiedLand_hectare.*(obj.waterUsePerEnergyGain_lhv_m3_perGJ <= 0)));
        obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha(1,n_parts) = sum(sum(identifiedLand_hectare.*(obj.waterUsePerEnergyGain_lhv_m3_perGJ <= 0).*binary_lowWaterScarcity));
        obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha(2,n_parts) = sum(sum(identifiedLand_hectare.*(obj.waterUsePerEnergyGain_lhv_m3_perGJ <= 0).*binary_moderateWaterScarcity));
        obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha(3,n_parts) = sum(sum(identifiedLand_hectare.*(obj.waterUsePerEnergyGain_lhv_m3_perGJ <= 0).*binary_highWaterScarcity));
        %BH
        obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_hectare(n_parts) = sum(sum(identifiedLand_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot.*(obj.waterUsePerEnergyGain_lhv_m3_perGJ <= 0)));
        obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha(1,n_parts) = sum(sum(identifiedLand_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot.*(obj.waterUsePerEnergyGain_lhv_m3_perGJ <= 0).*binary_lowWaterScarcity));
        obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha(2,n_parts) = sum(sum(identifiedLand_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot.*(obj.waterUsePerEnergyGain_lhv_m3_perGJ <= 0).*binary_moderateWaterScarcity));
        obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha(3,n_parts) = sum(sum(identifiedLand_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot.*(obj.waterUsePerEnergyGain_lhv_m3_perGJ <= 0).*binary_highWaterScarcity));
        
        
    else
        binary_identified = (obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds(1,n_parts) < obj.waterUsePerEnergyGain_lhv_m3_perGJ) & (obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds(2,n_parts) >= obj.waterUsePerEnergyGain_lhv_m3_perGJ);
        obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_hectare(n_parts) = sum(sum(identifiedLand_hectare.*binary_identified));
        obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha(1,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_lowWaterScarcity));
        obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha(2,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_moderateWaterScarcity));
        obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha(3,n_parts) = sum(sum(identifiedLand_hectare.*binary_identified.*binary_highWaterScarcity));
        
        obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_hectare(n_parts) = sum(sum(identifiedLand_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot.*binary_identified));
        obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha(1,n_parts) = sum(sum(identifiedLand_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot.*binary_identified.*binary_lowWaterScarcity));
        obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha(2,n_parts) = sum(sum(identifiedLand_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot.*binary_identified.*binary_moderateWaterScarcity));
        obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha(3,n_parts) = sum(sum(identifiedLand_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot.*binary_identified.*binary_highWaterScarcity));
        
    end
end

%Totals m3
obj.waterUse_lowWaterScarcity_total_m3 = sum(sum(obj.waterUseToIrrigate_lhv_m3.*binary_lowWaterScarcity));
obj.waterUse_moderateWaterScarcity_total_m3 = sum(sum(obj.waterUseToIrrigate_lhv_m3.*binary_moderateWaterScarcity));
obj.waterUse_highWaterScarcity_total_m3 = sum(sum(obj.waterUseToIrrigate_lhv_m3.*binary_highWaterScarcity));


obj.waterUse_inBiodiversityHotspots_lowWaterScarcity_total_m3 = sum(sum(obj.waterUseToIrrigate_lhv_m3.*binary_lowWaterScarcity.*biodiversityHotspots_fractions));
obj.waterUse_inBiodiversityHotspots_moderateWaterScarcity_total_m3 = sum(sum(obj.waterUseToIrrigate_lhv_m3.*binary_moderateWaterScarcity.*biodiversityHotspots_fractions));
obj.waterUse_inBiodiversityHotspots_highWaterScarcity_total_m3 = sum(sum(obj.waterUseToIrrigate_lhv_m3.*binary_highWaterScarcity.*biodiversityHotspots_fractions));

%% MEAN WATER FOOTPRINTS
obj.meanWaterFootprint_global_m3_perGJ = obj.waterUseToIrrigate_lhv_total_m3/(sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3)));
obj.meanWaterFootprint_lowWaterScarcity_m3_perGJ = obj.waterUse_lowWaterScarcity_total_m3/(sum(sum((obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3).*binary_lowWaterScarcity)));
obj.meanWaterFootprint_moderateWaterScarcity_m3_perGJ = obj.waterUse_moderateWaterScarcity_total_m3/(sum(sum((obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3).*binary_moderateWaterScarcity)));
obj.meanWaterFootprint_highWaterScarcity_m3_perGJ = obj.waterUse_highWaterScarcity_total_m3/(sum(sum((obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3).*binary_highWaterScarcity)));
obj.meanWaterFootprint_biodiversityHotspots = sum(sum(obj.waterUseToIrrigate_lhv_m3.*biodiversityHotspots_fractions))/(sum(sum((obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3).*biodiversityHotspots_fractions)));



%% Energy gain for different water scarcity levels
obj.energyGain_total_EJ = sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear))*10^-12;
obj.energyGain_lowWaterScarcity_total_EJ = sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_lowWaterScarcity))*10^-12;
obj.energyGain_moderateWaterScarcity_total_EJ = sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_moderateWaterScarcity))*10^-12;
obj.energyGain_highWaterScarcity_total_EJ = sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_highWaterScarcity))*10^-12;

obj.energyGain_inBiodiversityHotspots_tot_EJ = sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*biodiversityHotspots_fractions))*10^-12;
obj.energyGain_inBiodiversityHotspots_lowWaterScarcity_tot_EJ = sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_lowWaterScarcity.*biodiversityHotspots_fractions))*10^-12;
obj.energyGain_inBiodiversityHotspots_moderateWaterScarcity_tot_EJ = sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_moderateWaterScarcity.*biodiversityHotspots_fractions))*10^-12;
obj.energyGain_inBiodiversityHotspots_highWaterScarcity_tot_EJ = sum(sum(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_highWaterScarcity.*biodiversityHotspots_fractions))*10^-12;

obj.energyGain_noBiodiversityHotspots_tot_EJ = obj.energyGain_total_EJ-obj.energyGain_inBiodiversityHotspots_tot_EJ;
obj.energyGain_noBiodiversityHotspots_lowWaterScarcity_tot_EJ = obj.energyGain_lowWaterScarcity_total_EJ-obj.energyGain_inBiodiversityHotspots_lowWaterScarcity_tot_EJ;
obj.energyGain_noBiodiversityHotspots_moderateWaterScarcity_tot_EJ = obj.energyGain_moderateWaterScarcity_total_EJ-obj.energyGain_inBiodiversityHotspots_moderateWaterScarcity_tot_EJ;
obj.energyGain_noBiodiversityHotspots_highWaterScarcity_tot_EJ = obj.energyGain_highWaterScarcity_total_EJ-obj.energyGain_inBiodiversityHotspots_highWaterScarcity_tot_EJ;

%% Mean water footprints outside BH
obj.meanWaterFootprint_noBiodiversityHotspots_m3_perGJ = 10^-9*(obj.waterUseToIrrigate_lhv_total_m3-(obj.waterUse_inBiodiversityHotspots_lowWaterScarcity_total_m3+obj.waterUse_inBiodiversityHotspots_moderateWaterScarcity_total_m3+obj.waterUse_inBiodiversityHotspots_highWaterScarcity_total_m3))/obj.energyGain_noBiodiversityHotspots_tot_EJ;
obj.meanWaterFootprint_noBiodiversityHotspots_lowWS_m3_perGJ = 10^-9*(obj.waterUse_lowWaterScarcity_total_m3-obj.waterUse_inBiodiversityHotspots_lowWaterScarcity_total_m3)/obj.energyGain_noBiodiversityHotspots_lowWaterScarcity_tot_EJ;
obj.meanWaterFootprint_noBiodiversityHotspots_moderateWS_m3_perGJ = 10^-9*(obj.waterUse_moderateWaterScarcity_total_m3-obj.waterUse_inBiodiversityHotspots_moderateWaterScarcity_total_m3)/obj.energyGain_noBiodiversityHotspots_moderateWaterScarcity_tot_EJ;
obj.meanWaterFootprint_noBiodiversityHotspots_highWS_m3_perGJ = 10^-9*(obj.waterUse_highWaterScarcity_total_m3-obj.waterUse_inBiodiversityHotspots_highWaterScarcity_total_m3)/obj.energyGain_noBiodiversityHotspots_highWaterScarcity_tot_EJ;

obj.meanWaterFootprint_noBiodiversityHotspots_modAndhighWS_m3_perGJ = 10^-9*(obj.waterUse_moderateWaterScarcity_total_m3+obj.waterUse_highWaterScarcity_total_m3-obj.waterUse_inBiodiversityHotspots_moderateWaterScarcity_total_m3-obj.waterUse_inBiodiversityHotspots_highWaterScarcity_total_m3)/(obj.energyGain_noBiodiversityHotspots_moderateWaterScarcity_tot_EJ+obj.energyGain_noBiodiversityHotspots_highWaterScarcity_tot_EJ);

% obj.scenarioDescription_string
% obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_hectare
% %sum(sum(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_hectare))
% 
% primaryEnergyGain_GJ = obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3;
% waterDeficit = obj.waterDeficit_lhv_mm;
% 
% comparisonMatrix = waterDeficit.*identifiedLand_hectare;
% comparisonMatrix(primaryEnergyGain_GJ > 0) = comparisonMatrix(primaryEnergyGain_GJ > 0)./primaryEnergyGain_GJ(primaryEnergyGain_GJ > 0);
% comparisonMatrix(primaryEnergyGain_GJ <= 0) = 0;
% 
% hectaresAtGivenInterval = zeros(1,mSize(2));
% bnds = obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds;
% 
% 
% for n = 1:mSize(2)
%    if n == 1
%        hectaresAtGivenInterval(n) = sum(sum((comparisonMatrix == 0).*identifiedLand_hectare));
%    else
%        hectaresAtGivenInterval(n) = sum(sum((comparisonMatrix > bnds(1,n) & comparisonMatrix <= bnds(2,n)).*identifiedLand_hectare));
%    end
% end
% 
% hectaresAtGivenInterval
% sum(sum(hectaresAtGivenInterval))

%size(comparisonMatrix)
%size(identifiedLand_hectare)

%sum(sum((comparisonMatrix == 0).*identifiedLand_hectare))

end

