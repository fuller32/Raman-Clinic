function [I]= removeoutliers(I,N)
[n m] = size(I);
Istd = std(I')';
Im =mean(I')';

if nargin < 2
    N=3;
end
% if nargin == 2
%     n=n
% end
for i=1:m;
    for ii = 1:n;
        if abs(Im(ii)-I(ii,i)) >= N*Istd(ii); 
            if i-1==0;
            I(ii,i) = I(ii,i+1);
            elseif i+1>m;
            I(ii,i) = I(ii,i-1);
            else
            I(ii,i) = (I(ii,i-1)+I(ii,i+1))/2;    
    end
    end
end
end