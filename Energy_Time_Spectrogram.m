function Energy_Time_Spectrogram(ax, start_time, stop_time, filename, specific_args)
    
    eflux = spdfcdfread(filename, 'variables', 'eflux');
    nenergy = spdfcdfread(filename, 'variables', 'nenergy');
    energy = spdfcdfread(filename, 'variables', 'energy');
    swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
    epoch = spdfcdfread(filename, 'variables', 'epoch');
    
    start_str = start_time; stop_str = stop_time; %save str version of start, stop times
    %time 
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
    start_time = find (difference == min(difference), 1);
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
    stop_time = find (difference == min(difference), 1);
    
    tft = [start_time stop_time];
    eflux_disp = squeeze(sum(eflux(:, :, tft(1):tft(2)), 1));
    
    axes(ax);
    
    pcolor(repmat(epoch(tft(1):tft(2))', nenergy, 1), energy(:,swp_ind(tft(1):tft(2))+1,1), log10(eflux_disp));
    verify = eflux_disp~=0;
    colordata = [min(min(log10(eflux_disp(verify)))), max(max(log10(eflux_disp(verify))))];
    caxis(colordata)
    
    shading flat
    grid on
    set (gca, 'YScale', 'log', 'tickdir', 'out', 'ticklength', [0.003 0.1], 'fontsize', 7);
    ylabel('Energy', 'fontsize', 8)
    datetick('x', 'HH:MM:SS')
    
    %xlim
    averind = round(size(epoch, 1)/2);
    day = datestr(epoch(averind), 'dd-mmm-yyyy');
    t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
    xlim([datenum(t1), datenum(t2)])