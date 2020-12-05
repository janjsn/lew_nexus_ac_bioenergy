function [ abandonedCropland_Norway_hectare ] = getAbandonedCropland_Norway(  )
%GETABANDONEDCROPLAND_NORWAY Summary of this function goes here
%   Detailed explanation goes here

filename = 'InputData/Abandoned_cropland_Norway_1992_2018_5arcmin_2020_05_13_1426.nc';

ncid = netcdf.open(filename);

[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
lastVarID = nvars-1;

found = 0;
for k = 0:lastVarID
    [varname0,xtype0,dimids0,natts0] = netcdf.inqVar(ncid,k);
    if strcmp(varname0, 'abandoned_cropland_hectare')
        abandonedCropland_Norway_hectare = netcdf.getVar(ncid,k);
        found = 1;
        break
    end
end

if found == 0
   error('Could not find variable in netcdf.') 
end



end

