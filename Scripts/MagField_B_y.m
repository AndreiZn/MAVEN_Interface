function [message, error] = MagField_B_y (ax, filefolderpath, date, start_time, stop_time, specific_args)
    
    file_type = specific_args{1,1};
    
    if strcmp(file_type, 'mag')
        
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
            day = datestr(mf_data(averind,7) + datenum(['00-Jan-', num2str(mf_data(1, 1)), ' 00:00:00']), 'dd-mmm-yyyy');
            timefrom = datenum([day, ' ', start_time]);
            timeto = datenum([day, ' ', stop_time]);

            mf_epoch = mf_data(:, 7) + datenum(['00-Jan-', num2str(mf_data(1, 1)), ' 00:00:00']);
            choose_ind = find(mf_epoch>=timefrom & mf_epoch<=timeto);
            mf_epoch = mf_epoch(choose_ind);
            mf_data2 = mf_data(choose_ind, :);

            By = mf_data2(:, 9);

            axes (ax); 

            plot(mf_data2(:,7), By, 'linewidth', 0.5)

            datetick('x','HH:MM:SS');
            ylabel('B_y, nT')
            grid on
            set (ax, 'fontsize', 8);

            xlim_min = [datestr(mf_data(averind,7), 'dd-mmm'), '-0000', ' ', start_time]; %04-Jan-0000 18:39:00
            xlim_max = [datestr(mf_data(averind,7), 'dd-mmm'), '-0000', ' ', stop_time]; %04-Jan-0000 18:43:00
            xlim([datenum(xlim_min) datenum(xlim_max)])
        end
        
    elseif strcmp(file_type, 'sql')
        
        cd('../Aux_Fncs')
        vars = feval('read_from_sql', '', '', 'maven.mag', {'OB_B_Y'}, date, start_time, stop_time);
        cd('../Scripts')
        
        vars = cell2mat(vars); % from cell to double
        data_to_plot = [vars(:,1), vars(:,2)]; % get two-column data to plot
        
        cd('../Aux_Fncs')
        feval('plot_from_sql', ax, data_to_plot, 'B_y, nT', date, start_time, stop_time);
        cd('../Scripts')
        
        message = '';%['"', files_final, '"', ' was successfully uploaded and the system is ready to plot ', chosenfunc];
        error = '0_no_error';
        
    end
    
function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'mag';
    chosenfunc = 'MagField_B_y';
    extensions = {{'', '.mat',}; {'', '.sts'}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts')  
           