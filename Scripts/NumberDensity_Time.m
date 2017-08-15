function [message, error] = NumberDensity_Time (ax, filefolderpath, date, start_time, stop_time, specific_args)

    [filename, message, error] = get_file(date, filefolderpath);
    if ~isempty(filename)
        
        mass = specific_args{1, 1}; 
        log = specific_args{1, 2};

        epoch = spdfcdfread(filename, 'variables', 'epoch');
        eflux = spdfcdfread(filename, 'variables', 'eflux');
        energy = spdfcdfread(filename, 'variables', 'energy');
        denergy = spdfcdfread(filename, 'variables', 'denergy');
        domega = spdfcdfread(filename, 'variables', 'domega');
        swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
        mass_arr = spdfcdfread(filename, 'variables', 'mass_arr');
        nenergy = spdfcdfread(filename, 'variables', 'nenergy');
        nanode = spdfcdfread(filename, 'variables', 'nanode');
        ndef = spdfcdfread(filename, 'variables', 'ndef');

        start_str = start_time; stop_str = stop_time; %save str version of start, stop times
        %time
        difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
        start_time = find (difference == min(difference), 1);
        difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
        stop_time = find (difference == min(difference), 1);

        timefrom = datenum(epoch(start_time));
        timeto = datenum(epoch(stop_time));

        q = 1.602177335e-19;
        aem = 1.66054021010e-24;

        choose_ind = find(epoch>=timefrom & epoch<=timeto);
        epoch = epoch(choose_ind);
        %assignin('base', 'epch', epoch)
        %assignin('base', 'ch_ind', choose_ind)
        assignin('base', 'eflx', eflux)
        eflux = eflux(:, :, :, choose_ind);
        swp_ind = swp_ind(choose_ind);

        d_mass = 3; %a.u. (accuracy)
        swpind = swp_ind(1);
        m = mass_arr(16, swpind+1, 1, :);
        mass_num_range = find(( m>(mass-d_mass) )&( m<(mass+d_mass) ));
        mass_num = round((mass_num_range(1)+mass_num_range(end))/2);

        onemass_eflux = reshape( sum(eflux(:, :, mass_num_range, :), 3), [size(eflux, 1) size(eflux, 2) size(eflux, 4)] );
        v = 1*sqrt(2*q*energy./(aem*mass_arr));

        phsdensity = zeros(size(onemass_eflux));
        for i = 1:size(onemass_eflux, 3)
            m_sq = aem*permute(squeeze(mass_arr(:, swp_ind(i)+1, :, mass_num)), [2 1]);
            e_sq = permute(squeeze(energy(:, swp_ind(i)+1, :, mass_num)), [2 1]);
            phsdensity(:, :, i) = 1e4*0.5*onemass_eflux(:, :, i).*(m_sq./(e_sq*q)).^2;
        end

        concentration = zeros(length(epoch), 1);
        for timenum = 1:length(epoch)
            for en = 1:nenergy
                for nphi = 1:nanode
                    for ntheta = 1:ndef
                            bin = ndef*(nphi-1)+ntheta;
                            swp_i = swp_ind(timenum);
                            v_ccl = v(en,swp_i+1,bin,mass_num); 
                            phdens = phsdensity(bin, en, timenum); 

                            volume = q*v_ccl*domega(en,swp_i+1,bin,mass_num)*denergy(en,swp_i+1,bin,mass_num)/(aem*mass_arr(en,swp_i+1,bin,mass_num));
                            concentration(timenum) = concentration(timenum) + volume*phdens;                  
                    end
                end
            end
        end

        axes(ax);
        if (log==1)
            semilogy(epoch, concentration/1e6, 'linewidth', 0.5)
        else
            plot(epoch,concentration/1e6, 'linewidth', 0.5)
        end

        ylabel('n, cm^{-3}')
        datetick('x','HH:MM:SS');
        set (ax, 'fontsize', 8);
        grid on

        %xlim
        averind = round(size(epoch, 1)/2);
        day = datestr(epoch(averind), 'dd-mmm-yyyy');
        t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
        xlim([datenum(t1), datenum(t2)])
    end
    
function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'd1_32e4d16a8m';
    chosenfunc = 'NumberDensity_Time';
    extensions = {{'', '.cdf',}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts')        