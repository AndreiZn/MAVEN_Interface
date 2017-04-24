function Temperature_Time (ax, start_time, stop_time, filename, specific_args) %d1 file is being used
    
    mass = specific_args{1, 1}; 
    log = specific_args{1, 2};
    
    epoch = spdfcdfread(filename, 'variables', 'epoch');
    eflux = spdfcdfread(filename, 'variables', 'eflux');
    energy = spdfcdfread(filename, 'variables', 'energy');
    denergy = spdfcdfread(filename, 'variables', 'denergy');
    theta = spdfcdfread(filename, 'variables', 'theta');
    phi = spdfcdfread(filename, 'variables', 'phi');
    domega = spdfcdfread(filename, 'variables', 'domega');
    swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
    mass_arr = spdfcdfread(filename, 'variables', 'mass_arr');
    nenergy = spdfcdfread(filename, 'variables', 'nenergy');
    nanode = spdfcdfread(filename, 'variables', 'nanode');
    ndef = spdfcdfread(filename, 'variables', 'ndef');
    quat_mso = spdfcdfread(filename, 'variables', 'quat_mso');
    
    start_str = start_time; stop_str = stop_time; %save str version of start, stop times
    %time 
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
    start_time = find (difference == min(difference), 1);
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
    stop_time = find (difference == min(difference), 1);
    
    timefrom = datenum(epoch(start_time));
    timeto = datenum(epoch(stop_time));

    choose_ind = find(epoch>=timefrom & epoch<=timeto);
    epoch = epoch(choose_ind);
    eflux = eflux(:, :, :, choose_ind);
    swp_ind = swp_ind(choose_ind);
    quat_mso = quat_mso(choose_ind, :);

    q = 1.602177335e-19;
    aem = 1.66054021010e-27;

    theta = theta*pi/180;
    phi = phi*pi/180;

    d_mass = 3; %a.u. (accuracy)
    swpind = swp_ind(1);
    m = mass_arr(16, swpind+1, 1, :);
    mass_num_range = find(( m>(mass-d_mass) )&( m<(mass+d_mass) ));
    mass_num = round((mass_num_range(1)+mass_num_range(end))/2);
    
    eflux(:, :, mass_num, :) = sum(eflux(:, :, mass_num_range, :), 3);
    v = 1*sqrt(2*q*energy./(aem*mass_arr));

    phsdensity = zeros(size(eflux));
    for i = 1:size(eflux, 4)
        m_sq = aem*permute(squeeze(mass_arr(:, swp_ind(i)+1, :, :)), [2 1 3]);
        e_sq = permute(squeeze(energy(:, swp_ind(i)+1, :, :)), [2 1 3]);
        phsdensity(:, :, :, i) = 1e4*0.5*eflux(:, :, :, i).*(m_sq./(e_sq*q)).^2;
    end

    concentration = zeros(length(epoch), 1);
    v_st = zeros(length(epoch), 3);
    temp = zeros(length(epoch), 1);
    for timenum = 1:length(epoch)
        for en = 1:nenergy
            for nphi = 1:nanode
                for ntheta = 1:ndef
                    bin = ndef*(nphi-1)+ntheta; %CHECK
                    i = [en, swp_ind(timenum)+1, bin, mass_num];
                    volume = q*v(i(1),i(2),i(3),i(4))*domega(i(1),i(2),i(3),i(4))*denergy(i(1),i(2),i(3),i(4))/(aem*mass_arr(i(1),i(2),i(3),i(4)));
                    concentration(timenum) = concentration(timenum) + volume*phsdensity(bin, en, mass_num, timenum);
                    v_st(timenum, 1) = v_st(timenum, 1) + volume*v(i(1),i(2),i(3),i(4))*cos(phi(i(1),i(2),i(3),i(4)))*cos(theta(i(1),i(2),i(3),i(4)))*phsdensity(bin, en, mass_num, timenum);
                    v_st(timenum, 2) = v_st(timenum, 2) + volume*v(i(1),i(2),i(3),i(4))*sin(phi(i(1),i(2),i(3),i(4)))*cos(theta(i(1),i(2),i(3),i(4)))*phsdensity(bin, en, mass_num, timenum);
                    v_st(timenum, 3) = v_st(timenum, 3) + volume*v(i(1),i(2),i(3),i(4))*sin(theta(i(1),i(2),i(3),i(4)))*phsdensity(bin, en, mass_num, timenum);

                end
            end
        end
    end
    for i=1:3
        v_st(:, i) = v_st(:, i)./concentration;
    end
    v_mso = quatrotate(quat_mso, v_st);

    for timenum = 1:length(epoch)
        for en = 1:nenergy
            for nphi = 1:nanode
                for ntheta = 1:ndef
                    bin = ndef*(nphi-1)+ntheta;
                    i = [en, swp_ind(timenum)+1, bin, mass_num];
                    volume = q*v(i(1),i(2),i(3),i(4))*domega(i(1),i(2),i(3),i(4))*denergy(i(1),i(2),i(3),i(4))/(aem*mass_arr(i(1),i(2),i(3),i(4)));
                    cur_v = [v(i(1),i(2),i(3),i(4))*cos(phi(i(1),i(2),i(3),i(4)))*cos(theta(i(1),i(2),i(3),i(4))),...
                             v(i(1),i(2),i(3),i(4))*sin(phi(i(1),i(2),i(3),i(4)))*cos(theta(i(1),i(2),i(3),i(4))),...
                             v(i(1),i(2),i(3),i(4))*sin(theta(i(1),i(2),i(3),i(4)))];
                    temp(timenum) = temp(timenum) + aem*mass_arr(i(1),i(2),i(3),i(4))*sum((cur_v-v_st(timenum)).^2)*phsdensity(bin, en, mass_num, timenum)*volume;
                end
            end
        end
    end
    temp = temp./(3*q*concentration);

    axes(ax);
    if (log==1)
        semilogy(epoch, temp, 'color', 'black', 'linewidth', 2)
    else
        plot(epoch, temp, 'color', 'black', 'linewidth', 2)
    end

    datetick('x','HH:MM:SS');
    grid on
    ylabel('T, eV')
    set (ax, 'fontsize', 8);
    
    %xlim
    averind = round(size(epoch, 1)/2);
    day = datestr(epoch(averind), 'dd-mmm-yyyy');
    t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
    xlim([datenum(t1), datenum(t2)])