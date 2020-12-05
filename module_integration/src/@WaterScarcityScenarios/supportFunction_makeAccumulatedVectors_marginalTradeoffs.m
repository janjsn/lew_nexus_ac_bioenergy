function [ global_accumulatedEnergyGainOfDeployment_GJ,global_accumulatedWaterUseOfDeployment_billion_m3,global_blueWaterFootprintOfDeployment_m3_perGJ ] = supportFunction_makeAccumulatedVectors_marginalTradeoffs(obj, global_energyGain_MJ,global_waterUse_m3 )
%Sorts energy gain and water use vectors after water footprint, and
%estimates accumulated energy gains and water use of deployment, and associated mean blue water footprint.

global_energyGain_EJ = global_energyGain_MJ*10^-12;
global_waterUse_billion_m3 = global_waterUse_m3*10^-9;
global_blueWaterFootprint_m3_perGJ = global_waterUse_billion_m3./global_energyGain_EJ;
%Make temp blue water footprint vector
temp_blueWaterFootprint_m3_perGJ = global_blueWaterFootprint_m3_perGJ;

%Preallocate sorted vectors
global_energyGain_sortedAfterBlueWaterFootprint_GJ = zeros(1,length(temp_blueWaterFootprint_m3_perGJ));
global_waterUse_sortedAfterBlueWaterFootprint_billion_m3 = zeros(1,length(temp_blueWaterFootprint_m3_perGJ));
global_blueWaterFootprint_sorted_m3_perGJ = zeros(1,length(temp_blueWaterFootprint_m3_perGJ));

for i = 1:length(temp_blueWaterFootprint_m3_perGJ)
    %Find index of smalles blue water footprint
    [value,idx] = min(temp_blueWaterFootprint_m3_perGJ);
    
    %Get associated variables
    global_energyGain_sortedAfterBlueWaterFootprint_GJ(i) = global_energyGain_EJ(idx);
    global_waterUse_sortedAfterBlueWaterFootprint_billion_m3(i) = global_waterUse_billion_m3(idx);
    global_blueWaterFootprint_sorted_m3_perGJ(i) = global_energyGain_sortedAfterBlueWaterFootprint_GJ(i)/global_waterUse_sortedAfterBlueWaterFootprint_billion_m3(i); 
    %Remove datapoint from temporary vector
    temp_blueWaterFootprint_m3_perGJ(idx) = NaN;
end

%Make accumulated vectors
global_accumulatedEnergyGainOfDeployment_GJ = zeros(1,length(global_energyGain_sortedAfterBlueWaterFootprint_GJ));
global_accumulatedWaterUseOfDeployment_billion_m3 = zeros(1,length(global_energyGain_sortedAfterBlueWaterFootprint_GJ));
global_blueWaterFootprintOfDeployment_m3_perGJ = zeros(1,length(global_energyGain_sortedAfterBlueWaterFootprint_GJ));

for i = 1:length(temp_blueWaterFootprint_m3_perGJ)
    if i == 1
        global_accumulatedEnergyGainOfDeployment_GJ(i) = global_energyGain_sortedAfterBlueWaterFootprint_GJ(i);
        global_accumulatedWaterUseOfDeployment_billion_m3(i) = global_waterUse_sortedAfterBlueWaterFootprint_billion_m3(i);
    else
        global_accumulatedEnergyGainOfDeployment_GJ(i) = global_accumulatedEnergyGainOfDeployment_GJ(i-1)+global_energyGain_sortedAfterBlueWaterFootprint_GJ(i);
        global_accumulatedWaterUseOfDeployment_billion_m3(i) = global_accumulatedWaterUseOfDeployment_billion_m3(i-1)+ global_waterUse_sortedAfterBlueWaterFootprint_billion_m3(i);
    end
    global_blueWaterFootprintOfDeployment_m3_perGJ(i) = global_accumulatedWaterUseOfDeployment_billion_m3(i)/global_accumulatedEnergyGainOfDeployment_GJ(i);
end

end

