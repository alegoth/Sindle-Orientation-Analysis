function [N]=visualisingfoundcell(DivisionArray,x1,x2,gred,mode)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Visualising the result of Spindle_orientation2. For each timepoint an  %%
%%elipse is drawn around the found spindle and a green * is ploted for   %%
%%each already found spindle.                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (strcmp(mode,'avi'))
%# create AVI object
nFrames = x2-x1+1;
vidObj = VideoWriter('Results\foundcell.avi');
% vidObj.Quality = 100;
vidObj.FrameRate = 15;
open(vidObj);
end

for o=x1:x2
    DivArray=DivisionArray{1,o};
     dividingcelllabels2=find(DivArray.DividingCell==1);
                phi = linspace(0,2*pi,50);
                cosphi = cos(phi);
                sinphi = sin(phi);


      imshow(gred(:,:,o))
            hold on          
        for celln=1:length(dividingcelllabels2)
            cellname=dividingcelllabels2(celln);

            xbar = DivArray.Centroid(cellname,1);
            ybar = DivArray.Centroid(cellname,2);

            a = DivArray.MajorAxisLength(cellname);
            b = DivArray.MinorAxisLength(cellname);

            theta = pi*DivArray.Orientation(cellname)/180;
            R = [ cos(theta)   sin(theta)
                 -sin(theta)   cos(theta)];

            xy = [a*cosphi; b*sinphi];
            xy = R*xy;
            clear x y;
            x(:,:,celln) = xy(1,:) + xbar;
            y(:,:,celln) = xy(2,:) + ybar;

                if DivArray.FoundCell(cellname)
                    plot(DivArray.Centroid(:,1),DivArray.Centroid(:,2),'g*');
                else
                    plot(DivArray.Centroid(:,1),DivArray.Centroid(:,2),'g*');
                    plot(x(:,:,celln),y(:,:,celln),'r','LineWidth',2);
                end
        end
        hold off
        if (strcmp(mode,'avi'))
        writeVideo(vidObj, getframe(gca));
        end
        N(o)=getframe(gcf);

end
implay(N);
end