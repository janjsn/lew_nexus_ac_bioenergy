function obj = importDataFromFile( obj )
%IMPORT DATA FROM NC FILE. Filename must allready be given in the object.
%   Detailed explanation goes here

%Check if filename is given
if ~ischar(obj.filename)
   %Filename not given. Quit.
   fprintf('Attempted to import nc file without having assigned a filename path. No action performed.');
   return
end

%% Filename given. Importing. 
filename = obj.filename;

%Checking if file exist.
if ~exist(filename, 'file')
    %File don't exist.
    fprintf('No files found at given pathway. No action taken.')
    return 
end
    
%%% File exist. Importing
% open the file
ncid = netcdf.open(filename);

% get the dimensions
[dimname1, dimlen1] = netcdf.inqDim(ncid,0);
[dimname2, dimlen2] = netcdf.inqDim(ncid,1);


%

% close the files
netcdf.close(ncid);

lucc = zeros(dimlen2, dimlen1);
fprintf('Year: ');
fprintf(num2str(obj.year));
fprintf('. ');
fprintf('Reading the data, please wait...\n')

tic
% open the file
ncid = netcdf.open(filename);

% select the variable
varid_lucc = 0;
varid_longitude = 6;
varid_latitude = 5;

% check the variable
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
[varname0,xtype0,dimids0,natts0] = netcdf.inqVar(ncid,varid_lucc);

% get the variables: lucc
obj.landCoverMatrix_lucc(:,:) = netcdf.getVar(ncid,varid_lucc);

%get the variables: longtitidue
obj.longitudeVector = netcdf.getVar(ncid,varid_longitude);

%get the variables: latitude
obj.latitudeVector = netcdf.getVar(ncid,varid_latitude);


%close the file
netcdf.close(ncid);

timeSpent = toc;

%obj.landCoverMatrix_lucc = lucc;


end

