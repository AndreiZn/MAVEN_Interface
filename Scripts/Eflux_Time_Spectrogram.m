function [message, error] = Eflux_Time_Spectrogram (ax, filefolderpath, date, start_time, stop_time, specific_args)
    
    [filename, message, error] = get_file(date, filefolderpath);
    
    if ~isempty(filename)
        mass = specific_args{1, 1};

        epoch = spdfcdfread(filename, 'variables', 'epoch');
        eflux = spdfcdfread(filename, 'variables', 'eflux');
        nmass = spdfcdfread(filename, 'variables', 'nmass');
        nenergy = spdfcdfread(filename, 'variables', 'nenergy');
        energy = spdfcdfread(filename, 'variables', 'energy');
        swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');

        start_str = start_time; stop_str = stop_time; %save str version of start, stop times
        %time 
        difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
        start_time = find (difference == min(difference), 1);
        difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
        stop_time = find (difference == min(difference), 1);

        tft = [start_time stop_time];
        eflux_disp = eflux(:, :, tft(1):tft(2));
        timelen = tft(2) - tft(1) + 1; 

        fdist = zeros(nmass, timelen);
        fdist(1:nmass, 1:timelen) = sum(eflux_disp, 2);
        if mass == 1
            mass_num = [1 8];
            ylab = 'H+';
        elseif mass == 16
            mass_num = [35 37];
            ylab = 'O+';
        elseif mass == 32
            mass_num = [44 45];
            ylab = 'O_2+';
        end    

        fdist2 = zeros(2, timelen+1);
        fdist2(1, 1:timelen) = squeeze(sum(fdist(mass_num(1):mass_num(2), :), 1));
        verify2 = fdist2 ~=0;
        colordata2 = [min(min(log10(fdist2(verify2)))), max(max(log10(fdist2(verify2))))];

        axes(ax);

        pcolor(epoch(tft(1):tft(2)+1), 1:2, log10(fdist2));    
        caxis(colordata2)
        shading flat             

        datetick('x','HH:MM:SS');
        set (ax, 'Ytick', [], 'fontsize', 8)
        ylabel(ax, ylab)

        bar_handle = colorbar;
        labels = get(bar_handle, 'yticklabel');
        barlabels = cell(size(labels, 1), 1);
        for i=1:size(labels, 1)
            barlabels{i} = ['10^{', labels{i}, '}'];
        end
        set(bar_handle, 'yticklabel', char(barlabels), 'FontWeight', 'bold', 'fontsize', 7)
        ylabel(bar_handle, 'Differential energy flux') 

        %xlim
        averind = round(size(epoch, 1)/2);
        day = datestr(epoch(averind), 'dd-mmm-yyyy');
        t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
        xlim([datenum(t1), datenum(t2)])
    end
    
function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'c6_32e64m';
    chosenfunc = 'Eflux_Time_Spectrogram';
    extensions = {{'', '.cdf',}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts')      