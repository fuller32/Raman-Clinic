%%function n2compare(Nf)

Nf = 50;

% near field calculation
nslit(1/Nf);

% direct calculation
subplot(2,1,1);
slit(Nf);
