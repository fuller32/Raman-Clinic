function [P,Pi]= findpeak(RS,v,d)
%For a given array of Raman shift data (RS) you can find                  %
%the pixel value (P) of a given Raman shift (v), as well as the array of  % 
%pixels associated with a 10cm-1 region aroudn the peak.                  %

if nargin < 3
    d=5;
end


for n = 1:length(RS)
    if RS(n)>=(v-d) & RS(n)<=(v+d)
        p(n)=1;
    else
        p(n)=0;
    end
end

Pi = find(p,n);

if rem(length(Pi),2) == 1
    P = median(Pi);
else 
    Pf = floor(median(Pi));
    Pc = ceil(median(Pi));
    if abs(v-RS(Pf))<abs(v-RS(Pc))
        P=Pf;
    else
        P=Pc;
    end
end

end