function By_divided_by_Bz(ax, start_time, stop_time, filename, specific_args)
    
    mf_filename = filename;
    if ~isempty(strfind(mf_filename, '.mat'))
        mf_data = open(mf_filename);
        mf_data = mf_data.mf_data;
    elseif ~isempty(strfind(mf_filename, '.sts'))        
        mf_data = dlmread(mf_filename, '', 300);
        %save([filename(1:numel(filename)-3), 'mat'], 'mf_data')
    end
    
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
    