%Here we allow the user to make correction. Three options are available.
%Either a spindle has been found twice and you can delete the second. Or
%two spindle close to each other in space and time are detected as one, you
%can correct the second to be considered as one. Finally a spindle that has
%not been found at all can be added too. The user just need to clic on the
%spindle to modify.
function [da,divnb,removedcell]=correctFoundCell(gred,DivisionArray,StatArray,Ttocorrect,n,divnb,removedcell)

h=figure; imshow(gred(:,:,Ttocorrect));
found = ginput(n);

da=DivisionArray{:,Ttocorrect};
da.Centroid(da.Centroid==0)=+inf;
sa=StatArray{:,Ttocorrect};
dsa = pdist2(found,sa.Centroid);
dsa=dsa';
indxfound=dsa==(min(dsa));
    for i=1:n
        if da.FoundCell(indxfound(:,i))==0 & da.DividingCell(indxfound(:,i))==1
            da.FoundCell(indxfound(:,i))=1;
            removedcell=cat(2,removedcell,Ttocorrect);
            divnb=divnb-1;
        elseif da.FoundCell(indxfound(:,i))==1
            da.FoundCell(indxfound(:,i))=0;
            divnb=divnb+1;
        else
            da.Area(indxfound(:,i))=sa.Area(indxfound(:,i));
            da.Centroid(indxfound(:,i),:)=sa.Centroid(indxfound(:,i),:);
            da.MajorAxisLength(indxfound(:,i))=sa.MajorAxisLength(indxfound(:,i));
            da.MinorAxisLength(indxfound(:,i))=sa.MinorAxisLength(indxfound(:,i));
            da.Eccentricity(indxfound(:,i))=sa.Eccentricity(indxfound(:,i));
            da.Orientation(indxfound(:,i))=sa.Orientation(indxfound(:,i));
            da.Intensity(indxfound(:,i))=sa.NormalisedIntensity(indxfound(:,i));
            da.DividingCell(indxfound(:,i))=1;
            da.FoundCell(indxfound(:,i))=0;
            divnb=divnb+1;
        end
    end 

close(h)
end
