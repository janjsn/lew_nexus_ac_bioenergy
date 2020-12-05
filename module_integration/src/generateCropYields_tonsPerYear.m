function [ GaezArray ] = generateCropYields_tonsPerYear( GaezArray, areaMatrix, biodiversityHotspotsBinaryMatrix, waterScarcityIsLowMatrix, fractionsMatrix, areaMatrix_excludingBiodiversityHotspots, fractionsMatrix_excludingBiodiversityHotspots )
%GENERATECROPYIELDS_TONSPERYEAR Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(GaezArray)
   %workMatrix = GaezArray(i).dataMatrix_raw'*GaezArray(i).multiplicationFactor;
   workMatrix = GaezArray(i).dataMatrix_lonXlat_multiplicationFactorAccounted;
   mSize = size(workMatrix);
   %size(workMatrix)
   %size(areaMatrix)
   
   yieldMatrix = workMatrix;
   
   for j = 1:mSize(1)
       for k = 1:mSize(2)
           workMatrix(j,k) = workMatrix(j,k)*areaMatrix(j,k);
       end
   end
   GaezArray(i).cropYield_identifiedLands_tonsPerYear = workMatrix;
   GaezArray(i).cropYield_identifiedLands_tonsPerYear_sum = sum(sum(workMatrix));
   
   %Saving more inputs
   GaezArray(i).fractionsMatrix_spatialLocationIsBiodiversityHotspot = biodiversityHotspotsBinaryMatrix;
   GaezArray(i).binaryMatrix_spatialLocationHasLowWaterScarcity = waterScarcityIsLowMatrix;
   
   
   
   GaezArray(i).fractionsMatrix_identifiedLand = fractionsMatrix;
   GaezArray(i).fractionsMatrix_excludingBiodiversityHotspots_identifiedLand = fractionsMatrix_excludingBiodiversityHotspots;
   GaezArray(i).areaMatrix_excludingBiodiversityHotspots_identifiedLand_ha = areaMatrix_excludingBiodiversityHotspots;
   GaezArray(i).areaMatrix_identifiedLand_ha = areaMatrix;
   %Calculating crop yields excluding BH
   GaezArray(i).cropYield_identifiedLands_excludingBiodHotspots_tonsPerYear = yieldMatrix.*areaMatrix_excludingBiodiversityHotspots;
   GaezArray(i).cropYield_identifiedLands_excludingBiodHotspots_tonsPerYear_sum = sum(sum(GaezArray(i).cropYield_identifiedLands_excludingBiodHotspots_tonsPerYear));
end

% %Export to excel
% outMatrix  = zeros(length(GaezArray),1);
% outStrings(1:length(GaezArray)) = ' ';
% %outMatrix_string{1,1} = 'Crop descritption';
% %outMatrix{1,2} = 'Total yield in ton per year';
% 
% for i = 1:length(GaezArray)
%     
%     outMatrix(i,1) = GaezArray(i).cropYield_identifiedLands_tonsPerYear_sum;
%     outStrings(i,1) = GaezArray(i).cropname;
% end
% 
% xlswrite('Estimated crop yields per year at identified land.xlsx', outStrings, 'A1');
% 
% xlswrite('Estimated crop yields per year at identified land.xlsx', outMatrix, 'B1');

end

