function out = logim(image,decades,vref)
%LOGIM  Image with logarithmic compression
%		out = logim(image,D);
%	produces an output image compressed to D decades.
%	D must be a non-negative integer (default 4).
%	If D is zero, no compression is performed, but the image
%	is scaled to a maximum value of 1.0.
%
%		out = logim(image,D,vref);
%	divides the input image by vref rather than scaling it to 1.0
%
%	If no output assignment is made, the output is displayed.

% Author: John S. Loomis (8 March 2000)

if nargin < 3
   vref = max(image(:));
end
if nargin < 2
    decades = 4;
end

image = image / vref;

if decades <= 0
    % truncate negative values
    v = image.*(image>0);
else
    t = 10^-decades;
    v = image.*(image>=t) + (image<t)*t;
    v = 1 + log10(v)/decades;
end

if nargout == 0
    imshow(v);
else
    out = v;
end


