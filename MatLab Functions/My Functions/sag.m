function z = sag(c,r,k,a4,a6,a8,a10)
if nargin <3
    z = (c.*r.^2)./(1+sqrt(1-(c.^2).*(r.^2)));
elseif nargin <4
    z = (c.*r.^2)./(1+sqrt(1-(k+1).*(c.^2).*(r.^2)));
elseif nargin <5
    z = (c.*r.^2)./(1+sqrt(1-(k+1).*(c.^2).*(r.^2)))+a4.*r.^4;
elseif nargin <6
    z = (c.*r.^2)./(1+sqrt(1-(k+1).*(c.^2).*(r.^2)))+a4.*r.^4+a6.*r.^6;
elseif nargin <7
    z = (c.*r.^2)./(1+sqrt(1-(k+1).*(c.^2).*(r.^2)))+a4.*r.^4+...
        a6.*r.^6+a8.*r.^8;
elseif nargin <8
    z = (c.*r.^2)./(1+sqrt(1-(k+1).*(c.^2).*(r.^2)))+a4.*r.^4+...
        a6.*r.^6+a8.*r.^8+a10.*r.^10;
end
