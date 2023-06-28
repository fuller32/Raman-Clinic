w = 0.7:0.02:0.9;

DATA=cell(1,4);
DATA{1,1}=DA2dataI1;
DATA{1,2}=DA2dataI2;
DATA{1,3}=DA2dataI3;
DATA{1,4}=DA2dataI4;

I=[1.03 0.75 0.50 0.21];

colors = {'k' 'r' 'b' 'g'};

mastercurve1 = [];

mastercurves(1:length(w))=struct('sample',[],...
        'Iwt',[],'conversion',[],'w',[]);

for i = 1:length(w)
    figure; hold on
    title(['w = ' num2str(w(i))]);
    for j = 1:4
        iwt = I(j)^w(i)*DATA{j}(:,1);
        alpha = DATA{j}(:,2);
        data1 = [iwt alpha];
        mastercurve1 = [mastercurve1; data1];
        myscatter(iwt,alpha,8,colors{j},'o');
        pause;
    end
    [mastercurve1(:,1),inds] = sort(mastercurve1(:,1));
    mastercurve1(:,2) = mastercurve1(inds,2);
    mastercurves(i).Iwt = mastercurve1(:,1);
    mastercurves(i).conversion = mastercurve1(:,2);
    mastercurves(i).w = w(i);
end

clear i j data1 mastercurve1 colors iwt alpha inds
% in the end, you have I, w, DATA, mastercurves


