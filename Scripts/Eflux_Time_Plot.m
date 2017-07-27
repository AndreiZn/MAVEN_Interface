function Eflux_Time_Plot (ax, start_time, stop_time, filename, specific_args)
    
    mass = specific_args{1, 1};
    log = specific_args{1, 2};
    
    epoch = spdfcdfread(filename, 'variables', 'epoch');
    eflux = spdfcdfread(filename, 'variables', 'eflux');
    swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
    mass_arr = spdfcdfread(filename, 'variables', 'mass_arr');
    
    start_str = start_time; stop_str = stop_time; %save str version of start, stop times
    %time 
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
    start_time = find (difference == min(difference), 1);
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
    stop_time = find (difference == min(difference), 1);
    
    axes (ax);

    tft = [start_time stop_time];
    eflux_disp = eflux(:, :, tft(1):tft(2));

    d_mass = 1; %a.u. (accuracy)
    mass_num_range = find ((mass_arr(16, swp_ind(tft(1))+1, :)>mass-d_mass)&(mass_arr(16, swp_ind(tft(1))+1, :)<mass+d_mass));

    fdist = squeeze(sum(sum(eflux_disp(mass_num_range,:,:), 2), 1));
    
    if (log==1)
        semilogy(epoch(start_time:stop_time), fdist, 'linewidth', 0.5);
    else
        plot (epoch(start_time:stop_time), fdist, 'linewidth', 0.5);
    end
    
    ylabel(['Eflux for ', num2str(round(mass)), 'a.u.'])
    datetick('x','HH:MM:SS');
    set (ax, 'fontsize', 8);
    grid on   
    
    %xlim
    averind = round(size(epoch, 1)/2);
    day = datestr(epoch(averind), 'dd-mmm-yyyy');
    t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
    xlim([datenum(t1), datenum(t2)])