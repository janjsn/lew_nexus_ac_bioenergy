function obj = estimateMarginalWaterEnergyTradeOffs( obj )
%ESTIMATEMARIGNALWATERENERGYTRADEOFFS Summary of this function goes here
%   Detailed explanation goes here
plotStuff = 1; %indicate if function should plot and export results


global_energyGain_MJ = obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear > 0);
global_waterUse_m3 = obj.waterUseToIrrigate_lhv_m3(obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear > 0);
global_blueWaterFootprint_m3_perGJ = global_waterUse_m3./(global_energyGain_MJ*10^-3);

%Change to EJ and billion m3
global_energyGain_EJ = global_energyGain_MJ*10^-12;
global_waterUse_billion_m3 = global_waterUse_m3*10^-9;
%Make temp blue water footprint vector
temp_blueWaterFootprint_m3_perGJ = global_blueWaterFootprint_m3_perGJ;

%Preallocate sorted vectors
global_energyGain_sortedAfterBlueWaterFootprint_EJ = zeros(1,length(temp_blueWaterFootprint_m3_perGJ));
global_waterUse_sortedAfterBlueWaterFootprint_billion_m3 = zeros(1,length(temp_blueWaterFootprint_m3_perGJ));
global_blueWaterFootprint_sorted_m3_perGJ = zeros(1,length(temp_blueWaterFootprint_m3_perGJ));

for i = 1:length(temp_blueWaterFootprint_m3_perGJ)
    %Find index of smalles blue water footprint
    [value,idx] = min(temp_blueWaterFootprint_m3_perGJ);
    
    %Get associated variables
    global_energyGain_sortedAfterBlueWaterFootprint_EJ(i) = global_energyGain_EJ(idx);
    global_waterUse_sortedAfterBlueWaterFootprint_billion_m3(i) = global_waterUse_billion_m3(idx);
    global_blueWaterFootprint_sorted_m3_perGJ(i) = global_energyGain_sortedAfterBlueWaterFootprint_EJ(i)/global_waterUse_sortedAfterBlueWaterFootprint_billion_m3(i); 
    %Remove datapoint from temporary vector
    temp_blueWaterFootprint_m3_perGJ(idx) = NaN;
end

%Make accumulated vectors
global_accumulatedEnergyGainOfDeployment_EJ = zeros(1,length(global_energyGain_sortedAfterBlueWaterFootprint_EJ));
global_accumulatedWaterUseOfDeployment_billion_m3 = zeros(1,length(global_energyGain_sortedAfterBlueWaterFootprint_EJ));
global_blueWaterFootprintOfDeployment_m3_perGJ = zeros(1,length(global_energyGain_sortedAfterBlueWaterFootprint_EJ));

for i = 1:length(temp_blueWaterFootprint_m3_perGJ)
    if i == 1
        global_accumulatedEnergyGainOfDeployment_EJ(i) = global_energyGain_sortedAfterBlueWaterFootprint_EJ(i);
        global_accumulatedWaterUseOfDeployment_billion_m3(i) = global_waterUse_sortedAfterBlueWaterFootprint_billion_m3(i);
    else
        global_accumulatedEnergyGainOfDeployment_EJ(i) = global_accumulatedEnergyGainOfDeployment_EJ(i-1)+global_energyGain_sortedAfterBlueWaterFootprint_EJ(i);
        global_accumulatedWaterUseOfDeployment_billion_m3(i) = global_accumulatedWaterUseOfDeployment_billion_m3(i-1)+ global_waterUse_sortedAfterBlueWaterFootprint_billion_m3(i);
    end
    global_blueWaterFootprintOfDeployment_m3_perGJ(i) = global_accumulatedWaterUseOfDeployment_billion_m3(i)/global_accumulatedEnergyGainOfDeployment_EJ(i);
end



%% WATER SCARCITY AREAS
binary_lowWaterScarcity = obj.WaterScarcityLevel.dataMatrix_global <= 1;
binary_moderateWaterScarcity = obj.WaterScarcityLevel.dataMatrix_global == 2;
binary_highWaterScarcity = obj.WaterScarcityLevel.dataMatrix_global >= 3;

lowWS_energyGain_MJ = obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_lowWaterScarcity;
binary_temp = lowWS_energyGain_MJ > 0;
lowWS_energyGain_MJ = lowWS_energyGain_MJ(binary_temp);
lowWS_waterUse_m3 = obj.waterUseToIrrigate_lhv_m3.*binary_lowWaterScarcity;
lowWS_waterUse_m3 = lowWS_waterUse_m3(binary_temp);
[ lowWS_accumulatedEnergyGainOfDeployment_EJ,lowWS_accumulatedWaterUseOfDeployment_billion_m3,lowWS_blueWaterFootprintOfDeployment_m3_perGJ ] = obj.supportFunction_makeAccumulatedVectors_marginalTradeoffs(lowWS_energyGain_MJ,lowWS_waterUse_m3 );


