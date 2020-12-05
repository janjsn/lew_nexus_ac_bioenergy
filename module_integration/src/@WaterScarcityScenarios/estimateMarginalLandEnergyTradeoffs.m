function obj = estimateMarginalLandEnergyTradeoffs( obj, identifiedLandMatrix_hectare )
%ESTIMATEMARGINALLANDENERGYTRADEOFFS Summary of this function goes here
%   Detailed explanation goes here

identifiedLandMatrix_inBiodiversityHotspots_hectare = 10^-6*identifiedLandMatrix_hectare.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot;
identifiedLandMatrix_outsideBiodiversityHotspots_hectare = 10^-6*identifiedLandMatrix_hectare.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot);

energyProduction_rainfed_EJ = obj.primaryEnergyProductionMatrix_rainfed*10^-12;
energyProduction_irrigated_EJ = obj.primaryEnergyProductionMatrix_irrigated*10^-12;
energyProduction_mixed_EJ = obj.primaryEnergyMatrix_MJ_perYear_lhv*10^-12;

energyProduction_inBH_rainfed_EJ = energyProduction_rainfed_EJ.*(obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot);
energyProduction_inBH_irrigated_EJ = energyProduction_irrigated_EJ.*(obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot);
energyProduction_inBH_mixed_EJ = energyProduction_mixed_EJ.*(obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot);

energyProduction_outsideBH_rainfed_EJ = energyProduction_rainfed_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot);
energyProduction_outsideBH_irrigated_EJ = energyProduction_irrigated_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot);
energyProduction_outsideBH_mixed_EJ = energyProduction_mixed_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot);


landRequirement_vector_rainfed_Mha = 10^-6*identifiedLandMatrix_hectare(energyProduction_rainfed_EJ > 0);
landRequirement_vector_irrigated_Mha = 10^-6*identifiedLandMatrix_hectare(energyProduction_irrigated_EJ > 0);
landRequirement_vector_mixed_Mha = 10^-6*identifiedLandMatrix_hectare(energyProduction_mixed_EJ > 0);

energyProduction_vector_rainfed_EJ = energyProduction_rainfed_EJ (energyProduction_rainfed_EJ > 0);
energyProduction_vector_irrigated_EJ = energyProduction_irrigated_EJ (energyProduction_irrigated_EJ > 0);
energyProduction_vector_mixed_EJ = energyProduction_mixed_EJ (energyProduction_mixed_EJ > 0);

energyProduction_vector_inBH_rainfed_EJ = energyProduction_inBH_rainfed_EJ((energyProduction_rainfed_EJ.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot) > 0);
energyProduction_vector_outsideBH_rainfed_EJ = energyProduction_outsideBH_rainfed_EJ((energyProduction_rainfed_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot)) > 0);
energyProduction_vector_inBH_irrigated_EJ = energyProduction_inBH_irrigated_EJ((energyProduction_irrigated_EJ.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot) > 0);
energyProduction_vector_outsideBH_irrigated_EJ = energyProduction_outsideBH_irrigated_EJ((energyProduction_irrigated_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot)) > 0);
energyProduction_vector_inBH_mixed_EJ = energyProduction_inBH_mixed_EJ((energyProduction_mixed_EJ.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot) > 0);
energyProduction_vector_outsideBH_mixed_EJ = energyProduction_outsideBH_mixed_EJ((energyProduction_mixed_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot)) > 0);

landRequirement_vector_inBH_rainfed_Mha = identifiedLandMatrix_inBiodiversityHotspots_hectare((energyProduction_rainfed_EJ.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot) > 0);
landRequirement_vector_outsideBH_rainfed_Mha = identifiedLandMatrix_outsideBiodiversityHotspots_hectare((energyProduction_rainfed_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot)) > 0);
landRequirement_vector_inBH_irrigated_Mha = identifiedLandMatrix_inBiodiversityHotspots_hectare((energyProduction_irrigated_EJ.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot) > 0); 
landRequirement_vector_outsideBH_irrigated_Mha = identifiedLandMatrix_outsideBiodiversityHotspots_hectare((energyProduction_irrigated_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot)) > 0);
landRequirement_vector_inBH_mixed_Mha = identifiedLandMatrix_inBiodiversityHotspots_hectare((energyProduction_mixed_EJ.*obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot) > 0); 
landRequirement_vector_outsideBH_mixed_Mha = identifiedLandMatrix_outsideBiodiversityHotspots_hectare((energyProduction_mixed_EJ.*(1-obj.fractionsMatrix_spatialLocationIsBiodiversityHotspot)) > 0);

%Get accumulated energy production and land use
[ accumulatedEnergyProduction_rainfed_EJ, accumulatedLandUse_rainfed_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_rainfed_EJ, landRequirement_vector_rainfed_Mha);
[ accumulatedEnergyProduction_irrigated_EJ, accumulatedLandUse_irrigated_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_irrigated_EJ, landRequirement_vector_irrigated_Mha);
[ accumulatedEnergyProduction_mixed_EJ, accumulatedLandUse_mixed_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_mixed_EJ, landRequirement_vector_mixed_Mha);

[ accumulatedEnergyProduction_inBH_rainfed_EJ, accumulatedLandUse_inBH_rainfed_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_inBH_rainfed_EJ, landRequirement_vector_inBH_rainfed_Mha);
[ accumulatedEnergyProduction_inBH_irrigated_EJ, accumulatedLandUse_inBH_irrigated_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_inBH_irrigated_EJ, landRequirement_vector_inBH_irrigated_Mha);
[ accumulatedEnergyProduction_inBH_mixed_EJ, accumulatedLandUse_inBH_mixed_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_inBH_mixed_EJ, landRequirement_vector_inBH_mixed_Mha);

