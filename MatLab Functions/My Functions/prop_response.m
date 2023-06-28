function [y, x] = prop_response(Nf)

%a=10;

N=1600;
D=4;

x=linspace(-1,1,N+1)*D;
dx = x(2)-x(1);

[cc2,ss2] = fresnel(sqrt(2*Nf)*(x+dx/2));
[cc1,ss1] = fresnel(sqrt(2*Nf)*(x-dx/2));


f = (1/sqrt(2*Nf))*complex(cc2-cc1,ss2-ss1)/dx;
%f = qchirp(x,Nf);


xrange = D;
subplot(2,1,1);
%plot(x,z,'k','LineWidth',2);
plot(x,imag(f),'b',x,real(f),'k','LineWidth',2);
%axis([-xrange xrange -1.5 1.5]);
xlabel('x');
ylabel('f(x)');

g = rect(x/2);
z = convn(g,f,'same')*(sqrt(Nf)*dx);
y = z.*conj(z);

if (Nf<1)
    y = y/4;
end

subplot(2,1,2);
xrange = 2;
idx = find(abs(x)<xrange);
plot(x(idx),y(idx),'k'); %,'LineWidth',2);
