function [rs I_] = LF_Background(RS,I)

x = [findpeak(RS,-200) findpeak(RS,0) findpeak(RS,200)];
[a b ] = size(I);
rs = RS(x(3):x(1));

for n = 1:b
    p = polyfit(RS(x),I(x,n),2);
    y(:,n) = polyval(p,rs);
end
I_ =  I(x(3):x(1),:)-y;
end