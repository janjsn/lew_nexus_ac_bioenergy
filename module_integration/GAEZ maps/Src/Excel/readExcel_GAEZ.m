function GAEZ_fileArray = readExcel_GAEZ( excelFile, sheetname_gaez )
%Reading excel input
%   Detailed explanation goes here

[num,txt,raw] = xlsread(excelFile, sheetname_gaez);

mSize = size(raw);

%Counting number of files input in the correct way

firstInputRow = 5;
cropnameCol = 2;
filenameCol = 3;
filename_cropWaterDeficitCol = 4;
uniqueIDCol = 5;
isAscFileCol = 6;
isTifFileCol = 7;
importGivenDataCol = 8;
multiplicationFactorCol = 9;
cropIDCol = 10;
yearCol = 11;
climateScenarioIDCol = 12;
irrigatedCol = 13; 
inputRateCol = 14;
co2FertilizationCol = 15;

nFiles = 0;
nFilesForImport = 0;

yearsVector = NaN;
posVector = NaN;

%Some error checks
for i = firstInputRow:mSize(1)
   if ischar(raw{i,cropnameCol})  %Cropname is char ?
       if ischar(raw{i,filenameCol}) %Filename is char?
           if isnumeric(raw{i,isAscFileCol}) && isnumeric(raw{i,isTifFileCol})
               if isnumeric(raw{i,multiplicationFactorCol})
                   nFiles = nFiles + 1;
                   if raw{i,importGivenDataCol} == 1
                       %File should be imported
                       nFilesForImport = nFilesForImport+1;
                       if isnan(posVector)
                           
                           posVector = i;
                       else
                           
                           posVector(length(posVector)+1) = i;
                       end %if
                   end %if
               end %if
           end
       end %if
   end %if
end %for

%Printing action
fprintf(num2str(nFiles)) ;
fprintf(' files was identified with input in the correct format. \n') ;
fprintf(num2str(nFilesForImport)) ;
fprintf(' files was chosen for data import. \n');  

%Preallocation
GAEZ_fileArray(length(posVector)) = GAEZ_files;
%Getting data
folderPathway_string = raw{1,8};

for i = 1:length(posVector) 
    GAEZ_fileArray(i).cropname = raw{posVector(i),cropnameCol};
     currentFilename = [folderPathway_string raw{posVector(i),filenameCol}];
     GAEZ_fileArray(i).filename = currentFilename;
     GAEZ_fileArray(i).filename_waterDeficit = [folderPathway_string raw{posVector(i),filename_cropWaterDeficitCol}];
    GAEZ_fileArray(i).uniqueID = raw{posVector(i),uniqueIDCol};
    GAEZ_fileArray(i).multiplicationFactor = raw{posVector(i),multiplicationFactorCol};
    GAEZ_fileArray(i).isAscFile = raw{posVector(i),isAscFileCol};
    GAEZ_fileArray(i).isTifFile = raw{posVector(i),isTifFileCol};
    GAEZ_fileArray(i).cropID = raw{posVector(i),cropIDCol};
    GAEZ_fileArray(i).year = raw{posVector(i),yearCol};
    GAEZ_fileArray(i).climateScenario_ID = raw{posVector(i),climateScenarioIDCol};
    GAEZ_fileArray(i).isIrrigated_binary = raw{posVector(i),irrigatedCol};
    
    if GAEZ_fileArray(i).isIrrigated_binary == 1
        GAEZ_fileArray(i).isRainfed_binary = 0;
    else
        GAEZ_fileArray(i).isRainfed_binary = 1;
    end
    
    GAEZ_fileArray(i).inputRate = raw{posVector(i),inputRateCol};
    GAEZ_fileArray(i).considersCO2Fertilization_binary = raw{posVector(i),co2FertilizationCol};
    
end %for



% if ~isnan(yearsVector) %Checking if yearsVector is empty or not.
%     fprintf('The following years will be imported: ')
%     for i = 1:length(yearsVector)
%         fprintf(num2str(yearsVector(i)));
%         if i == length(yearsVector)
%            fprintf('. \n'); 
%         else
%         fprintf(', ');
%         end
%     end
% end

end

