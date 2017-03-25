function Flux_Mass_Plot (ax, filename, timenum, log)
    swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
    mass_arr = spdfcdfread(filename, 'variables', 'mass_arr');
    eflux = spdfcdfread(filename, 'variables', 'eflux');
    
    axes(ax);
    eflux_sum = squeeze(sum(eflux, 2));
    if (log==1)
        semilogy (ax, squeeze(mass_arr(16, swp_ind(timenum)+1, :)), squeeze(eflux_sum(:,timenum)));
    else
        plot (ax, squeeze(mass_arr(16, swp_ind(timenum)+1, :)), squeeze(eflux_sum(:,timenum)));
    end
    ylabel('Eflux')
    xlabel = num2str(squeeze(round(mass_arr(16, swp_ind(timenum)+1, :))));
    xlabel(2:8, :) = ' '; xlabel(10:14, :) = ' '; xlabel(16:18, :) = ' '; 
    xlabel(20, :) = ' '; xlabel(22, :) = ' '; xlabel(24, :) = ' ';xlabel(26, :) = ' '; xlabel(29, :) = ' ';
    xlabel(32, :) = ' ';
    xtick = mass_arr(16, swp_ind(timenum)+1, :);
    set(gca,'ticklength', [0 0], 'xtick', xtick, 'xticklabel',  num2str(xlabel))
    set(gca, 'FontSize', 8, 'XGrid', 'on', 'YGrid', 'on') 
    axis ([0 100 0 max(max(eflux_sum(:,timenum)))])
    %text (-3.7, 5.5e7, 'Eflux')
    %text (100, 11397, 'Mass, a.u.')
end