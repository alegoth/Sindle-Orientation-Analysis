function [da,divnb,removedcell]=removeFoundCell(gred,DivisionArray,Ttocorrect,n,divnb,removedcell)


h=figure; imshow(gred(:,:,Ttocorrect));
found = ginput(n);

da=DivisionArray{:,Ttocorrect};
da.Centroid(da.Centroid==0)=+inf;
dsa = pdist2(found,da.Centroid);
dsa=dsa';
indxfound=dsa==(min(dsa));
    for i=1:n
        
        da.FoundCell(indxfound(:,i))=1;
        removedcell=cat(2,removedcell,Ttocorrect);
    end
    
divnb=divnb-n;
close(h)
end
