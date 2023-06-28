%% Diffraction of Square Aperture

%% Fraunhoffer pattern

func = @(x,y) rect(x/2).*rect(y/2);

[out inp] = fdiffract(func,0);

%%

subplot(1,2,2);
imshow(out);
title(sprintf('maximum value %g\n',max(max(out))));

%%

out = fdiffract(func,0.1);
title(sprintf('maximum value %g\n',max(max(out))));

%% Nf = 4

out = fdiffract(func,4);

%% Nf = 2

out = fdiffract(func,2);

%% Nf = 1;

out = fdiffract(func,1);