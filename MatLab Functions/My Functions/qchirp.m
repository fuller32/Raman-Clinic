function y=qchirp(x,a)
%QCHIRP  exp(j*pi*x.*x) function.
%       
error(nargchk(1,2,nargin));
if nargin<2, 
	y=exp(j*pi*x.*x);
else
  y = exp(j*pi*a*x.*x);
   end


