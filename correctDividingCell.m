%This script is used to correct the missed spindle. The user mnually select
%the spindle that has been missed.
function [da,addedcell]=correctDividingCell(gred,DivisionArray,StatArray,Ttocorrect,n,addedcell)


h=figure; imshow(gred(:,:,Ttocorrect));
newcell = ginput(n);

da=DivisionArray{:,Ttocorrect};
sa=StatArray{:,Ttocorrect};
dsa = pdist2(newcell,sa.Centroid);
dsa=dsa';
indxnc=dsa==(min(dsa));

for i=1:n
    da.Area(indxnc(:,i))=sa.Area(indxnc(:,i));
    da.Centroid(indxnc(:,i),:)=sa.Centroid(indxnc(:,i),:);
    da.MajorAxisLength(indxnc(:,i))=sa.MajorAxisLength(indxnc(:,i));
    da.MinorAxisLength(indxnc(:,i))=sa.MinorAxisLength(indxnc(:,i));
    da.Eccentricity(indxnc(:,i))=sa.Eccentricity(indxnc(:,i));
    da.Orientation(indxnc(:,i))=sa.Orientation(indxnc(:,i));
    da.Intensity(indxnc(:,i))=sa.NormalisedIntensity(indxnc(:,i));
    da.DividingCell(indxnc(:,i))=1;
    addedcell=cat(2,addedcell,Ttocorrect);
end
close(h)
end
