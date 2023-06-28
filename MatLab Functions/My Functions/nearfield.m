%% near-field calculations 
% convolution via Fourier Transform


%% nearfield example
% Test recovery of original input (infinite Fresnel number)

N=1024;
D=32;
invNf=0;

k=-N/2:N/2-1;
x = (1/D)*k;
dx = x(2)-x(1);

g = rect(x/2);
gf = fftshift(fft(fftshift(g)))*dx;

f = gf.*qchirp(fx,-invNf);

z = fftshift(ifft(fftshift(f)))*dx*N;
x = (D/N)*k;
y = z.*conj(z);

xrange=2;
idx = find(abs(x)<xrange);
plot(x(idx),y(idx),'k','LineWidth',1.5);
axis([-xrange xrange 0 1.2]);
xlabel('x/w');
ylabel('irradiance');

%% example1 (infinite Fresnel number)

nslit(0);

%% Nf = 100

nslit(1/100);

%% Nf = 10

nslit(1/10);

%% Nf = 1

nslit(1);

%% Nf = 0.1;

nslit(10);

%% compare Nf = 1

ncompare(1);

%% compare Nf = 10

ncompare(10);

%% exact vs. near-field 

Nf = 50;

% near field calculation
nslit(1/Nf);

% direct calculation
subplot(2,1,1);
slit(Nf);






