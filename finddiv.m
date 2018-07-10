%In this script we read the segmentation generated previously and evaluate
%if the characteristics (area, eccentricity and intensity) of each structure correspond to those of a spindle. 
function [DivisionArray,StatArray]=finddiv(x1,x2,Labelst0,gred,Parameccent,MinAreaDividingThreshold,MaxAreaDividingThreshold,IntensityThreshold)

    for Time = x1:x2
    % % Create the table
    %---------------------------
        nLabels = max(max(Labelst0(:,:,Time))); %Determine the number of element that will fill the table. 
                                  %i.e the number of "spindle" detected

        Label=zeros(nLabels,1);
        Centroid=zeros(nLabels,2);
        DividingCell=Label;
        FoundCell=Label;
        MajorAxisLength=Label;
        MinorAxisLength=Label;
        NormalisedIntensity=Label;
        Eccentricity=Label;
        Area=Label;
        Orientation=Label;
        Intensity=Label;
        divisiontable = table(Label,Centroid,Area,MajorAxisLength,MinorAxisLength,Orientation,Eccentricity,Intensity,DividingCell,FoundCell);

    % %Characteristics of the cells in the stack:
        %------------------------------------------
        clear('stats')  
        stats = regionprops('table',Labelst0(:,:,Time), gred(:,:,Time),'PixelIdxList', 'Orientation','Centroid','Area','Eccentricity','MajorAxisLength','MinorAxisLength','MeanIntensity');
    %  writetable(stats)
            maxIntensitystack=max(stats.MeanIntensity);
            stats.NormalisedIntensity=stats.MeanIntensity/maxIntensitystack; %We add a field to the structure with the normalised intensity

            dimstats = size(stats);

            spindlenum=dimstats(1);
    %Loop each "spindle" to determine if it can be the good structure. If yes
    %write its characteristic (stat) in 'divisiontable'.

        for k=1:spindlenum
            divisiontable.Label(k)=k;

             %Features to consider to classify:
                Eccentk = stats.Eccentricity(k);
    %             NIntenk = stats.NormalisedIntensity(k);
                Areak = stats.Area(k);
                Intk = stats.NormalisedIntensity(k);

            if (Eccentk>Parameccent)&&(Areak>MinAreaDividingThreshold)&&(Areak<MaxAreaDividingThreshold)&&(Intk>IntensityThreshold)
                    divisiontable.DividingCell(k)=1;
                    divisiontable.Centroid(k,:) = stats.Centroid(k,:);
                    divisiontable.Area(k)=Areak;
                    divisiontable.Eccentricity(k) = Eccentk;
                    divisiontable.Intensity(k)=Intk;
                    divisiontable.MajorAxisLength(k) = stats.MajorAxisLength(k);

                    divisiontable.MinorAxisLength(k) = stats.MinorAxisLength(k);

                    divisiontable.Area(k) = Areak;

                    divisiontable.Orientation(k) = stats.Orientation(k);
            end
        end
    % Store the results in an array to retrieve it next time       
        DivisionArray{1,Time} = divisiontable;
        StatArray{1,Time}=stats;

end   