%% cfuncs

%% rect function
func_plot(@rect,1);

%% gaus function
func_plot(@gaus,3);

%% tri function
func_plot(@tri,2);

%% sinc function
func_plot(@sinc,5,0.5);

%% somb function
func_plot(@somb,5,0.5);

%% step function
func_plot(@ustep,2);

%% inline/anonymous function 
test = @(t) t.*exp(-t.^2).*ustep(t);
% func_plot(test,2)
gf = @(t) 4.5*test(t-1) - 2*test((1-t)/2);
func_plot(gf,5,1);