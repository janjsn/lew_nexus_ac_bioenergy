function [ obj ] = estimateGlobalYields( obj )
%ESTIMATEGLOBALYIELDS Summary of this function goes here
%   Detailed explanation goes here


temp = obj.dataMatrix_raw;



temp = temp*obj.multiplicationFactor;

obj.dataMatrix_estimated_sameLatLonSteps = temp;
obj.yieldsLargerThanZero_binaryMatrix = temp > 0;
obj.numberOfDatapointsWithYieldsHigherThanZero = sum(sum(temp));

mSize = size(temp);
for j = 1:mSize(1)
    temp(j,:) = temp(j,:)*obj.areaPerLatitudeVector_hectare(j);
end

obj.globalYields_estimated_tonPerYear = sum(sum(temp));


end

