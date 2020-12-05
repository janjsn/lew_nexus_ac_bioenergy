function exportLandUseChange_fromClassToClassArray( LandUseChange_fromClassToClassArray, filename )
%EXPORTLANDUSECHANGE_FROMCLASSTOCLASSARRAY Summary of this function goes here
%   Detailed explanation goes here

nChanges = length(LandUseChange_fromClassToClassArray);

nRows = 4;

nCols = 5;

output = cell(nRows,nCols);

output(1,:) = {'Land use changes, from class to class', ' ', ' ', ' ', ' '};
output(2,:) = {' ', ' ', ' ', ' ', ' '};
thirdRow = {'From ID', 'To ID', 'CF from', 'CF to', 'Filtered area'};
fourthRow = {'[#]','[#]','[0-1]','[0-1]','[m^2]'};

output(3,:) = thirdRow;
output(4,:) = fourthRow;

output_num = zeros(length(LandUseChange_fromClassToClassArray),nCols);
c=1;

for i = 1:length(LandUseChange_fromClassToClassArray)
   newRow = [LandUseChange_fromClassToClassArray(i).fromClass_ID, LandUseChange_fromClassToClassArray(i).toClass_ID, LandUseChange_fromClassToClassArray(i).fromClass_croplandFactor, LandUseChange_fromClassToClassArray(i).toClass_croplandFactor, LandUseChange_fromClassToClassArray(i).areaTotal_m2];
   output_num(c,:) = newRow;
   c=c+1;
end

save('output_num.mat', 'output_num');

%csvwrite(filename, output);
%csvwrite(filename, output_num,5,1);
end

