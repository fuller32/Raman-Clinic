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
        %Updated 6/28/2023
        %Have the save function set to version -7.3 to allow for variables of size
        %>=2GB. Needs to be a 64 bit machine to work so check has been added.
        comp = mexext;
        if 1 == strcmp(comp,'mexw64')
            save('input.mat','g','-v7.3');
        else
            disp("Your machine is 32-bit and may have issues with saving matlab variables greater then 2GB")
            save('input.mat','g');
        end
        close all;
        test=1;
        load('input.mat','g')
        Db = eval(g);
        if 1 == strcmp(comp,'mexw64')
            save('input2.mat','Db','-v7.3');
        else
            disp("Your machine is 32-bit and may have issues with saving matlab variables greater then 2GB")
            save('input2.mat','Db');
        end
        prompt = {'File Name'};
        dlgtitle = 'Input';
        dims = [1 35];
        phi=0;
        definput = {''};
        Name = inputdlg(prompt,dlgtitle,dims,definput);
        Name=string(Name);
        load('input2.mat','Db')

        if 1 == strcmp(comp,'mexw64')
            save(Name,'Db','-v7.3');
        else
            disp("Your machine is 32-bit and may have issues with saving matlab variables greater then 2GB")
            save(Name,'Db');
        end
        delete('input.mat')
        delete('input2.mat')
    end
end