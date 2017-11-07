function [message, error] = new_MagField_fft_spec (ax, filefolderpath, date, start_time, stop_time, specific_args)
    
    window_size = round(str2double(specific_args{1, 2}));
    new_figure = specific_args{1,3};
    
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
        spectrogram = zeros(window_size/2+1, size(B, 1)-window_size);
        for i=1:size(B, 1)-window_size
            Y = fft(B(i:i+window_size-1, 4));
            spectrogram(:, i) = Y(1:window_size/2+1);
        end
        
        if new_figure == 1          
            figure()
        else
            axes(ax)
        end   
        
        x = mf_epoch(window_size/2:size(mf_epoch, 1)-window_size/2-1);
        y = 32*(0:(window_size/2))/window_size;
        pcolor(x, y, log(abs(spectrogram/window_size)))
        datetick('x','HH:MM:SS');
        xlim([x(1) x(end)])
        shading flat
        colorbar
        colormap(jet)
        xlabel('UT, HH:MM:SS')
        ylabel('Frequency, Hz')
        set(gca, 'yscale', 'log')

        %====накладываем гирочастоты
        B_mean = smooth(B(:, 4), window_size)*1e-9;
        aem = 1.67e-27;
        q = 1.6e-19;
        mass = [1, 16, 32];
        freq_c = zeros(size(B_mean, 1), length(mass));
        for i = 1:length(mass)
            freq_c(:, i) = q*B_mean./(aem*mass(i));
        end

        hold on
        for i=1:length(mass)
            plot(mf_epoch, freq_c(:, i), 'color', 'blue')
        end
        %=====================
        B_mean = smooth(B(:, 4), window_size)*1e-9;
        aem = 1.67e-27;
        q = 1.6e-19;
        mass = [1, 16, 32];
        freq_c = zeros(size(B_mean, 1), length(mass));
        for i = 1:length(mass)
            freq_c(:, i) = q*B_mean./(2*pi*aem*mass(i));
        end

        hold on
        for i=1:length(mass)
            plot(mf_epoch, freq_c(:, i), 'color', 'green')
        end
        hold off
    end    
    
function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'mag';
    chosenfunc = 'MagField_B';
    extensions = {{'', '.mat',}; {'', '.sts'}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts')      
        