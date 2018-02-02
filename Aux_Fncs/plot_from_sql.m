function plot_from_sql(ax, data, ylab, date, start_time, stop_time)
    
    axes(ax); 

    plot(data(:,2), data(:,1), 'linewidth', 0.5)

    datetick('x','HH:MM:SS');
    ylabel(ylab)
    grid on
    set (ax, 'fontsize', 8);

    %xlim_min = datenum([date(1:7), '0000', ' ', start_time]);
    %xlim_max = datenum([date(1:7), '0000', ' ', stop_time]);
    %xlim([xlim_min, xlim_max])
    xlim([data(1,2), data(end,2)])