moderateWS_energyGain_MJ = obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_moderateWaterScarcity;
binary_temp = moderateWS_energyGain_MJ > 0;
moderateWS_energyGain_MJ = moderateWS_energyGain_MJ(binary_temp);
moderateWS_waterUse_m3 = obj.waterUseToIrrigate_lhv_m3.*binary_moderateWaterScarcity;
moderateWS_waterUse_m3 = moderateWS_waterUse_m3(binary_temp);

[ moderateWS_accumulatedEnergyGainOfDeployment_EJ,moderateWS_accumulatedWaterUseOfDeployment_billion_m3,moderateWS_blueWaterFootprintOfDeployment_m3_perGJ ] = obj.supportFunction_makeAccumulatedVectors_marginalTradeoffs(moderateWS_energyGain_MJ,moderateWS_waterUse_m3 );

highWS_energyGain_MJ = obj.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear.*binary_highWaterScarcity;
binary_temp = highWS_energyGain_MJ > 0;
highWS_energyGain_MJ = highWS_energyGain_MJ(binary_temp);
highWS_waterUse_m3 = obj.waterUseToIrrigate_lhv_m3.*binary_highWaterScarcity;
highWS_waterUse_m3 = highWS_waterUse_m3(binary_temp);

[ highWS_accumulatedEnergyGainOfDeployment_EJ,highWS_accumulatedWaterUseOfDeployment_billion_m3,highWS_blueWaterFootprintOfDeployment_m3_perGJ ] = obj.supportFunction_makeAccumulatedVectors_marginalTradeoffs(highWS_energyGain_MJ,highWS_waterUse_m3 );


%% PRINT SOME RESULTS
[value,idx] = min(abs(global_accumulatedWaterUseOfDeployment_billion_m3-100));
fprintf(['Energy gain of 100 m3 water withdrawal (all): ' num2str(global_accumulatedEnergyGainOfDeployment_EJ(idx))]);
[value,idx] = min(abs(global_accumulatedWaterUseOfDeployment_billion_m3-200));
fprintf(['Energy gain of 200 m3 water withdrawal (all): ' num2str(global_accumulatedEnergyGainOfDeployment_EJ(idx))]);

fprintf(['Energy gain of 408 m3 water withdrawal (all): ' num2str(global_accumulatedEnergyGainOfDeployment_EJ(end))]);

%% PLOT SUBPLOT
if plotStuff == 1
    timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
    outputFolder = 'Output/';
    filename = [outputFolder obj.scenarioDescription_string '_accumulated_water_energy_tradeoffs_of_stepwise_deployment_' timestamp '.tif'];
    

    
   
    
    figure1 = figure;
    subplot(2,2,1)
    %ALl land
    plot( global_accumulatedWaterUseOfDeployment_billion_m3, global_accumulatedEnergyGainOfDeployment_EJ);
    xlabel('billion m^3 yr^{-1}')
    ylabel('EJ yr^{-1}')
    title('All')
    xlim([0 global_accumulatedWaterUseOfDeployment_billion_m3(end)])
    %Low physical water scarcity
    subplot(2,2,2)
    plot(lowWS_accumulatedWaterUseOfDeployment_billion_m3,lowWS_accumulatedEnergyGainOfDeployment_EJ);
    xlabel('billion m^3 yr^{-1}')
    ylabel('EJ yr^{-1}')
    title('Low')
    xlim([0 lowWS_accumulatedWaterUseOfDeployment_billion_m3(end)])
    %Moderate physical water scarcity
    subplot(2,2,3)
    plot(moderateWS_accumulatedWaterUseOfDeployment_billion_m3,moderateWS_accumulatedEnergyGainOfDeployment_EJ);
    xlabel('billion m^3 yr^{-1}')
    ylabel('EJ yr^{-1}')
    title('Moderate')
    xlim([0 moderateWS_accumulatedWaterUseOfDeployment_billion_m3(end)])
    %High physical water scarcity
    subplot(2,2,4)
    plot(highWS_accumulatedWaterUseOfDeployment_billion_m3,highWS_accumulatedEnergyGainOfDeployment_EJ);
    xlabel('billion m^3 yr^{-1}')
    ylabel('EJ yr^{-1}')
    title('High')
    xlim([0 highWS_accumulatedWaterUseOfDeployment_billion_m3(end)])
    %%SAVE
    saveas(figure1,filename);
    close all
    clear('figure1')
    fprintf(['Water-energy trade-off figure saved to: ' filename '\n']);
end
end

