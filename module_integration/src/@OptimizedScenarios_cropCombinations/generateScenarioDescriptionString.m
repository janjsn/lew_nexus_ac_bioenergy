function [ stringOut ] = generateScenarioDescriptionString( obj )
%GENERATESCENARIODESCRIPTIONSTRING Summary of this function goes here
%   Detailed explanation goes here

stringOut = [num2str(obj.year) '_' obj.ClimateScenario.name '_'];
if obj.irrigationLevel == 1
    stringOut = [stringOut 'irrigated_'];
elseif obj.irrigationLevel == 0
    stringOut = [stringOut 'rainfed_'];
end

stringOut = [stringOut 'fertilizerLevel_' num2str(obj.fertilizerLevel)];

if obj.biodiversityHotspotsExcluded == 1
   stringOut = [stringOut '_biodiversityHotspotsExcluded']; 
end

for i = 1:length(stringOut)
   if strcmp(stringOut(i),' ')
      stringOut(i) = '_'; 
   end
end


end

