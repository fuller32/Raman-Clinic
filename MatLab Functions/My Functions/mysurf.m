function mysurf(x,y,z)
%
surf(x,y,z,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
daspect([5 5 1]);
view(-50,30);
camlight left;
