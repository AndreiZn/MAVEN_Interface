function Magnetic_Field_Slow(ax, start_time, stop_time, filename, specific_args)
    
    mf_filename = filename;
    %mf_data = dlmread(mf_filename, '', 145);
    mf_data=open(mf_filename);
    mf_data = mf_data.mf_data;
    %mf_data=mf_data{1};
    assignin('base', 'mf', mf_data);
    averind = round(size(mf_data, 1)/2); 
    day = [datestr(mf_data(averind,7), 'dd-mmm'), '-', num2str(mf_data(averind, 1))]; 
    timefrom = datenum([day, ' ', start_time]);
    timeto = datenum([day, ' ', stop_time]);

    mf_epoch = mf_data(:, 7) + datenum(['00-Jan-', num2str(mf_data(1, 1)), ' 00:00:00']);
    choose_ind = find(mf_epoch>=timefrom & mf_epoch<=timeto);
    mf_epoch = mf_epoch(choose_ind);
    mf_data2 = mf_data(choose_ind, :);

    Bx = mf_data2(:, 8);
    By = mf_data2(:, 9);
    Bz = mf_data2(:, 10);
    B = sqrt(Bx.^2 + By.^2 + Bz.^2);
    
    axes (ax); 
    
    plot(mf_data2(:,7), Bx, 'color', 'red', 'linewidth', 2)
    hold on
    plot(mf_data2(:,7), By, 'color', 'green', 'linewidth', 2)
    plot(mf_data2(:,7), Bz, 'color', 'blue', 'linewidth', 2)
    plot(mf_data2(:,7), B, 'color', 'black', 'linewidth', 2)

    legendhndl = legend('B_x', 'B_y', 'B_z', 'B');
    
    datetick('x','HH:MM:SS');
    ylabel('B, nT')
    grid on
    set (ax, 'fontsize', 8);
    
    xlim_min = [datestr(mf_data(averind,7), 'dd-mmm'), '-0000', ' ', start_time]; %04-Jan-0000 18:39:00
    xlim_max = [datestr(mf_data(averind,7), 'dd-mmm'), '-0000', ' ', stop_time]; %04-Jan-0000 18:43:00
    xlim([datenum(xlim_min) datenum(xlim_max)])
    