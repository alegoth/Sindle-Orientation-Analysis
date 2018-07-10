% The aim of this script is to find the spindles and return the nulber of division over time
%and their orientation. Some manual corrections are required but you don't
%need to segment your movie. To learn how to use it please read the readme
%attached, or read the comments on each script.
clearvars
close all
%%
path = dir('*.tif');  %You need to be on the folder containing your images
namefile = '141228_EcadGFP_JupRFP_Series02_t'; % Name of the file without timepoint                                            
nfile = size(path,1); %Find the number of .tif in the folder
Probfolder= 'Reduced/'; %Subfolder in wich you have the Ilastik generated probability mask.
Probsuffix= '_Probabilities.h5'; %Suffix of the probability mask.
%% Retrieve already defined parameters
load 'Results\Parameters.mat'
%% Defining parameters
%This step overwrite the parameters already loaded, be careful.
    resX= 1191; % x resolution of your image
    resY= 1475; % y resolution of your image
    MinAreaDividingThreshold = 200; %Need to train on some images to find the good parameter
    MaxAreaDividingThreshold = 800; %This two parameters are the minimum and maximum value respectively in which stands the real spindles.
    IntensityThreshold = 0.1; %Spindles are expected to have high intensity, so remove everything dimmer than this value (0<value<1)
    Parameccent=0.85; %Spindles are very eccentric structures, we keep the structures with eccentricity >
    Ecadchannel=1; %Channel you want to use as the backround in your image
    Jupchannel=2; %Channel used to find the spindles
    Thresholdfactor=2; %Threshold applied to the segmentation mask, generally between 1 and 2
    searchingfactor=2; %Multiplication factor for searching distance (n*MinorAxisLength);
    x1=1; %Initial timepoint (enter 1 for t000, 2 for t001 ...)
    x2=15; %can be nfile for all the files
  %% Create the spindle mask
  [gred,Labelst0,compmovie,ggreen]=spindlemask(namefile,Ecadchannel,Jupchannel,Probfolder,Thresholdfactor,resX,resY,nfile,x1,x2,Probsuffix,'none'); %Last argument = avi if u want to save the movie
%% Visualising the segmenation mask

figure, implay(compmovie);

%% Find all the structures that correspond to dividing cells
[DivisionArray,StatArray]=finddiv(x1,x2,Labelst0,gred,Parameccent,MinAreaDividingThreshold,MaxAreaDividingThreshold,IntensityThreshold);
%% Visualising Result
% x1;    %If you want to visualize a particular range of time point change x1
% x2;    % and x2, but it will be changed for the rest of the script

[M]= visualisingdividingcell(x1,x2,DivisionArray,StatArray,gred,'none');
%% User modification
% Allow the correction of missed divisions. You just need to clic on the
% spindle that has been missed. Structures that have been detected as
% spindles but are not, can be deleted later on.
Ttocorrect=213; %Timepoint you want to correct
ntocorrect=1; %Number of spindle you need to correct
if ~exist('addedcell')
    addedcell=[];
end
[DivisionArray{Ttocorrect},addedcell]=correctDividingCell(gred,DivisionArray,StatArray,Ttocorrect,ntocorrect,addedcell);
disp('Corrected')


%% Linking the different divisions

[DivisionArray,divnb]=linkingdiv(x1,x2,DivisionArray,searchingfactor);

%% Visualising result as ellipse around dividing cells

[N]=visualisingfoundcell(DivisionArray,x1,x2,gred,'none');
%% User modification
% Allow the correction of wrong results. You just need to clic on the
% spindle that are either detected twice, or not detected at all.
Ttocorrect=213; %Timepoint you want to correct
ntocorrect=1; %Number of spindle you need to correct
if ~exist('removedcell')
    removedcell=[];
end
[DivisionArray{Ttocorrect},divnb,removedcell]=correctFoundCell(gred,DivisionArray,StatArray,Ttocorrect,ntocorrect,divnb,removedcell);
disp('Corrected')
%% Write expotarray
[exportarray]=writeexportarray(divnb,x1,x2,DivisionArray);
%% Visualising result as bar for all the cells found
% x1=1; %Enter the range of timepoint you want to display (from x1 to x2);
% x2=nfile;
tbackground=3; %Enter the timepoint used as background.
Heatmap=1; % 1 Display a heatmap depending on the angle, 0 display the heatmap depending on time
barplot(ggreen,tbackground,x1,x2,DivisionArray,Heatmap,'spring') %The last argument is the heatmap used
%% Save all the results

if ~exist('Results','dir')
    mkdir('Results');
end

writetable(exportarray,'Results\Division orientation.csv');
save('Results\Parameters.mat','MinAreaDividingThreshold','MaxAreaDividingThreshold','IntensityThreshold','Parameccent'...
        ,'Thresholdfactor','searchingfactor','resX','resY','Jupchannel','x1','x2','divnb');
if exist('addedcell')
    addedcell=array2table(addedcell);
    writetable(addedcell,'Results\addedcell');
end
if exist('removedcell')
    removedcell=array2table(removedcell);
    writetable(removedcell,'Results\removedcell');
end
save('Results\DivisionArray','DivisionArray');

disp('Saved')
