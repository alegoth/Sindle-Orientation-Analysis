function [exportarray]=writeexportarray(divnb,x1,x2,DivisionArray)
%%Writing down the table called exportarray to export Time, Orientation and
%%position of the division

    Orientationex=zeros(divnb,1);
    Centroidex=zeros(divnb,2);
    Timepointex=zeros(divnb,1);
    exportarray=table(Timepointex,Centroidex,Orientationex);
    divexp=0;
for fortime=x1:x2
    tabletime= DivisionArray{1,fortime};
    div=find(tabletime.DividingCell);
    nbdiv=length(div);
    
    for currentdiv = 1:nbdiv
        labelcurrentdiv=div(currentdiv);
        conditionexport=tabletime.DividingCell(labelcurrentdiv)==1 & tabletime.FoundCell(labelcurrentdiv)==0;
      if conditionexport==1
         divexp=divexp+1;
         exportarray.Orientationex(divexp,:)=tabletime.Orientation(labelcurrentdiv);
         exportarray.Centroidex(divexp,:)=tabletime.Centroid(labelcurrentdiv,:);
         exportarray.Timepointex(divexp,:)=fortime;
      end
    end
end
end