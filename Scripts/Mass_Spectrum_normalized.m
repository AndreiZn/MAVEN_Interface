function Mass_Spectrum_normalized(ax, start_time, stop_time, filename, specific_args)

    epoch = spdfcdfread(filename, 'variables', 'epoch');
    eflux = spdfcdfread(filename, 'variables', 'eflux');
    swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
    mass_arr = spdfcdfread(filename, 'variables', 'mass_arr');
    data_name = spdfcdfread(filename, 'variables', 'data_name');

    time = specific_args{1,1};
    log = specific_args{1,3};
    
    axes (ax);
    
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(time));
    timenum = find (difference == min(difference), 1);

    eflux_sum = squeeze(sum(eflux, 2));
    
    if log==1
        semilogy (squeeze(mass_arr(16, swp_ind(timenum)+1, :)), squeeze(eflux_sum(:,timenum)));
    else
        plot (squeeze(mass_arr(16, swp_ind(timenum)+1, :)), squeeze(eflux_sum(:,timenum)));
    end
    xlabel = num2str(squeeze(round(mass_arr(16, swp_ind(timenum)+1, :))));
    xlabel(2:8, :) = ' '; xlabel(10:14, :) = ' '; xlabel(16:18, :) = ' '; 
    xlabel(20, :) = ' '; xlabel(22, :) = ' '; xlabel(24, :) = ' ';xlabel(26, :) = ' '; xlabel(29, :) = ' ';
    xlabel(32, :) = ' ';
    xtick = mass_arr(16, swp_ind(timenum)+1, :);
    set(gca,'xtick', xtick, 'xticklabel',  num2str(xlabel))
    set(gca, 'tickdir', 'out', 'FontSize', 8, 'XGrid', 'on', 'YGrid', 'on') %'Yticklabelmode', 'manual')
    title (['Mass Spectrum_', '  date=', num2str(datestr(epoch(timenum), 'yyyy.mm.dd')) ' ', num2str(datestr(epoch(timenum), 'HH.MM.SS'))], 'FontSize', 10)
