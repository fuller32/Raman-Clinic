function func_plot(func,xr,yr)
% func_plot plots a specified function
%   xr is the domain of the plot: -xr < x < xr
%   yr is the range of the plot:  -yr < y < 1+yr  
%
if (nargin<3)
    yr = 0.2;
end
x = linspace(-xr,xr,101);
y = func(x);
plot(x,y,'k','linewidth',2);
hold on
x2 = linspace(-xr,xr,21);
y2 = func(x2);
plot(x2,y2,'ko');
grid;
axis([-xr xr -yr 1+yr]);
hold off
