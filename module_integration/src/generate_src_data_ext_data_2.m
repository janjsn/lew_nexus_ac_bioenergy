function  generate_src_data_ext_data_2( OptimalPrimaryEnergyOutput_scenarioArray )
%GENERATE_SRC_DATA_EXT_DATA_3 Summary of this function goes here
%   Detailed explanation goes here

filename = 'Output/source_data_extended_data_figure_2.nc';

if exist(filename) == 2
    delete(filename)
end

identification_vec_rcp_45_2050 = [2 0 3 2050];
identification_vec_rcp_45_2080 = [2 0 3 2080];
identification_vec_rcp_85_2050 = [3 0 3 2050];
identification_vec_rcp_85_2080 = [3 0 3 2080];

for i = 1:length(OptimalPrimaryEnergyOutput_scenarioArray)
   if OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector == identification_vec_rcp_45_2050
       data_rcp45_2050 = OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv;
       lat = OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.latitudeVector_centered;
       lon = OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.longitudeVector_centered;
       
   elseif OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector == identification_vec_rcp_45_2080
       data_rcp45_2080 = OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv;
       
   elseif OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector == identification_vec_rcp_85_2050
       data_rcp85_2050 = OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv;
   
   elseif  OptimalPrimaryEnergyOutput_scenarioArray(i).identificationVector == identification_vec_rcp_85_2080
       data_rcp85_2080 = OptimalPrimaryEnergyOutput_scenarioArray(i).AggregatedResults_oneDegree.percentageChangesMatrix_fromBaseline_primaryEnergy_lhv;       
   end
    
end


nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees_north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename, 'lat', 'axis', 'Y'); 

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X');

nccreate(filename, 'Percentage_yield_change_rcp45_2050s', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Percentage_yield_change_rcp45_2050s', 'standard_name', 'Percentage_yield_change_in_rcp45_2050_compared_to_baseline');
ncwriteatt(filename, 'Percentage_yield_change_rcp45_2050s', 'long_name', 'Percentage_yield_change_in_rcp45_2050_compared_to_baseline');
ncwriteatt(filename, 'Percentage_yield_change_rcp45_2050s', 'units', '%');
ncwriteatt(filename, 'Percentage_yield_change_rcp45_2050s', 'missing_value', '-999');

nccreate(filename, 'Percentage_yield_change_rcp45_2080s', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Percentage_yield_change_rcp45_2080s', 'standard_name', 'Percentage_yield_change_in_rcp45_2080_compared_to_baseline');
ncwriteatt(filename, 'Percentage_yield_change_rcp45_2080s', 'long_name', 'Percentage_yield_change_in_rcp45_2080_compared_to_baseline');
ncwriteatt(filename, 'Percentage_yield_change_rcp45_2080s', 'units', '%');
ncwriteatt(filename, 'Percentage_yield_change_rcp45_2080s', 'missing_value', '-999');

nccreate(filename, 'Percentage_yield_change_rcp85_2050s', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Percentage_yield_change_rcp85_2050s', 'standard_name', 'Percentage_yield_change_in_rcp85_2050_compared_to_baseline');
ncwriteatt(filename, 'Percentage_yield_change_rcp85_2050s', 'long_name', 'Percentage_yield_change_in_rcp85_2050_compared_to_baseline');
ncwriteatt(filename, 'Percentage_yield_change_rcp85_2050s', 'units', '%');
ncwriteatt(filename, 'Percentage_yield_change_rcp85_2050s', 'missing_value', '-999');

nccreate(filename, 'Percentage_yield_change_rcp85_2080s', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'Percentage_yield_change_rcp85_2080s', 'standard_name', 'Percentage_yield_change_in_rcp85_2080_compared_to_baseline');
ncwriteatt(filename, 'Percentage_yield_change_rcp85_2080s', 'long_name', 'Percentage_yield_change_in_rcp85_2080_compared_to_baseline');
ncwriteatt(filename, 'Percentage_yield_change_rcp85_2080s', 'units', '%');
ncwriteatt(filename, 'Percentage_yield_change_rcp85_2080s', 'missing_value', '-999');

nccreate(filename, 'how_to_find_new_areas_with_productivity', 'Datatype', 'char', 'Dimensions', {'dim1', inf});
ncwriteatt(filename, 'how_to_find_new_areas_with_productivity', 'standard_name', 'description');
ncwriteatt(filename, 'how_to_find_new_areas_with_productivity', 'long_name', 'description');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'Percentage_yield_change_rcp45_2050s', data_rcp45_2050);
ncwrite(filename, 'Percentage_yield_change_rcp45_2080s', data_rcp45_2080);
ncwrite(filename, 'Percentage_yield_change_rcp85_2050s', data_rcp85_2050);
ncwrite(filename, 'Percentage_yield_change_rcp85_2080s', data_rcp85_2080);
ncwrite(filename, 'how_to_find_new_areas_with_productivity', 'Areas that are productive under future climatic conditions, but not at present day, are given as missing values (-999).');


end

