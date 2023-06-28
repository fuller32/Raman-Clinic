%% 2D Gaussian

%% meshplot

[x,y]=meshgrid(linspace(-4,4,51));
r = sqrt(x.*x+y.*y);
z = gaus(r);
mesh(x,y,z);

%% surface plot 

surf(x,y,z,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
daspect([5 5 1]);
view(-50,30);
camlight left;

%% contour plot

contour(x,y,z);
axis square;

%% image plot

imshow(z);

%% resize image

imshow(imresize(z,10));

%% gaus(x)

close all;
z = gaus(x);
mysurf(x,y,z);

%% skewed gaussian line
% use the view control to make the plot look like the slide.

z = gaus(x+1.2*y);
mysurf(x,y,z);

