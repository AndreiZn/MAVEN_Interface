function [message, error] = By_divided_by_Bz(ax, filefolderpath, date, start_time, stop_time, specific_args)
    
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
            day = [datestr(mf_data(averind,7), 'dd-mmm'), '-', num2str(mf_data(averind, 1))]; 
            timefrom = datenum([day, ' ', start_time]);
            timeto = datenum([day, ' ', stop_time]);

            mf_epoch = mf_data(:, 7) + datenum(['00-Jan-', num2str(mf_data(1, 1)), ' 00:00:00']);
            choose_ind = find(mf_epoch>=timefrom & mf_epoch<=timeto);
            mf_epoch = mf_epoch(choose_ind);
            mf_data2 = mf_data(choose_ind, :);

            By = mf_data2(:, 9);
            Bz = mf_data2(:, 10);

            axes (ax); 

            plot(mf_data2(:,7), By./Bz, 'linewidth', 0.5)

            datetick('x','HH:MM:SS');
            ylabel('B_y/B_z')
            grid on
            set (ax, 'fontsize', 8);

            xlim_min = [datestr(mf_data(averind,7), 'dd-mmm'), '-0000', ' ', start_time]; %04-Jan-0000 18:39:00
            xlim_max = [datestr(mf_data(averind,7), 'dd-mmm'), '-0000', ' ', stop_time]; %04-Jan-0000 18:43:00
            xlim([datenum(xlim_min) datenum(xlim_max)])
        end
        
    elseif strcmp(file_type, 'sql')
        
        conn = database.ODBCConnection('NASHE-VSIO','','');
        time_year = date(8:11);
        timefrom = datenum([date, ' ', start_time]);
        timeto = datenum([date, ' ', stop_time]);
        ddayfrom = num2str(timefrom - datenum(['00-Jan-', time_year, ' 00:00:00']));
        ddayto = num2str(timeto - datenum(['00-Jan-', time_year, ' 00:00:00']));
        sqlGetData = strcat(['SELECT OB_B_Y, OB_B_Z, DDAY FROM maven.mag where TIME_YEAR=', time_year,' and DDAY>=', ddayfrom,' and DDAY<=', ddayto]);
        curs = exec(conn,sqlGetData); %curs = exec(conn,'SELECT * from maven.key_parameters');
        curs = fetch(curs);
        table = curs.Data;
        close (curs);
        
        By = [table{:,1}]; Bz = [table{:,2}];
        dday = [table{:,3}];
        
        axes(ax); 

        plot(dday, By./Bz, 'linewidth', 0.5)

        datetick('x','HH:MM:SS');
        ylabel('B_y/B_z, nT')
        grid on
        set (ax, 'fontsize', 8);
        
        xlim_min = datenum([date(1:7), '0000', ' ', start_time]);
        xlim_max = datenum([date(1:7), '0000', ' ', stop_time]);
        xlim([xlim_min, xlim_max])
        
        message = '';%['"', files_final, '"', ' was successfully uploaded and the system is ready to plot ', chosenfunc];
        error = '0_no_error';
        
    end 
    
function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'mag';
    chosenfunc = 'By_divided_by_Bz';
    extensions = {{'', '.mat',}; {'', '.sts'}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts')  