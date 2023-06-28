function y = rect(t,Tw)
%RECT Sampled aperiodic rectangle generator.
%   RECT(T) generates samples of a continuous, aperiodic,
%   unity-height rectangle at the points specified in array T, centered
%   about T=0.  By default, the rectangle has width 1.
%
%   RECT(T,W) generates a rectangle of width W.
%

error(nargchk(1,2,nargin));
if nargin<2, Tw=1;   end

% Returns unity in interval [-Tw/2,+Tw/2)
t = abs(t);
h2 = Tw/2;
y = zeros(size(t));
y(t<h2) = 1.0;
y(t==h2) = 0.5;
