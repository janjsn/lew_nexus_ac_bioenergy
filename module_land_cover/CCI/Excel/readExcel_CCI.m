function NC_fileArray = readExcel( excelFile, sheetname_nc, sheetname_classes )
%Reading excel input
%   Detailed explanation goes here

[num,txt,raw] = xlsread(excelFile, sheetname_nc);

mSize = size(raw);

%Counting number of files input in the correct way

firstInputRow = 5;
yearCol = 2;
filenameCol = 3;
importGivenDataCol = 4;

nFiles = 0;
nFilesForImport = 0;

yearsVector = NaN;
posVector = NaN;

for i = firstInputRow:mSize(1)
   if isnumeric(raw{i,yearCol}) && mod(raw{i,yearCol},1) == 0 %Years are formatted correct?
       if ischar(raw{i,filenameCol}) %Filename is char?
           nFiles = nFiles + 1;
           if raw{i,importGivenDataCol} == 1
               %File should be imported
               nFilesForImport = nFilesForImport+1;
               if isnan(yearsVector)
                  yearsVector = raw{i,yearCol};
                  posVector = i;
               else
                   yearsVector(length(yearsVector)+1) = raw{i,yearCol};
                   posVector(length(posVector)+1) = i;
               end %if
           end %if
           
       end %if
   end %if
end %for

%Preallocation
NC_fileArray(length(posVector)) = NC_files;
%Getting data
for i = 1:length(posVector) 
    NC_fileArray(i).year = raw{posVector(i),yearCol};
    NC_fileArray(i).filename = raw{posVector(i),filenameCol};
end %for

%Printing action
fprintf(num2str(nFiles)) ;
fprintf(' files was identified with input in the correct format. \n') ;
fprintf(num2str(nFilesForImport)) ;
fprintf(' files was chosen for data import. \n');  

if ~isnan(yearsVector) %Checking if yearsVector is empty or not.
    fprintf('The following years will be imported: ')
    for i = 1:length(yearsVector)
        fprintf(num2str(yearsVector(i)));
        if i == length(yearsVector)
           fprintf('. \n'); 
        else
        fprintf(', ');
        end
    end
end

end

