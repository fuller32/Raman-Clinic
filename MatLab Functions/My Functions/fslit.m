function [fy, fx] = fslit(Nf)


N=1024;
D=32;

k=-N/2:N/2-1;
x = (D/N)*k;
dx = x(2)-x(1);

f = qchirp(x,Nf).*rect(x/2);

xrange = 2;
idx=find(abs(x)<xrange);
subplot(2,1,1);
plot(x(idx),imag(f(idx)),'b',x(idx),real(f(idx)),'k','LineWidth',1.5);
axis([-xrange xrange -1.5 1.5]);
xlabel('x/w');
ylabel('f(x)');

z = fftshift(fft(fftshift(f)))*dx;
%fx = (1/D)*k/sqrt(Nf);
fx = (1/D)*k;
fy = z.*conj(z);
if (Nf<1)
    fy = 0.25*fy;
else
    fy = fy*Nf;
    fx = fx/Nf;
end


frange=2;
idx = find(abs(fx)<frange);
subplot(2,1,2);
%plot(fx(idx),fr(idx),'k',fx(idx),fi(idx),'b','LineWidth',1.5);
plot(fx(idx),fy(idx),'k','LineWidth',1.5);
%axis([-frange frange 0 1.0]);
if (Nf<1)
    xlabel('x/b');
else
    xlabel('x/w');
end
ylabel('|F|^2');