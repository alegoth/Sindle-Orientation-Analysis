%The aim here is to track the spindle over time to ount it only at the
%first timepoint. The tracking is realized backward, starting from the last
%timepoint. To be consider has the same spindle, the distance between the
%spindle of two consecutive images is determine by "searchingfactor".
%Moreover, The script looks not only between two consecutive timepoint, but
%also two timepoint ahead.
function [DivisionArray,divnb]=linkingdiv(x1,x2,DivisionArray,searchingfactor)

tic
divnb=0;

for revtime=x2:-1:(x1+2)
    table2prevtime=DivisionArray{1,revtime-2};
    tableprevtime = DivisionArray{1,revtime-1};
    tabletime= DivisionArray{1,revtime};
    div=find(tabletime.DividingCell);
    nbdiv=length(div);
    cent=tableprevtime.Centroid;
    prevdiv=find(tableprevtime.DividingCell);
    nbprevdiv=length(prevdiv);
    prev2div=find(table2prevtime.DividingCell);
    cent2=table2prevtime.Centroid;
    nb2prevdiv=length(prev2div);
    
    for currentdiv = 1:nbdiv
        
        labelcurrentdiv=div(currentdiv);
        searchingdist=searchingfactor*tabletime.MinorAxisLength(labelcurrentdiv);
        
        for searchedprevdiv=1:nbprevdiv
            
            labelprevdiv=prevdiv(searchedprevdiv);
            conditiondistance=norm(cent(labelprevdiv,:)-tabletime.Centroid(labelcurrentdiv,:))<= searchingdist;
            
            if  conditiondistance %tableprevtime.DividingCell(labelprevdiv)
                
                tabletime.FoundCell(labelcurrentdiv)=1;
                %             disp(strcat('Already found cell',num2str(labelcurrentdiv),'correspond to',num2str(labelprevdiv)));
            else
                %             disp(strcat('Not foud for cell',num2str(labelcurrentdiv)));
            end
        end
        
        conditionexport=tabletime.DividingCell(labelcurrentdiv)==1 & tabletime.FoundCell(labelcurrentdiv)==0;
        if conditionexport==1
            for searched2prevdiv=1:nb2prevdiv
                label2prevdiv=prev2div(searched2prevdiv);
                conditiondistance=norm(cent2(label2prevdiv,:)-tabletime.Centroid(labelcurrentdiv,:))<= searchingdist;
                
                if  conditiondistance %tableprevtime.DividingCell(labelprevdiv)
                    
                    tabletime.FoundCell(labelcurrentdiv)=1;
                    %             disp(strcat('Already found cell',num2str(labelcurrentdiv),'correspond to',num2str(labelprevdiv)));
                end
            end
        end
        conditionexport=tabletime.DividingCell(labelcurrentdiv)==1 & tabletime.FoundCell(labelcurrentdiv)==0;
        if conditionexport==1
            divnb=divnb+1;
        end
    end
    DivisionArray{:,revtime}=tabletime;
end

revtime=x1+1;
tableprevtime = DivisionArray{1,revtime-1};
tabletime= DivisionArray{1,revtime};
div=find(tabletime.DividingCell);
nbdiv=length(div);
cent=tableprevtime.Centroid;
prevdiv=find(tableprevtime.DividingCell);
nbprevdiv=length(prevdiv);

for currentdiv = 1:nbdiv
    
    labelcurrentdiv=div(currentdiv);
    searchingdist=2*tabletime.MinorAxisLength(labelcurrentdiv);
    
    for searchedprevdiv=1:nbprevdiv
        
        labelprevdiv=prevdiv(searchedprevdiv);
        conditiondistance=norm(cent(labelprevdiv,:)-tabletime.Centroid(labelcurrentdiv,:))<= searchingdist;
        
        if  conditiondistance %tableprevtime.DividingCell(labelprevdiv)
            
            tabletime.FoundCell(labelcurrentdiv)=1;
            %             disp(strcat('Already found cell',num2str(labelcurrentdiv),'correspond to',num2str(labelprevdiv)));
        else
            %             disp(strcat('Not foud for cell',num2str(labelcurrentdiv)));
        end
    end
    
    conditionexport=tabletime.DividingCell(labelcurrentdiv)==1 & tabletime.FoundCell(labelcurrentdiv)==0;
    if conditionexport==1
        divnb=divnb+1;
        
    end
end
DivisionArray{:,revtime}=tabletime;
divnb=divnb+nbprevdiv;

toc