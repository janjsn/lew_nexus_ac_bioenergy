function exportGlobalGrid_cropIDsAndEnergyYield( obj, latitudeVector, longitudeVector )
%EXPORTGLOBALGRID_CROPIDSANDENERGYYIELD Summary of this function goes here
%   Detailed explanation goes here

outputFolder = 'Output';

%Making sure output folder exist
if exist([outputFolder '/NC files/Optimal solutions/Global grids/'],'dir') ~= 7
    mkdir([outputFolder '/NC files/Optimal solutions/Global grids/']);
end

outputFolder = [outputFolder '/NC files/Optimal solutions/Global grids/'];
timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

if obj.irrigationLevel ==1 
   water_string = 'irrigated';
else
    water_string  ='rainfed';
end

if obj.fertilizerLevel == 1
    ai_string = 'low_intensity';
elseif obj.fertilizerLevel == 2
    ai_string = 'medium_intensity';
elseif obj.fertilizerLevel == 3
    ai_string = 'high_intensity';
end


description_string = [num2str(obj.year) '_' obj.ClimateScenario.correspondingRCP_string '_' water_string '_' ai_string];



filename = [outputFolder description_string '_global_grid_optimal_solution_' timestamp '.nc'];

lon = longitudeVector;
lat = latitudeVector;


nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees_north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename, 'lat', 'axis', 'Y'); %ADDED 1306

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X'); %ADDED 1306

nccreate(filename, 'year', 'Datatype', 'double')
ncwriteatt(filename, 'year', 'standard_name', 'year')
ncwriteatt(filename, 'year', 'long_name', 'year of analyses')
ncwriteatt(filename, 'year', 'units', '');
%ncwriteatt(filename, 'year', 'Datatype', 'double')

nccreate(filename, 'scenario_description', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'scenario_description', 'standard_name', 'scenario_description')
ncwriteatt(filename, 'scenario_description', 'long_name', 'scenario_description')

nccreate(filename, 'crop_descriptions_array', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'crop_descriptions_array', 'standard_name', 'crop_descriptions');
ncwriteatt(filename, 'crop_descriptions_array', 'long_name', 'crop_descriptions_array')
ncwriteatt(filename, 'crop_descriptions_array', 'units', ''); 

nccreate(filename,'optimal_crop_ID','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'optimal_crop_ID', 'standard_name', 'optimal_crop_ID_lhv');
ncwriteatt(filename, 'optimal_crop_ID', 'long_name', 'optimal_crop_ID_lhv');
ncwriteatt(filename, 'optimal_crop_ID', 'units', '');
ncwriteatt(filename, 'optimal_crop_ID', 'missing_value', '-999');

nccreate(filename,'bioenergy_yield','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_yield', 'standard_name', 'bioenergy_yield_lhv');
ncwriteatt(filename, 'bioenergy_yield', 'long_name', 'bioenergy_yield_lhv');
ncwriteatt(filename, 'bioenergy_yield', 'units', 'GJ ha-1 yr-1');
ncwriteatt(filename, 'bioenergy_yield', 'missing_value', '-999');

nccreate(filename,'water_deficit','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_deficit', 'standard_name', 'water_deficit');
ncwriteatt(filename, 'water_deficit', 'long_name', 'water_deficit');
ncwriteatt(filename, 'water_deficit', 'units', 'mm yr-1');
ncwriteatt(filename, 'water_deficit', 'missing_value', '-999');


ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'year', obj.year);
ncwrite(filename, 'scenario_description', char(description_string));
ncwrite(filename, 'optimal_crop_ID', obj.globalGrid_allLand_lhv_optimalCropID);
ncwrite(filename, 'bioenergy_yield', obj.globalGrid_allLand_lhv_bioenergyYields_GJ_perHaYear);

if obj.waterDeficitIsConsidered == 1
    ncwrite(filename, 'water_deficit', obj.globalGrid_allLand_lhv_waterDeficit_mm_perYear);
else
    ncwrite(filename, 'water_deficit', zeros(length(lon),length(lat)));
end


cropType_descriptions = {obj.CropType_array.description};
cropType_IDs = [obj.CropType_array.ID];

dummy_string = [ num2str(cropType_IDs(1)) '. ' cropType_descriptions{1}];
for i = 1:length(cropType_descriptions)
    if i > 1
       dummy_string = [dummy_string ' ' num2str(cropType_IDs(i)) '. ' cropType_descriptions{i}]; 
    end
end

ncwrite(filename, 'crop_descriptions_array', char(dummy_string));

% for i = 1:length(cropType_descriptions)
%     ncwrite(filename, 'crop_descriptions_array', cropType_descriptions{i}, i,1);
% end

end

