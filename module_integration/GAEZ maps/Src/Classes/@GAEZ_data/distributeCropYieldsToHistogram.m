function [ obj ] = distributeCropYieldsToHistogram( obj, landMatrix_hectares, landMatrix_hectares_excludingBiodiversityHotspots )
%DISTRIBUTECROPYIELDSTOHISTOGRAM Summary of this function goes here
%   Detailed explanation goes here

lessOrEqualToVector = [ 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 100];

%dataMatrix = obj.dataMatrix_raw'; %Transposing tif matrix to get lon as rows and lat as cols
%dataMatrix = dataMatrix*obj.multiplicationFactor; %Multiply to get tons/year
dataMatrix = obj.dataMatrix_lonXlat_multiplicationFactorAccounted;

mSize = size(dataMatrix);
mSize_landMatrix = size(landMatrix_hectares);

%Error check
if mSize_landMatrix ~= mSize
    error('Matrix not same size.')
end


%% MAIN
histogramVector_hectares(length(lessOrEqualToVector)) = 0;
histogramVector_tonsPerYear(length(lessOrEqualToVector)) = 0;


for i = 1:mSize(1) %lon
    for j = 1:mSize(2) %lat
        if landMatrix_hectares(i,j) > 0
            pos = 1;
            for k = 2:length(lessOrEqualToVector)
                
                if dataMatrix(i,j) > lessOrEqualToVector(k-1)
                    pos = k;
                end
                
                
            end
            histogramVector_hectares(pos) = histogramVector_hectares(pos) + landMatrix_hectares(i,j);
            histogramVector_tonsPerYear(pos) = histogramVector_tonsPerYear(pos)+ dataMatrix(i,j)*landMatrix_hectares(i,j);
        end
    end
end

obj.cropYield_identifiedLands_histogram_ha = histogramVector_hectares;
obj.cropYield_identifiedLands_histDescription_tonsPerYear_lessEqual = lessOrEqualToVector;
obj.cropYields_identifiedLands_histogram_outputOfType_tonsPerYear = histogramVector_tonsPerYear;

%% No biodiversity hotspots
histogramVector_noBH_hectares(length(lessOrEqualToVector)) = 0;
histogramVector_noBH_tonsPerYear(length(lessOrEqualToVector)) = 0;



for i = 1:mSize(1) %lon
    for j = 1:mSize(2) %lat
        if landMatrix_hectares_excludingBiodiversityHotspots(i,j) > 0
            pos = 1;
            for k = 2:length(lessOrEqualToVector)
                
                if dataMatrix(i,j) > lessOrEqualToVector(k-1)
                    pos = k;
                end
                
                
            end
            histogramVector_noBH_hectares(pos) = histogramVector_noBH_hectares(pos) + landMatrix_hectares_excludingBiodiversityHotspots(i,j);
            histogramVector_noBH_tonsPerYear(pos) = histogramVector_noBH_tonsPerYear(pos)+ dataMatrix(i,j)*landMatrix_hectares_excludingBiodiversityHotspots(i,j);
        end
    end
end

obj.cropYield_iLands_excludBH_histogram_ha = histogramVector_noBH_hectares;
obj.cropYield_iLands_excludBH_histDescription_tonsPerYear_lessEqual = lessOrEqualToVector;
obj.cropYields_iLands_excludBH_histogram_outputOfType_tonsPerYear = histogramVector_noBH_tonsPerYear;


end

