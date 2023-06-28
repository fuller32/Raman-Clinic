%% function prop_movie(a,nframes)


clear
Nf = 20;
nframes = 20;

N=1600;
D=4;

aviobj = avifile('propx.avi','fps',2);

x=linspace(-1,1,N+1)*D;
dx = x(2)-x(1);

[cc2,ss2] = fresnel(sqrt(2*Nf)*(x+dx/2));
[cc1,ss1] = fresnel(sqrt(2*Nf)*(x-dx/2));


f = (1/sqrt(2*Nf))*complex(cc2-cc1,ss2-ss1)/dx;
%f = qchirp(x,Nf);



z = rect(x/2);
for n=0:nframes
    if (n==0)
        z = rect(x/2);
    else
        z = convn(z,f,'same')*(sqrt(Nf)*dx);
    end
    y = z.*conj(z);


    xrange = 2;
    idx = find(abs(x)<xrange);
    plot(x(idx),y(idx),'k','LineWidth',1.5);
    axis([-xrange xrange 0 2]);
    %frame = getframe(gcf);
    aviobj = addframe(aviobj,getframe);
end

aviobj = close(aviobj);
