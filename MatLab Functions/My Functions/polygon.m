function z = polygon(x,y,p)


if nargin<3
    p = [ -1 0; 1 0; 0 1.5 ];
end

n = size(p,1);
z = ones(size(x));
for i=1:n,
    u = p(mod(i,n)+1,:) - p(i,:);
    v = p(mod(i+1,n)+1,:) - p(i,:);
if ((u(1)*v(2)-u(2)*v(1))<0) 
    u = -u;
end
s = u(1)*(y-p(i,2))-u(2)*(x-p(i,1));
z = z.*(s>0);
end