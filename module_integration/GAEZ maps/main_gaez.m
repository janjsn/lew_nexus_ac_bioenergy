function [GAEZ_dataArray, GAEZ_waterScarcityData] = main_gaez( )
%Function to import GAEZ 3.0 crop yields.
%%%%%%%%%%%%%%%
% Data must be downloaded from GAEZ website, put in "/GAEZ maps/Data", and
% mapped correctly in Excel dictionary "/GAEZ maps/Input/Import GAEZ
% files_withWaterDeficit.xlsx'.
% This must also done for water scarcity data. Available either at GAEZ
% website or FAO aquastat.
%%%%%%%%%%%%%%%%%%
% Contact : Jan Sandstad Næss

%url crop yields and water deficit: http://www.gaez.iiasa.ac.at/



addpath(genpath(pwd));

%Import data. Remember to set correct excel dictionary file name.
GAEZ_fileArray = readExcel_GAEZ('Import GAEZ files_withWaterDeficit.xlsx', 'Filenames');
GAEZ_dataArray = importGAEZ(GAEZ_fileArray);

%Import water scarcity data. 
[Matrix, DataInformation] = arcgridread('GAEZ maps/Data/Water scarcity/Water scarcity by major hydrological basin_ascii_GAEZ/data_raw.asc','geographic');

%Call constructor
GAEZ_waterScarcityData = WaterScarcity_data(Matrix, DataInformation);

end

