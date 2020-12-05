function [ ClimateScenarioArray ] = makeClimateScenarioArray( )
%Name and describe climate scenario characteristics here. Inputs must match
%IDs given in GAEZ namelist excel file.

%Example:
% ClimateScenarioArray(1).name = 'RCP 4.5';
% ClimateScenarioArray(1).ID =4;
% ClimateScenarioArray(1).description = 'RCP 4.5, HadCM3';
% ClimateScenarioArray(1).isRCP = 1;
% ClimateScenarioArray(1).isSRES = 0;
% ClimateScenarioArray(1).isHistorical = 0;
% ClimateScenarioArray(1).correspondingSRES_ID = 2;
% ClimateScenarioArray(1).correspondingSRES_string = 'SRES B1';
% ClimateScenarioArray(1).isBaseline_forComparisons = 1;

%% Input:
nScenarios = 5;

ClimateScenarioArray(1:nScenarios) = ClimateScenario;

%% SCENARIO 1: Historical mean
ClimateScenarioArray(1).name = 'Historical';
ClimateScenarioArray(1).ID = 1;
ClimateScenarioArray(1).description = 'Historical climate data';
ClimateScenarioArray(1).isRCP = 0;
ClimateScenarioArray(1).isSRES = 0;
ClimateScenarioArray(1).isHistorical = 1;
ClimateScenarioArray(1).isBaseline_forComparisons = 0;

%Scenario 2: SRES B1, Hadley CM3 B1
ClimateScenarioArray(2).name = 'SRES B1';
ClimateScenarioArray(2).ID = 2;
ClimateScenarioArray(2).description = 'SRES B1 climate scenario, HadCM3 B1. Corresponds to RCP 4.5.';
ClimateScenarioArray(2).isRCP = 0;
ClimateScenarioArray(2).isSRES = 1;
ClimateScenarioArray(2).isHistorical = 0;
ClimateScenarioArray(2).correspondingRCP_ID = 4;
ClimateScenarioArray(2).correspondingRCP_string = 'RCP 4.5';
ClimateScenarioArray(2).isBaseline_forComparisons = 1;

%Scenario 3: SRES A1FI, Hadley CM3 A1FI
ClimateScenarioArray(3).name = 'SRES A1FI';
ClimateScenarioArray(3).ID = 3;
ClimateScenarioArray(3).description = 'SRES A1FI climate scenario, HadCM3 A1FI. Corresponds to RCP 8.5';
ClimateScenarioArray(3).isRCP = 0;
ClimateScenarioArray(3).isSRES = 1;
ClimateScenarioArray(3).isHistorical = 0;
ClimateScenarioArray(3).correspondingRCP_ID = 5;
ClimateScenarioArray(3).correspondingRCP_string = 'RCP 8.5';
ClimateScenarioArray(3).isBaseline_forComparisons = 0;

%Scenario 4: RCP 4.5, CMIP 5 CMCC-CM
ClimateScenarioArray(4).name = 'RCP 4.5';
ClimateScenarioArray(4).ID =4;
ClimateScenarioArray(4).description = 'RCP 4.5';
ClimateScenarioArray(4).isRCP = 1;
ClimateScenarioArray(4).isSRES = 0;
ClimateScenarioArray(4).isHistorical = 0;
ClimateScenarioArray(4).correspondingSRES_ID = 2;
ClimateScenarioArray(4).correspondingSRES_string = 'SRES B1';
ClimateScenarioArray(4).isBaseline_forComparisons = 0;

%Scenario 5: RCP 8.5, CMIP5 CMCC-CM
ClimateScenarioArray(5).name = 'RCP 8.5';
ClimateScenarioArray(5).ID = 5;
ClimateScenarioArray(5).description = 'RCP 8.5';
ClimateScenarioArray(5).isRCP = 1;
ClimateScenarioArray(5).isSRES = 0;
ClimateScenarioArray(5).isHistorical = 0;
ClimateScenarioArray(5).correspondingSRES_ID = 3;
ClimateScenarioArray(5).correspondingSRES_string = 'SRES A1FI';
ClimateScenarioArray(5).isBaseline_forComparisons = 0;

end

