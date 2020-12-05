function [ dataMatrix_global_mm, latitudeVector_global, longitudeVector_global] = importWaterDeficitData_asc( filename )
%IMPORTWATERDEFICITDATA_ASC Summary of this function goes here
%   Detailed explanation goes here

%bugfix
if exist(filename)
%matrix_mm = imread(filename);
elseif exist(filename(2:end))
    filename = filename(2:end);
  % matrix_mm = imread(stringStuff);
else
    error('File does not exist.')
end

[matrix, DataInformation_GeographicCellsReference] = arcgridread(filename, 'geographic');

%matrix_raw_lonLat = matrix';
lonStep_raw = DataInformation_GeographicCellsReference.CellExtentInLongitude;
latStep_raw = DataInformation_GeographicCellsReference.CellExtentInLatitude;
longitudeVector_raw = [DataInformation_GeographicCellsReference.LongitudeLimits(1)+lonStep_raw/2:lonStep_raw:DataInformation_GeographicCellsReference.LongitudeLimits(2)-lonStep_raw/2];
latitudeVector_raw = [DataInformation_GeographicCellsReference.LatitudeLimits(2)-latStep_raw/2:-latStep_raw:DataInformation_GeographicCellsReference.LatitudeLimits(1)+latStep_raw/2];

matrix(isnan(matrix)) = 0;

dataMatrix_global_mm = zeros(4320,2160);

longitudeVector_global = [-180+lonStep_raw/2:lonStep_raw:180-lonStep_raw/2];
latitudeVector_global = [90-latStep_raw/2:-latStep_raw:-90+latStep_raw/2];

%%Distributing to global matrix

%finding pos
globalPos_rawLongitudeVector(length(longitudeVector_raw))=0;
globalPos_rawLatitudeVector(length(latitudeVector_raw))=0;
%lon
for i = 1:length(longitudeVector_raw)
    globalPos_rawLongitudeVector(i) = 0;
    for j = 1:length(longitudeVector_global)
        if abs(longitudeVector_raw(i)-longitudeVector_global(j)) < lonStep_raw/2
            globalPos_rawLongitudeVector(i) = j;
            break
        elseif abs(longitudeVector_global(j)-longitudeVector_raw(i)) < lonStep_raw/2
            globalPos_rawLongitudeVector(i) = j;
            break
        end
    end
end
%lat
for i = 1:length(latitudeVector_raw)
    globalPos_rawLatitudeVector(i) = 0;
    for j = 1:length(latitudeVector_global)
        if abs(latitudeVector_raw(i)-latitudeVector_global(j)) < latStep_raw/2
            globalPos_rawLatitudeVector(i) = j;
            break
        elseif abs(latitudeVector_global(j)-latitudeVector_raw(i)) < latStep_raw/2
            globalPos_rawLatitudeVector(i) = j;
            break
        end
    end
end


mSize = size(matrix);
for i = 1:mSize(1)
    for j = 1:mSize(2)
        
        %Assigning value
        dataMatrix_global_mm(globalPos_rawLongitudeVector(j), globalPos_rawLatitudeVector(i)) = matrix(i,j);
        
    end
end


end