[ accumulatedEnergyProduction_outsideBH_rainfed_EJ, accumulatedLandUse_outsideBH_rainfed_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_outsideBH_rainfed_EJ, landRequirement_vector_outsideBH_rainfed_Mha);

[ accumulatedEnergyProduction_outsideBH_irrigated_EJ, accumulatedLandUse_outsideBH_irrigated_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_outsideBH_irrigated_EJ, landRequirement_vector_outsideBH_irrigated_Mha);
[ accumulatedEnergyProduction_outsideBH_mixed_EJ, accumulatedLandUse_outsideBH_mixed_Mha ] = obj.supportFunction_makeAccumulatedVectors_landEnergyTradeoffs( energyProduction_vector_outsideBH_mixed_EJ, landRequirement_vector_outsideBH_mixed_Mha);


%Print some results
%10EJ irrigateed
[value,idx] = min(abs(accumulatedEnergyProduction_irrigated_EJ-10));
fprintf(['Land requirement for 10 EJ of irrigated bioenergy production: ' num2str(accumulatedLandUse_irrigated_Mha(idx)) '\n']);
%10 EJ rain-fed
[value,idx] = min(abs(accumulatedEnergyProduction_rainfed_EJ-10));
fprintf(['Land requirement for 10 EJ of rainfed bioenergy production: ' num2str(accumulatedLandUse_rainfed_Mha(idx)) '\n']);
%10 EJ mixed
[value,idx] = min(abs(accumulatedEnergyProduction_mixed_EJ-10));
fprintf(['Land requirement for 10 EJ of mixed water supply bioenergy production: ' num2str(accumulatedLandUse_mixed_Mha(idx)) '\n']);


%Biodiversity hotspots, irrigated
% 5 EJ
[value,idx] = min(abs(accumulatedEnergyProduction_inBH_irrigated_EJ-5));
fprintf(['Land requirement for 5 EJ of irrigated bioenergy production in biodiversity hotspots: ' num2str(accumulatedLandUse_inBH_irrigated_Mha(idx)) '\n']);
% 10 EJ
[value,idx] = min(abs(accumulatedEnergyProduction_inBH_irrigated_EJ-10));
fprintf(['Land requirement for 10 EJ of irrigated bioenergy production in biodiversity hotspots: ' num2str(accumulatedLandUse_inBH_irrigated_Mha(idx)) '\n']);
% 15 EJ
[value,idx] = min(abs(accumulatedEnergyProduction_inBH_irrigated_EJ-15));
fprintf(['Land requirement for 15 EJ of irrigated bioenergy production in biodiversity hotspots: ' num2str(accumulatedLandUse_inBH_irrigated_Mha(idx)) '\n']);





%% PLOT
timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
outputFolder = 'Output/';
filename = [outputFolder obj.scenarioDescription_string '_accumulated_land_energy_tradeoffs_of_stepwise_deployment_' timestamp '.tif'];
    
figure1 = figure;
%Global
subplot(3,3,1)
plot(accumulatedLandUse_rainfed_Mha,accumulatedEnergyProduction_rainfed_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_rainfed_Mha(end)]);
ylim([0 40])
yticks([0:10:40])

subplot(3,3,2)
plot(accumulatedLandUse_irrigated_Mha,accumulatedEnergyProduction_irrigated_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_irrigated_Mha(end)]);
ylim([0 40])
yticks([0:10:40])

subplot(3,3,3)
plot(accumulatedLandUse_mixed_Mha,accumulatedEnergyProduction_mixed_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_mixed_Mha(end)]);
ylim([0 40])
yticks([0:10:40])

%In Biodiverrsity hotspots
subplot(3,3,4)
plot(accumulatedLandUse_inBH_rainfed_Mha,accumulatedEnergyProduction_inBH_rainfed_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_inBH_rainfed_Mha(end)]);
ylim([0 20])
yticks([0:5:20])

subplot(3,3,5)
plot(accumulatedLandUse_inBH_irrigated_Mha,accumulatedEnergyProduction_inBH_irrigated_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_inBH_irrigated_Mha(end)]);
ylim([0 20])
yticks([0:5:20])

subplot(3,3,6)
plot(accumulatedLandUse_inBH_mixed_Mha,accumulatedEnergyProduction_inBH_mixed_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_inBH_mixed_Mha(end)]);
ylim([0 20])
yticks([0:5:20])

%Outside Biodiverrsity hotspots
subplot(3,3,7)
plot(accumulatedLandUse_outsideBH_rainfed_Mha,accumulatedEnergyProduction_outsideBH_rainfed_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_outsideBH_rainfed_Mha(end)]);
ylim([0 25])
yticks([0:5:25])

subplot(3,3,8)
plot(accumulatedLandUse_outsideBH_irrigated_Mha,accumulatedEnergyProduction_outsideBH_irrigated_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_outsideBH_irrigated_Mha(end)]);
ylim([0 25])
yticks([0:5:25])

subplot(3,3,9)
plot(accumulatedLandUse_outsideBH_mixed_Mha,accumulatedEnergyProduction_outsideBH_mixed_EJ);
xlabel('Mha')
ylabel('EJ yr^{-1}');
xlim([0 accumulatedLandUse_outsideBH_mixed_Mha(end)]);
ylim([0 25])
yticks([0:5:25])
%%SAVE
saveas(figure1,filename);
close all
clear('figure1')
fprintf(['Land-energy trade-off figure saved to: ' filename '\n']);
end

