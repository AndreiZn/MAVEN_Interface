function Flux_Time_Spectrogram (ax, start_time, stop_time, filename, specific_args)

    epoch = spdfcdfread(filename, 'variables', 'epoch');
    eflux = spdfcdfread(filename, 'variables', 'eflux');
    nmass = spdfcdfread(filename, 'variables', 'nmass');
    
    start_str = start_time; stop_str = stop_time; %save str version of start, stop times
    %time 
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
    start_time = find (difference == min(difference), 1);
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
    stop_time = find (difference == min(difference), 1);
    
    timelen = stop_time - start_time + 1;

    tft = [start_time stop_time];
    eflux_disp = eflux(:, :, tft(1):tft(2));
    
    fdist = zeros(nmass+1, timelen+1);
    fdist(1:nmass, 1:timelen) = sum(eflux_disp, 2);
    mass_num = [1 8; 35 37; 44 45];
    fdist2 = zeros (size(mass_num, 1)+1, timelen+1);
    for i=1:size(mass_num, 1)
        fdist2(i, :) = sum(fdist(mass_num(i,1):mass_num(i,2), :), 1);
    end
    verify2 = fdist2 ~=0;
    colordata2 = [min(min(log10(fdist2(verify2)))), max(max(log10(fdist2(verify2))))];
    
    axes(ax);
    pcolor(log10(fdist2));
    caxis(colordata2)
    shading flat
    %set(gca, 'xtick', [], 'ytick', [], 'Position', [0.13, 0.3, 0.775, 0.163])               

    % %bar
    % bar_handle = colorbar;
    % labels = get(bar_handle, 'yticklabel');
    % barlabels = cell(size(labels, 1), 1);
    % for i=1:size(labels, 1)
    %     barlabels{i} = ['10^{', labels{i}, '}'];
    % end
    % set(bar_handle, 'yticklabel', char(barlabels), 'FontWeight', 'bold', 'fontsize', 10, 'Location', 'southoutside')
    % set(bar_handle, 'pos', [0.13    0.187    0.775  0.05])
    % ylabel(bar_handle, 'Differential energy flux')           
    % %

    ylabel('Mass, a.u.')

    pos2 = 1.5:5:90.5;
    pos3 = 1.5:3.5;
    lbl = [' 1'; '16'; '32'];
    set (ax, 'ytick', pos3, 'yticklabel', lbl,'fontsize', 6.5)
    set(ax, 'xtick', pos2, 'xticklabel', num2str(datestr(epoch(tft(1):5:tft(2)), 'HH:MM:SS')), 'fontsize', 8)
    
    %xlim
    averind = size(epoch, 1)/2;
    day = datestr(epoch(averind), 'dd-mmm-yyyy');
    t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
    %xlim([datenum(t1), datenum(t2)])