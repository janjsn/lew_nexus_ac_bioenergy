function createHistogram_energyYields( histogramMatrix_hectare, histogramMatrix_noBH_hectare,noYield,noBH_noYield,bounds, cropTypeNames, filename4export )
%Function to create energy yield histograms 
%Only input filename if it is the intention to save the figure to file
%Jan Sandstad Næss, 07.01.2020

if nargin < 5
    export = 0;
elseif nargin == 5
   export = 1; 
end

%% Convert to million hectare
histogramMatrix_hectare = histogramMatrix_hectare'*10^-6;
histogramMatrix_noBH_hectare = histogramMatrix_noBH_hectare'*10^-6;

%% Check and make matrix sizes
mSize = size(histogramMatrix_hectare);
mSize_2 = [mSize(1)+1 ((mSize(2)))*2];
n_crops = mSize(2);

%ERROR CHECK
if length(bounds) <= mSize(2)
    error('Bounds do not cover all of histogram matrix. Check input.')
    
elseif length(bounds) > mSize(2)+1
    
    
end

%% Create legend labels
for i = 1:length(cropTypeNames)
   legendLabels{i} = [cropTypeNames{i}]; 
   legendLabels{1+i+length(cropTypeNames)} = [cropTypeNames{i} ' BH'];
end
legendLabels{length(cropTypeNames)+1} = 'No potential';
legendLabels{length(legendLabels)+1} = 'No potential  BH';
legend(string(legendLabels), 'Location', 'northeast');

%% Create x-axis labels
c=2;
labels{1} = '0';
for i = 2:length(bounds)
labels{c} = [num2str(bounds(i-1)) '-' num2str(bounds(i))];
c=c+1;
end




%% Make figure
figure1 = figure;

w1 = 0.75;
w2 = 0.5;
matrix_allLand = zeros(mSize(1)+1,mSize(2)+1);
matrix_allLand(1,end) = noYield*10^-6;
matrix_allLand(2:end,1:end-1) = histogramMatrix_hectare;
matrix_bh_land = zeros(mSize(1)+1,mSize(2)+1);
matrix_bh_land(1,end) = (noYield-noBH_noYield)*10^-6;
matrix_bh_land(2:end,1:end-1) = histogramMatrix_hectare-histogramMatrix_noBH_hectare;
alpha(1)
bar_all = bar(matrix_allLand, w1,'stacked', 'FaceColor','flat');

hold on
%grid on

bar_bh = bar(matrix_bh_land, w2, 'stacked', 'LineStyle', '-', 'LineWidth', 0.5,'FaceColor','flat');
hold off
alpha(bar_all,0.85)

%legend(string(legendLabels(1:n_crops+1)), 'Location', 'northwest','Orientation','vertical');
xticklabels(labels);
xtickangle(45);
ylabel('Million hectares')
xlabel('GJ/hectare')

%% Set colormap
if n_crops == 3
%     bar_all(1).FaceColor = [79/255 110/255 195/255];
%     bar_all(2).FaceColor = [241/255 206/255 118/255];
%     bar_all(3).FaceColor = [159/255 224/255 155/255];
%     bar_all(4).FaceColor = [1 1 0];
%     
%     bar_bh(1).FaceColor = [79/255 110/255 195/255];
%     bar_bh(2).FaceColor = [241/255 206/255 118/255];
%     bar_bh(3).FaceColor = [159/255 224/255 155/255];
%     bar_bh(4).FaceColor = [1 1 0];

    bar_all(1).FaceColor = [0.9290 0.6940 0.1250];
    bar_all(2).FaceColor = [0.4660 0.6740 0.1880];
    bar_all(3).FaceColor = [0 0.4470 0.7410];
    bar_all(4).FaceColor = [1 1 0];
    
    bar_bh(1).FaceColor = [0.9290 0.6940 0.1250];
    bar_bh(2).FaceColor = [0.4660 0.6740 0.1880];
    bar_bh(3).FaceColor = [0 0.4470 0.7410];
    bar_bh(4).FaceColor = [1 1 0];
end


if export == 1
    %timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
    
    %Checking name of folder
    for chars = length(filename):-1:1
        if strcmp(filename(chars),'/')
           outputFolder = filename(1:chars); 
           break
        end
        if chars == 1
           outputFolder = '/'; 
        end
    end
    
    if exist(outputFolder,'dir') ~= 7
        mkdir(outputFolder);
    end
    
    saveas(figure1,filename);
    close all 
    clear('figure1')
    
    fprintf(['Energy yield histogram figure saved to: ' filename '\n']);
end

end

