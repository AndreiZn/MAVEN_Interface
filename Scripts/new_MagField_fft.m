function [message, error] = new_MagField_fft (ax, filefolderpath, date, start_time, stop_time, specific_args)
    
    new_figure = specific_args{1,2};
    
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
        choose_ind = find(mf_epoch>timefrom & mf_epoch<timeto);
        mf_epoch = mf_epoch(choose_ind);
        mf_data = mf_data(choose_ind, :);

        B = [mf_data(:, [8 9 10]), sqrt(sum(mf_data(:, [8 9 10]).^2, 2))];

        P2 = abs(fft(B(:, 4)))/length(mf_epoch);
        P1 = P2(1:length(mf_epoch)/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = 32*(0:(length(mf_epoch))/2)/length(mf_epoch);
        if new_figure == 1          
            figure()
        else
            axes(ax)
        end    
        loglog(f, P1)
        %title('18:37:30 - 18:41:15')
        title([start_time, ' - ', stop_time])
        xlabel('f, Hz')
        ylabel('|P1(f)|')
        grid on
        xlim([f(1) f(end)])
    end
    
function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'mag';
    chosenfunc = 'MagField_B';
    extensions = {{'', '.mat',}; {'', '.sts'}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts')      
    