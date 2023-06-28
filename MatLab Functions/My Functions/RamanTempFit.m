
function [Ts S] = RamanTempFit(Tr,l,d,n)

if nargin < 2
    l=5000;
end

if nargin < 3 | nargin < 2
    d=10;
end

[X Ts] = airPLS(Tr,l);
[n m] = max(Tr);
q = mean(Tr(m-d:m+d));
g = ones(1,length(Tr)).*std(Tr(m-d:m+d));
Ts = Ts+g;
S = sqrt((Tr-Ts).^2);

a = -1.*std(Tr(m-d:m+d));
b = 1.*std(Tr(m-d:m+d));


R = sum(S(:)<=mean(S))/(length(S));

for i = 1:n;
    
    if R < .8
      G = (b-a).*rand(1,1)+a;
      Ts_ = Ts+G';
      S_ = sqrt((Tr-Ts_).^2);
      R_ = sum(S_(:)<=mean(S_))/(length(S_));
      if R_>R
           Ts = Ts_;
           S = S_;
           R = R_;
      end
    end

end

end