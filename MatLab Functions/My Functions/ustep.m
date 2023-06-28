function y = ustep(t)
%STEP Sampled aperiodic step generator.
%   STEP(T) generates samples of a continuous, aperiodic,
%   unity-height step at the points specified in array T, centered
%   about T=0. 
%

y = zeros(size(t));
y(t>0)=1.0;
y(t==0)=0.5;