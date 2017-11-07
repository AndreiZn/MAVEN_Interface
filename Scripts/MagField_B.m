function [message, error] = MagField_B (ax, filefolderpath, date, start_time, stop_time, specific_args)
    
    [mf_filename, message, error] = get_file(date, filefolderpath);
    
    if ~isempty(mf_filename)

        fileID=fopen(mf_filename,'r');
        tline = fgetl(fileID);
        headersNumber=0;
        while ~strcmp(tline(1:4),'  20')
            headersNumber=headersNumber+1;
            tline = fgetl(fileID);
        end
        frewind(fileID);
        tline = fgetl(fileID);
        fclose(fileID);
        mf_data = dlmread(mf_filename, '', headersNumber);

        averind = round(size(mf_data, 1)/2); 
        %day = [datestr(mf_data(averind,7), 'dd-mmm'), '-', num2str(mf_data(averind, 1))]; 
        day = datestr(mf_data(averind,7) + datenum(['00-Jan-', num2str(mf_data(1, 1)), ' 00:00:00']), 'dd-mmm-yyyy');
        timefrom = datenum([day, ' ', start_time]);
        timeto = datenum([day, ' ', stop_time]);

        mf_epoch = mf_data(:, 7) + datenum(['00-Jan-', num2str(mf_data(1, 1)), ' 00:00:00']);
        choose_ind = find(mf_epoch>=timefrom & mf_epoch<=timeto);
        mf_data2 = mf_data(choose_ind, :);

        Bx = mf_data2(:, 8);
        By = mf_data2(:, 9);
        Bz = mf_data2(:, 10);
        B = sqrt(Bx.^2 + By.^2 + Bz.^2);

        axes(ax); 

        plot(mf_data2(:,7), B, 'linewidth', 0.5)

        datetick('x','HH:MM:SS');
        ylabel('B, nT')
        grid on
        set (ax, 'fontsize', 8);

        xlim_min = [datestr(mf_data(averind,7), 'dd-mmm'), '-0000', ' ', start_time]; %04-Jan-0000 18:39:00
        xlim_max = [datestr(mf_data(averind,7), 'dd-mmm'), '-0000', ' ', stop_time]; %04-Jan-0000 18:43:00
        xlim([datenum(xlim_min) datenum(xlim_max)])

    end    
    
function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'mag';
    chosenfunc = 'MagField_B';
    extensions = {{'', '.mat',}; {'', '.sts'}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts')  
       