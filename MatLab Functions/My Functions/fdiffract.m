function [outp, inp, x, y] = fdiffract(func, Nf, range)

if nargin<3
    range = 4;
end


N=1024;
D=sqrt(N);
k = -N/2:N/2-1;
[xs,ys] = meshgrid(k*D/N);
dx = D/N;
dy = D/N;


f = func(xs,ys);
A = sum(sum(f))*dx*dy;

if (abs(Nf)>0)
    chirp=qchirp(xs,Nf).*qchirp(ys,Nf);
else
    chirp=ones(size(f));
end

xr = k/D;
idx = find( (-range <= xr) & (xr<range) );

inp = f(idx,idx);
if (nargout>1)
    subplot(1,2,1);
    imshow(inp);
    subplot(1,2,2);
else
    subplot(1,1,1);
end
x = xs(idx,idx);
y = ys(idx,idx);

z = fftshift(fft2(fftshift(f.*chirp)));
if (Nf<1)
    z = z*(dx*dy/A);
else
    z = z*(dx*dy*Nf);
end
fy = z.*conj(z);

if (Nf<1)
    idy =idx;
else
    idy = find((-range*Nf < xr) & (xr<range*Nf) );
end

outp = fy(idy,idy);

if (nargout>0)
    if (Nf<1)
        imshow(logim(outp,3));
    else
        imshow(outp/max(max(outp)));
    end
end