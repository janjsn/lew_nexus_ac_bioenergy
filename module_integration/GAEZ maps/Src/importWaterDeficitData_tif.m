function [ matrix_mm ] = importWaterDeficitData_tif( filename )
%IMPORTWATERDEFICITDATA Summary of this function goes here
%   Detailed explanation goes here
%filename
if exist(filename)
matrix_mm = imread(filename);
elseif exist(filename(2:end))
    stringStuff =filename(2:end);
   matrix_mm = imread(stringStuff); 
end
%size(matrix_mm)
matrix_mm(matrix_mm<0) = 0;

matrix_mm = double(matrix_mm)';


end

