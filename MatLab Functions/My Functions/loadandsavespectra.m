function loadandsavespectra
f = figure;
set(gcf,'Position',[100 100 200 200])

c = uicontrol(f,'Style','popupmenu','Position', [0 0 100 100]);
c.Position = [90 75 60 20];
c.String = {'read_BW_Tek_files','read_ocean_optics_files_V2',...
    'read_Ondax_files','read_Thermo_files','read_Horiba_files'};
 
c.Callback = @plotButtonPushed;

    function plotButtonPushed(src,event)
        val = c.Value;
        str = c.String;
        g = str{val};
        display(g)
        save('input.mat','g')
        close all;
        test=1;
        load('input.mat','g')
        Db = eval(g);
        save('input2.mat','Db')
        prompt = {'File Name'};
        dlgtitle = 'Input';
        dims = [1 35];
        phi=0;
        definput = {''};
        Name = inputdlg(prompt,dlgtitle,dims,definput);
        Name=string(Name);
        load('input2.mat','Db')
        save(Name,'Db')
        delete('input.mat')
        delete('input2.mat')
    end
end