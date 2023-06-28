function y =edge_fcn(x)

% a = lambda * z
% normalize to (x/sqrt(a))

a=1;

[cc,ss] = fresnel(sqrt(2/a)*x);

z = sqrt(1/(2*j))*complex(0.5+cc,0.5+ss);


y = z.*conj(z);
