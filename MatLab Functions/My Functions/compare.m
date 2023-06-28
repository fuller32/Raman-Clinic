function compare(Nf)

% far field calculation
[fy fx] = fslit(Nf);
% direct calculation
[y x] = slit(Nf);
idx = find(abs(fx)<2.0);
subplot(1,1,1);
plot(fx(idx),fy(idx),'b',x,y,'k','LineWidth',1.5);
grid;
title(sprintf('Nf = %g',Nf));
if (Nf<1)
    xlabel('x/b');
    ylabel('normalized irradiance');
else
    xlabel('x/w');
    ylabel('irradiance');
end
fxmax = max(abs(fx));
if (fxmax<2.0)
    fprintf('maximum FFT extent: %g\n',fxmax)
end