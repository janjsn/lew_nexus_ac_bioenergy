function [ newMatrix_m2, newMatrix_fractions, newAreaPerLatitudeVector, newLatitudeVector, newLongitudeVector] = aggregateFractionsIndexVector2newDimIndexedVector_newSize_LUC(obj, inIndexedDataVector, inIndexVector, inIndexedAreaPerCellVector_wholeCell_m2, inAreaPerLatitudeVector, inLatitudeVector, inLongitudeVector, oldNumberOfRows, oldNumberOfCols, newNumberOfRows, newNumberOfCols) 
%AGGREGATEFRACTIONSINDEXVECTOR2NEWFRACTIONINDEXEDVECTOR_NEWSIZE Summary of this function goes here
%   Detailed explanation goes here
tic
newMatrix_m2 = zeros(newNumberOfRows, newNumberOfCols);
newMatrix_fractions = zeros(newNumberOfRows, newNumberOfCols);

 %% ERROR CHECKS
    if oldNumberOfRows < newNumberOfRows || mod(oldNumberOfRows,newNumberOfRows)~= 0
      error('Check new number of Rows.')
      
    elseif oldNumberOfCols < newNumberOfCols || mod(oldNumberOfCols,newNumberOfCols)~= 0
      error('Check new number of Rows.')
    end

    resizeFactor_rows = oldNumberOfRows/newNumberOfRows;
    resizeFactor_cols = oldNumberOfCols/newNumberOfCols;
    
    %% ESTIMATIONS
    
%lon

newLongitudeVector = zeros(newNumberOfRows,1);
for i = 1:length(newLongitudeVector)
   newLongitudeVector(i) = inLongitudeVector(1+resizeFactor_rows*(i-1));
    %newLongitudeVector_westCorner(i) = temp +(i-1)*((longitudeVector_westCorner(1)-longitudeVector_westCorner(end))/length(newLongitudeVector_westCorner)); %!
end

%lat
newLatitudeVector = zeros(newNumberOfCols,1);
for i = 1:length(newLatitudeVector)
newLatitudeVector(i) = inLatitudeVector(1+resizeFactor_cols*(i-1));
end

%Finding area per latitude vector
newAreaPerLatitudeVector(newNumberOfCols) = 0; %prealloc
longitude1 = newLongitudeVector(1);
longitude2 = newLongitudeVector(2);

earthellipsoid = referenceSphere('earth', 'm');
surface_area_earth_m2 = areaquad(-90,-180,90,180,earthellipsoid);

%Calculating area per quadrangle
for i = 2:length(newAreaPerLatitudeVector)
    newAreaPerLatitudeVector(i-1) = areaquad(newLatitudeVector(i-1),longitude1,newLatitudeVector(i),longitude2);
    newAreaPerLatitudeVector(i-1) = newAreaPerLatitudeVector(i-1)*surface_area_earth_m2;
end

newAreaPerLatitudeVector(end) = newAreaPerLatitudeVector(1);


%Making new matrix
n_errors = 0;

accumulated_m2_nonWeighted = 0;
    
for i = 1:length(inIndexVector)
    currentIndex_old = inIndexVector(i);
  
        [row_location_oldMatrix, column_location_oldMatrix] = ind2sub([oldNumberOfRows oldNumberOfCols],currentIndex_old);
        
        %finding new location
        
        row_location_new = 1+(row_location_oldMatrix/resizeFactor_rows);
        %Checking if it's the last point of interest
        if mod(row_location_new,1) == 0
            row_location_new = row_location_new-1;
        else
            row_location_new = floor(row_location_new);
        end
        %Same for column
        column_location_new = 1+(column_location_oldMatrix/resizeFactor_cols);
        if mod(column_location_new,1) == 0
            column_location_new = column_location_new -1;
        else
            column_location_new = floor(column_location_new);
        end
        
        newMatrix_m2(row_location_new,column_location_new) = newMatrix_m2(row_location_new,column_location_new)+inIndexedDataVector(i)*inAreaPerLatitudeVector(column_location_oldMatrix);
        if inIndexedDataVector(i) > 0
        accumulated_m2_nonWeighted = accumulated_m2_nonWeighted + inAreaPerLatitudeVector(column_location_oldMatrix);
        end
        if inAreaPerLatitudeVector(column_location_oldMatrix) ~= inIndexedAreaPerCellVector_wholeCell_m2(i)
            n_errors = n_errors+1;
        end
        
end

%Finding fractions matrix
newMatrixSize = size(newMatrix_m2);
for i = 1:newMatrixSize(1)
    for j = 1:newMatrixSize(2)
        newMatrix_fractions(i,j) = newMatrix_m2(i,j)/newAreaPerLatitudeVector(j);
    end                                                                                                               
end

%n_errors
%accumulated_m2_nonWeighted
   toc 
end


