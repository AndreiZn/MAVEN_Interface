function NumberDensity_Time(ax, start_time, stop_time, filename, specific_args) %d1 file is being used

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
    aem = 1.66054021010e-27;
    
    choose_ind = find(epoch>=timefrom & epoch<=timeto);
    epoch = epoch(choose_ind);
    eflux = eflux(:, :, :, choose_ind);
    swp_ind = swp_ind(choose_ind);

    d_mass = 3; %a.u. (accuracy)
    swpind = swp_ind(1);
    m = mass_arr(16, swpind+1, 1, :);
    mass_num_range = find(( m>(mass-d_mass) )&( m<(mass+d_mass) ));
    mass_num = round((mass_num_range(1)+mass_num_range(end))/2);

    eflux(:, :, mass_num, :) = sum(eflux(:, :, mass_num_range, :), 3);
    %eflux(:,:,:) = squeeze(sum(eflux(:, :, mass_num_range, :), 3));
    v = 1*sqrt(2*q*energy./(aem*mass_arr));
    
    assignin('base', 'efluxafter', eflux)
    assignin('base', 'mass_arr', mass_arr)
    
    phsdensity = zeros(size(eflux));
    for i = 1:size(eflux, 4)
        m_sq = aem*permute(squeeze(mass_arr(:, swp_ind(i)+1, :, :)), [2 1 3]);
        e_sq = permute(squeeze(energy(:, swp_ind(i)+1, :, :)), [2 1 3]);
        phsdensity(:, :, :, i) = 1e4*0.5*eflux(:, :, :, i).*(m_sq./(e_sq*q)).^2;
    end

    concentration = zeros(length(epoch), 1);

    for timenum = 1:length(epoch)
        for en = 1:nenergy
            for nphi = 1:nanode
                for ntheta = 1:ndef
                    bin = ndef*(nphi-1)+ntheta; %CHECK
                    i = [en, swp_ind(timenum)+1, bin, mass_num];
                    volume = q*v(i(1),i(2),i(3),i(4))*domega(i(1),i(2),i(3),i(4))*denergy(i(1),i(2),i(3),i(4))/(aem*mass_arr(i(1),i(2),i(3),i(4)));
                    concentration(timenum) = concentration(timenum) + volume*phsdensity(bin, en, mass_num, timenum);
                end
            end
        end
    end

    axes(ax);
    if (log==1)
        semilogy(epoch, concentration/1e6, 'color', 'black', 'linewidth', 2)
    else
        plot(epoch,concentration/1e6, 'color', 'black', 'linewidth', 2)
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