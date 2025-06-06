function ncompare(Nf)

% near field calculation
[fy fx] = nslit(1/Nf);
% direct calculation
[y x] = slit(Nf);
idx = find(abs(fx)<2.0);
subplot(1,1,1);
plot(fx(idx),fy(idx),'b',x,y,'k','LineWidth',1.5);
if (Nf<1)
    xlabel('x/b');
    ylabel('normalized irradiance');
else
    xlabel('x/w');
    ylabel('irradiance');
end
