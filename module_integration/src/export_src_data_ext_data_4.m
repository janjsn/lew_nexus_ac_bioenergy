function  export_src_data_ext_data_4( Aggregated_results_medium_intensity, Aggregated_results_high_intensity)
%EXPORT_SRC_DATA_EXT_DATA_4 Summary of this function goes here
%   Detailed explanation goes here
filename = 'Output/source_data_extended_data_4.nc';

if exist(filename) == 2
    delete(filename)
end

lat = Aggregated_results_medium_intensity.latitudeVector_centered;
lon = Aggregated_results_medium_intensity.longitudeVector_centered;



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


nccreate(filename, 'water_withdrawals_medium_management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_withdrawals_medium_management_intensity', 'standard_name', 'Water withdrawals of complete irrigation at medium management intensity');
ncwriteatt(filename, 'water_withdrawals_medium_management_intensity', 'long_name', 'Water withdrawals of complete irrigation at medium management intensity');
ncwriteatt(filename, 'water_withdrawals_medium_management_intensity', 'units', 'million m3');
ncwriteatt(filename, 'water_withdrawals_medium_management_intensity', 'missing_value', '-999');

nccreate(filename, 'water_withdrawals_high_management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'water_withdrawals_high_management_intensity', 'standard_name', 'Water withdrawals of complete irrigation at high management intensity');
ncwriteatt(filename, 'water_withdrawals_high_management_intensity', 'long_name', 'Water withdrawals of complete irrigation at high management intensity');
ncwriteatt(filename, 'water_withdrawals_high_management_intensity', 'units', 'million m3');
ncwriteatt(filename, 'water_withdrawals_high_management_intensity', 'missing_value', '-999');


%energy yield gain per irrigation unit GJ/ha*mm
nccreate(filename, 'blue_water_footprint_medium_management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'blue_water_footprint_medium_management_intensity', 'standard_name', 'Blue water footprint of irrigation at medium management intensity');
ncwriteatt(filename, 'blue_water_footprint_medium_management_intensity', 'long_name', 'Blue water footprint of irrigation at medium management intensity');
ncwriteatt(filename, 'blue_water_footprint_medium_management_intensity', 'units', 'm3 GJ-1');
ncwriteatt(filename, 'blue_water_footprint_medium_management_intensity', 'missing_value', '-999');

nccreate(filename, 'blue_water_footprint_high_management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'blue_water_footprint_high_management_intensity', 'standard_name', 'Blue water footprint of irrigation at high management intensity');
ncwriteatt(filename, 'blue_water_footprint_high_management_intensity', 'long_name', 'Blue water footprint of irrigation at high management intensity');
ncwriteatt(filename, 'blue_water_footprint_high_management_intensity', 'units', 'm3 GJ-1');
ncwriteatt(filename, 'blue_water_footprint_high_management_intensity', 'missing_value', '-999');

medium_ww_m3 = Aggregated_results_medium_intensity.waterUseToIrrigate_lhv_m3;
high_ww_m3 = Aggregated_results_high_intensity.waterUseToIrrigate_lhv_m3;

medium_tot_energy_gain_GJ = Aggregated_results_medium_intensity.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3;
high_tot_energy_gain_GJ = Aggregated_results_high_intensity.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-3;



medium_blue_wf_m3_perGJ = medium_ww_m3./medium_tot_energy_gain_GJ;
medium_blue_wf_m3_perGJ(isnan(medium_blue_wf_m3_perGJ)) = -999;
medium_blue_wf_m3_perGJ(medium_tot_energy_gain_GJ == 0) = -999;


high_blue_wf_m3_perGJ = high_ww_m3./high_tot_energy_gain_GJ;
high_blue_wf_m3_perGJ(isnan(high_blue_wf_m3_perGJ)) = -999;
high_blue_wf_m3_perGJ(high_tot_energy_gain_GJ == 0) = -999;

medium_ww_Mm3 = medium_ww_m3*10^-6;
high_ww_Mm3 = high_ww_m3*10^-6;

medium_ww_Mm3(medium_ww_Mm3 == 0) = -999;
high_ww_Mm3(high_ww_Mm3 == 0) = -999;



ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'water_withdrawals_medium_management_intensity', medium_ww_Mm3);
ncwrite(filename, 'water_withdrawals_high_management_intensity', high_ww_Mm3);
ncwrite(filename, 'blue_water_footprint_medium_management_intensity', medium_blue_wf_m3_perGJ);
ncwrite(filename, 'blue_water_footprint_high_management_intensity', high_blue_wf_m3_perGJ);

end

