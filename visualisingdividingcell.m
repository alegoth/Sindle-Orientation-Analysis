function [M]= visualisingdividingcell(x1,x2,DivisionArray,StatArray,gred,mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%First visualisation of the result of Spindle_orientation2. All the     %%
%%spindle are circle by an ellipse and a green * shows all the objects   %%
%%that could have been classified as 'spindle' (DividingCell in          %%
%%Divisiontable).                                                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (strcmp(mode,'avi'))
%# create AVI object
nFrames = x2-x1+1;
vidObj = VideoWriter('Results\dividingcell.avi');
% vidObj.Quality = 100;
vidObj.FrameRate = 15;
open(vidObj);
end

for o = x1:x2
    
       DivArray=DivisionArray{1,o};
       SArray=StatArray{1,o};
     dividingcelllabels2=find(DivArray.DividingCell==1);
                phi = linspace(0,2*pi,50);
                cosphi = cos(phi);
                sinphi = sin(phi);
                
%       figure, imshow(gred(:,:,o),[])
        imshow(gred(:,:,o),[])
            hold on   
        if length(dividingcelllabels2)==0;
            plot(SArray.Centroid(:,1),SArray.Centroid(:,2),'g*');
        else
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

                plot(SArray.Centroid(:,1),SArray.Centroid(:,2),'g*');
                plot(x(:,:,celln),y(:,:,celln),'r','LineWidth',2);
            end
        end
        hold off
        if (strcmp(mode,'avi'))
        writeVideo(vidObj, getframe(gca));
        end
        M(o)=getframe(gcf);
end
implay(M);
end   
    
   