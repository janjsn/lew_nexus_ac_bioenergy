classdef LandUseTransition
    %LANDUSETRANSITION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        description %'string
        fractionMatrix_original
        areaMatrix_original_m2
        totalArea_original_m2
        latitudeVector_original
        longitudeVector_original
        nRows_original_lon
        nCols_original_lat
        areaPerLatitudeVector_original
        indexVector_positionsOfChangesInFractionMatrix
        indexedVector_identifiedChanges_fractions
        indexedVector_areaPerCellOfIdentifiedChanges_m2
        
        nRows_newAggregated_lon
        nCols_newAggregated_lat
        fractionMatrix_newAggregated
        areaMatrix_newAggregated_m2
        latitudeVector_newAggregated
        longitudeVector_newAggregated
        areaPerLatitudeVector_newAggregated
        
        totalArea_newAggregated_m2;
        
        
    end
    
    methods
        %% Constructor
        function obj = LandUseTransition(fractionMatrix_changes, latitudeVector, longitudeVector)
           tic
            fprintf('Constructing new land use transition object. \n ');
            
            
           obj.fractionMatrix_original =  fractionMatrix_changes;
           obj.latitudeVector_original = latitudeVector;
           obj.longitudeVector_original = longitudeVector;
           
           mSize = size(fractionMatrix_changes);
           
           if mSize(1) ~= length(longitudeVector)
               error('Check longitude/row dimensions of matrix/vectors.')
           elseif mSize(2) ~= length(latitudeVector)
                error('Check latitude/column dimensions of matrix/vectors.')
           end
           
           obj.nRows_original_lon = length(longitudeVector);
           obj.nCols_original_lat = length(latitudeVector);
           
           %% Finding area per latitude vector
           obj.areaPerLatitudeVector_original(obj.nCols_original_lat) = 0; %prealloc
           longitude1 = obj.longitudeVector_original(1);
           longitude2 = obj.longitudeVector_original(2);
           
           earthellipsoid = referenceSphere('earth', 'm');
           surface_area_earth_m2 = areaquad(-90,-180,90,180,earthellipsoid);
           
           %Calculating area per quadrangle
           for i = 2:length(obj.areaPerLatitudeVector_original)
               obj.areaPerLatitudeVector_original(i-1) = areaquad(obj.latitudeVector_original(i-1),longitude1,obj.latitudeVector_original(i),longitude2);
               obj.areaPerLatitudeVector_original(i-1) = obj.areaPerLatitudeVector_original(i-1)*surface_area_earth_m2;
           end
           
           obj.areaPerLatitudeVector_original(end) = obj.areaPerLatitudeVector_original(1);
           
           %% Finding indexed vectors
           obj.indexVector_positionsOfChangesInFractionMatrix = find(obj.fractionMatrix_original > 0);
           obj.indexedVector_identifiedChanges_fractions = obj.fractionMatrix_original(obj.indexVector_positionsOfChangesInFractionMatrix);
           
           %% Estimating area per cell of indexed vector
           indexedVector_areaPerCellOfIdentifiedChanges_m2(length(obj.indexVector_positionsOfChangesInFractionMatrix)) = 0; %preallocation
           
           for i = 1:length(obj.indexVector_positionsOfChangesInFractionMatrix)
            [row_location, column_location] = ind2sub(mSize, obj.indexVector_positionsOfChangesInFractionMatrix(i));
            indexedVector_areaPerCellOfIdentifiedChanges_m2(i) = obj.areaPerLatitudeVector_original(column_location);
           end
           
           obj.indexedVector_areaPerCellOfIdentifiedChanges_m2 = indexedVector_areaPerCellOfIdentifiedChanges_m2;
           
           %Finding total area
           sumOfOriginalArea = 0;
           for i = 1:length(obj.indexedVector_areaPerCellOfIdentifiedChanges_m2)
               sumOfOriginalArea = sumOfOriginalArea + obj.indexedVector_areaPerCellOfIdentifiedChanges_m2(i)*obj.indexedVector_identifiedChanges_fractions(i);
           end
           obj.totalArea_original_m2 = sumOfOriginalArea;
           
           toc
        end %Constructor
        
        
        
        %% Aggregation function, create new object
        function obj = aggregateOriginalMatrix(obj, nRows_new_lon, nCols_new_lat)
            %% Aggregate original matrix
            fprintf('Aggregating original matrix with dimensions: ');
            mSize = size(obj.fractionMatrix_original);
            
            fprintf([num2str(mSize(1)) ' x ' num2str(mSize(2))]); 
            fprintf('. To dimensions: ');
             fprintf([num2str(nRows_new_lon) ' x ' num2str(nCols_new_lat)]); 
             fprintf('. \n ');
            
            [ obj.areaMatrix_newAggregated_m2, obj.fractionMatrix_newAggregated, obj.areaPerLatitudeVector_newAggregated, obj.latitudeVector_newAggregated, obj.longitudeVector_newAggregated] = obj.aggregateFractionsIndexVector2newDimIndexedVector_newSize_LUC( obj.indexedVector_identifiedChanges_fractions, obj.indexVector_positionsOfChangesInFractionMatrix, obj.indexedVector_areaPerCellOfIdentifiedChanges_m2, obj.areaPerLatitudeVector_original, obj.latitudeVector_original, obj.longitudeVector_original, obj.nRows_original_lon, obj.nCols_original_lat, nRows_new_lon, nCols_new_lat) ;
            obj.nRows_newAggregated_lon = nRows_new_lon;
            obj.nCols_newAggregated_lat = nCols_new_lat;
            obj.totalArea_newAggregated_m2 = sum(sum(obj.areaMatrix_newAggregated_m2));
        end
        
        %% Declare other functions
       [ newMatrix_m2, newMatrix_fractions, newAreaPerLatitudeVector, newLatitudeVector, newLongitudeVector] = aggregateFractionsIndexVector2newDimIndexedVector_newSize_LUC(obj, inIndexedDataVector, inIndexVector, inIndexedAreaPerCellVector_wholeCell_m2, inAreaPerLatitudeVector, inLatitudeVector, inLongitudeVector, oldNumberOfRows, oldNumberOfCols, newNumberOfRows, newNumberOfCols) 
        
        makeNcFile_newAggregatedResults(obj, filename)
        
        %Find box positions in matrices
        [ rows_lon, cols_lat ] = getBoxRowsColsFromLatLon_originalMatrix(  obj, latitude_N_deg, latitude_S_deg, longitude_W_deg, longitude_E_deg )
        [ rows_lon, cols_lat ] = getBoxRowsColsFromLatLon_newMatrix(  obj, latitude_N_deg, latitude_S_deg, longitude_W_deg, longitude_E_deg )
        
    end
    
end

