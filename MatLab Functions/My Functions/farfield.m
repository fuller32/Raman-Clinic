%% farfield calculations (Fourier Transform)


%% far-field (Fraunhoffer) limit

N=1024;
D=32;

k=-N/2:N/2-1;
x = (D/N)*k;
dx = x(2)-x(1);

f = rect(x/2);

z = fftshift(fft(fftshift(f)))*dx;
fx = (1/D)*k;
fy = z.*conj(z)/4;

fprintf('maximum %g\n',max(fy));

frange=2;
idx = find(abs(fx)<frange);
subplot(1,1,1);
plot(fx(idx),fy(idx),'k','LineWidth',2);
grid;
%axis([-frange frange 0 1.0]);
xlabel('x/b');
ylabel('normalized irradiance');

%% Nf = 1

fslit(1);

%% Nf = 8

fslit(8);


%% compare Nf = 8

compare(8);

%% compare Nf = 12

compare(12);