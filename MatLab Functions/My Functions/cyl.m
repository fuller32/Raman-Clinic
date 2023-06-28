function z = cyl(x,y,d)
%CYL Sampled aperiodic cylindrical step.
%   CYL(X,Y) generates samples of a continuous, aperiodic,
%   unity-height cylinder at the points specified in array (X,Y)
%   about X=Y=0.  By default, the cylinder has diameter 1.
%
%   CYL(X,Y) is a cylinder of height 1 and diameter 1
%   CYL(X,Y,D) is a cylinder of diameter d
%

error(nargchk(2,3,nargin));
if nargin<3, d=1; end

r = sqrt(x.*x+y.*y);
z = zeros(size(r));
z(r<d/2)=1.0;
z(r==d/2)=0.5;
