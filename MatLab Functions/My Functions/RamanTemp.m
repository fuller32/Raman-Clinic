function T = RamanTemp(I,RS,v,W,C)
w = floor(W/2);

if nargin < 5
    C = 1;
end

for i=1:length(v)
    S(i) = findpeak(RS,v(i));
end

for i=1:length(v)
    AS(i) = findpeak(RS,-1*v(i));
end

IS = C*sum(I(S-w:S+w,:));
IAS = sum(I(AS-w:AS+w,:));

l_o = 808e-9;

v_o = 3e8/l_o;
v_R = v.*100.*3e8;

g = IS./IAS;

p = ((v_o+v_R)./(v_o-v_R)).^3;


K = 1.3807e-23;;
h = 6.6261e-34;
To = (h.*v_R)./K;

[n nn] = size(g);
for i= 1:n
T(i,:) = To(i).*(log(g(i,:).*p(i))).^-1;
end
T = T-273.15;
