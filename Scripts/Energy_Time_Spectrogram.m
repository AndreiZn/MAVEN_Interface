function Energy_Time_Spectrogram(ax, start_time, stop_time, filename, specific_args)
    
    mass = specific_args{1, 1}; 
    log = specific_args{1, 2};
    %colormap_min = str2double(specific_args{1, 4}); %'3'
    %colormap_max = str2double(specific_args{1, 5}); %'8.5'
    
    eflux = spdfcdfread(filename, 'variables', 'eflux');
    nenergy = spdfcdfread(filename, 'variables', 'nenergy');
    energy = spdfcdfread(filename, 'variables', 'energy');
    swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
    epoch = spdfcdfread(filename, 'variables', 'epoch');
    mass_arr = spdfcdfread(filename, 'variables', 'mass_arr');
    
    start_str = start_time; stop_str = stop_time; %save str version of start, stop times
    %time 
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
    start_time = find (difference == min(difference), 1);
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
    stop_time = find (difference == min(difference), 1);
    
    tft = [start_time stop_time];
    
    if mass == 0 %then it's a cumulative spectrogram
        eflux_disp = squeeze(sum(eflux(:, :, tft(1):tft(2)), 1));
    else
        d_mass = 1; %a.u. (accuracy)
        mass_num_range = find((mass_arr(16, swp_ind(tft(1))+1, :)>mass-d_mass)&(mass_arr(16, swp_ind(tft(1))+1, :)<mass+d_mass));
        eflux_disp = squeeze(sum(eflux(mass_num_range, :, tft(1):tft(2)), 1));
    end    
    
    axes(ax);
    
    pcolor(repmat(epoch(tft(1):tft(2))', nenergy, 1), energy(:,swp_ind(tft(1):tft(2))+1,1), log10(eflux_disp));
    
    % colormap
    verify = eflux_disp~=0;
    %if isnan(colormap_min)
        colormap_min = min(min(log10(eflux_disp(verify)))); 
    %end
    %if isnan(colormap_max)
        colormap_max = max(max(log10(eflux_disp(verify)))); 
    %end
    colordata = [colormap_min colormap_max];
    
    caxis(colordata)
    
    shading flat
    grid on
    if log == 1
        set (gca, 'YScale', 'log')
    end
    set(gca, 'tickdir', 'out', 'ticklength', [0.003 0.1], 'fontsize', 7);    
    ylabel('Energy', 'fontsize', 8)
    datetick('x', 'HH:MM:SS')
    
    bar_handle = colorbar;
    labels = get(bar_handle, 'yticklabel');
    barlabels = cell(size(labels, 1), 1);
    for i=1:size(labels, 1)
        barlabels{i} = ['10^{', labels{i}, '}'];
    end
    set(bar_handle, 'yticklabel', char(barlabels), 'FontWeight', 'bold', 'fontsize', 7)
    ylabel(bar_handle, 'Differential energy flux') 
       
    %title
    if mass == 0
        ttl = 'Cumulative spectrogram, ';
    else    
        ttl = ['Mass = ', num2str(mass),'a.u., '];
    end    
    if log == 1
        ttl = [ttl, 'LogScale=on'];
    else
        ttl = [ttl, 'LogScale=off'];
    end
    title(ttl, 'FontWeight', 'bold', 'fontsize', 7);
    
    %xlim
    averind = round(size(epoch, 1)/2);
    day = datestr(epoch(averind), 'dd-mmm-yyyy');
    t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
    xlim([datenum(t1), datenum(t2)])