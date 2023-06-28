function [f,x] =slit(Nf)
%% SLIT diffraction
%
%  Nf is Fresnel number

N=800;
D=4;

x = linspace(-1,1,N+1)*D/2;

if (Nf<1)
  [cc2,ss2] = fresnel(sqrt(2/Nf)*(Nf-x));
  [cc1,ss1] = fresnel(sqrt(2/Nf)*(Nf+x));
else
  [cc2,ss2] = fresnel(sqrt(2*Nf)*(1.0-x));
  [cc1,ss1] = fresnel(sqrt(2*Nf)*(1.0+x));
end

z = sqrt(1/(2*j))*complex(cc2+cc1,ss2+ss1);


f = z.*conj(z);

if (Nf<1)
    f = (0.25/Nf)*f;
end


plot(x,f,'k');
str = sprintf('Fresnel number %g',Nf);
title(str);
% if Nf<1
%     text(0.5,0.6,str);
% else
%     text(-0.5,0.3,str);
% end
%axis([-xrange xrange 0 1.5]);
%xlabel('x');
%ylabel('E(x)');
