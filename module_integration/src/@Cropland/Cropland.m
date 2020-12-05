classdef Cropland
    %CROPLAND Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        latitudeVector_centered
        longitudeVector_centered
        cellAreaPerLatitude
        cropland_hectare
        cropland_fractions
        year
    end
    
    methods
        function obj = Cropland(filename)
            ncid = netcdf.open(filename);
            
            obj.latitudeVector_centered = netcdf.getVar(ncid,0);
            obj.longitudeVector_centered = netcdf.getVar(ncid,1);
            obj.cellAreaPerLatitude = netcdf.getVar(ncid,2);
            obj.cropland_hectare = netcdf.getVar(ncid,3);
            obj.cropland_fractions = netcdf.getVar(ncid,4);
            netcdf.close(ncid);
            
        end
    end
    
end

