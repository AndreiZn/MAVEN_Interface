function Magnetic_Field (ax, start_time, stop_time, filename, specific_args)

    magf = spdfcdfread(filename, 'variables', 'magf');
    epoch = spdfcdfread(filename, 'variables', 'epoch');
    
    start_str = start_time; stop_str = stop_time; %save str version of start, stop times
    %time 
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
    start_time = find (difference == min(difference), 1);
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
    stop_time = find (difference == min(difference), 1);
    
    mf = magf (start_time:stop_time, :);  
    Bx = mf(:, 1); By = mf(:, 2); Bz = mf(:, 3);
    B = sqrt(Bx.^2 + By.^2 + Bz.^2);
    
    axes(ax);
    plot(epoch(start_time:stop_time), B, 'color', 'black', 'linewidth', 2)
    
    datetick('x','HH:MM:SS');
    ylabel('B, nT')
    grid on
    set (ax, 'fontsize', 8);
    
    %xlim
    averind = round(size(epoch, 1)/2);
    day = datestr(epoch(averind), 'dd-mmm-yyyy');
    t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
    %xlim([datenum(t1), datenum(t2)])
