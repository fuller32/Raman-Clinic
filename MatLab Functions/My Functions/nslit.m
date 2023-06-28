function [y, x] = nslit(invNf)


N=1024;
D=32;

k=-N/2:N/2-1;
[x,y] = meshgrid(linspace(-D/2,D/2,N));
dx = x(2)-x(1);

% we coult precompute qf since we know the answer
g = rect(x/2);
gf = fftshift(fft(fftshift(g)))*dx;
%gf = 2*sinc(2*x);

fx = (D/N)*k;
f = gf.*qchirp(fx,-invNf);

xrange =N/(2*D);
subplot(2,1,1);
plot(fx,imag(f),'b',fx,real(f),'k','LineWidth',1.5);
axis([-xrange xrange -1.5 2]);
xlabel('\xi w');
ylabel('f(\xi w)');

z = fftshift(ifft(fftshift(f)))*(N*dx);

y = z.*conj(z);
if (invNf>1)
    y = y*(invNf/4);
    x = x/invNf;
end


xrange=2;
idx = find(abs(x)<xrange);
subplot(2,1,2);
%plot(fx(idx),fr(idx),'k',fx(idx),fi(idx),'b','LineWidth',1.5);
plot(x(idx),y(idx),'k','LineWidth',1.5);
%axis([-frange frange 0 1.0]);
if (invNf>1)
    xlabel('x/b');
else
    xlabel('x/w');
end
ylabel('|F|^2');