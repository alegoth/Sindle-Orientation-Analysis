function barplot(ggreen,tbackground,x1,x2,DivisionArray,Heatmap,map)
%Visualising Result with a line drawn for each cell division
cm = colormap (map); % returns the current color map
figure, 
imshow(ggreen(:,:,tbackground),[])
               hold on 
o=0;
i=0;
while i~=1
    o=o+1;
    DivArray=DivisionArray{1,o};
    dividingcelllabels2=find(DivArray.DividingCell==1 & DivArray.FoundCell==0, 1);
    if ~isempty(dividingcelllabels2)
        i=1;
        a=DivArray.MajorAxisLength(dividingcelllabels2(1));
    end
end

for o=x1:x2
    DivArray=DivisionArray{1,o};
     dividingcelllabels2=find(DivArray.DividingCell==1 & DivArray.FoundCell==0);
%                 phi = linspace(0,2*pi,50);
%                 cosphi = cos(phi);
%                 sinphi = sin(phi);

    %   figure, imshow(Labelst0(:,:,Time));

        for celln=1:length(dividingcelllabels2)
            cellname=dividingcelllabels2(celln);

            xbar = DivArray.Centroid(cellname,1);
            ybar = DivArray.Centroid(cellname,2);
%             a=DivArray.MajorAxisLength(cellname);

%             %Draw a circle             
%             delta=linspace(0,2*pi); 
%             radius=10;
%             w = radius*cos(delta) + xbar;
%             z = radius*sin(delta) + ybar;

            %Gives a color depending on the angle
            gamma=DivArray.Orientation(cellname);
            graycolor=abs(gamma)/90;            
            colorID = max(1, sum(graycolor > [0:1/length(cm(:,1)):1])); 
            myColor = cm(colorID, :);

            %GIves a color depending on the time
            graycolort=o/x2;
            colorIDt= max(1, sum(graycolort > [0:1/length(cm(:,1)):1]));
            myColort= cm(colorIDt, :);
            
            %Draw a line 
            y=linspace(0,0,3);
            centxm=-a/2;
            centxp=+a/2;
            x=linspace(centxm,centxp,3);
            beta= pi*DivArray.Orientation(cellname)/180;
            xy=[x;y];

            %Rotate the line
            R = [ cos(beta)   sin(beta)
                  -sin(beta)   cos(beta)];

            rotxy=R*xy;
            rotx=rotxy(1,:)+xbar;
            roty=rotxy(2,:)+ybar;


                if Heatmap==1
                    %plot(DivArray.Centroid(:,1),DivArray.Centroid(:,2),'g');
                    plot(rotx,roty,'-','LineWidth',3,'Color',myColor);

                else
                    plot(rotx,roty,'-','LineWidth',3,'Color',myColort);
                    
%                     %plot(DivArray.Centroid(:,1),DivArray.Centroid(:,2),'g*');
% %                      plot(w,z,'w','LineWidth',2);
                end
        end
end
        hold off