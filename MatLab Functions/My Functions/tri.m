function y = tri(t)
%TRI Sampled aperiodic triangle generator.
%   TRI(T) generates samples of a continuous, aperiodic,
%   unity-height triangle at the points specified in array T, centered
%   about T=0. 

% Returns non-zero in interval [-1,+1)
t = abs(t);
y = zeros(size(t));
idx = find(t<1.0); 
y(idx)=1.0-t(idx);

