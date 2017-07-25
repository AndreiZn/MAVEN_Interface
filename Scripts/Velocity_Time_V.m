function Velocity_Time_V (ax, start_time, stop_time, filename, specific_args) %d1 file is being used

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
    theta = spdfcdfread(filename, 'variables', 'theta');
    phi = spdfcdfread(filename, 'variables', 'phi');
    quat_mso = spdfcdfread(filename, 'variables', 'quat_mso');
    
    start_str = start_time; stop_str = stop_time; %save str version of start, stop times
    %time 
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
    start_time = find (difference == min(difference), 1);
    difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
    stop_time = find (difference == min(difference), 1);

    q = 1.602177335e-19;
    aem = 1.66054021010e-27;

    timefrom = datenum(epoch(start_time));
    timeto = datenum(epoch(stop_time));

    choose_ind = find(epoch>=timefrom & epoch<=timeto);
    epoch = epoch(choose_ind);
    eflux = eflux(:, :, :, choose_ind);
    swp_ind = swp_ind(choose_ind);
    quat_mso = quat_mso(choose_ind, :);

    theta = theta*pi/180;
    phi = phi*pi/180;

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
    v_st = zeros(length(epoch), 3);
    for timenum = 1:length(epoch)
        for en = 1:nenergy
            for nphi = 1:nanode
                for ntheta = 1:ndef
                    bin = ndef*(nphi-1)+ntheta; %CHECK
                    swp_i = swp_ind(timenum);
                    v_ccl = v(en,swp_i+1,bin,mass_num); 
                    phdens = phsdensity(bin, en, timenum); 
                    ph = phi(en,swp_i+1,bin,mass_num); 
                    tht = theta(en,swp_i+1,bin,mass_num); 

                    volume = q*v_ccl*domega(en,swp_i+1,bin,mass_num)*denergy(en,swp_i+1,bin,mass_num)/(aem*mass_arr(en,swp_i+1,bin,mass_num));
                    concentration(timenum) = concentration(timenum) + volume*phdens;
                    v_st(timenum, 1) = v_st(timenum, 1) + volume*v_ccl*cos(ph)*cos(tht)*phdens;
                    v_st(timenum, 2) = v_st(timenum, 2) + volume*v_ccl*sin(ph)*cos(tht)*phdens;
                    v_st(timenum, 3) = v_st(timenum, 3) + volume*v_ccl*sin(tht)*phdens;
                end
            end
        end
    end
    for i=1:3
        v_st(:, i) = v_st(:, i)./concentration;
    end
    v_mso = quatrotate(quatinv(quat_mso), v_st);

    axes(ax);
    
    if (log==1)
        semilogy(epoch, sqrt(v_mso(:, 1).^2+v_mso(:, 2).^2+v_mso(:, 3).^2)/1e3, 'linewidth', 0.5)
    else
        plot(epoch, sqrt(v_mso(:, 1).^2+v_mso(:, 2).^2+v_mso(:, 3).^2)/1e3, 'linewidth', 0.5)
    end
    
    datetick('x','HH:MM:SS');
    grid on
    ylabel('V, km/s')
    set (ax, 'fontsize', 8);
    
    %xlim
    averind = round(size(epoch, 1)/2);
    day = datestr(epoch(averind), 'dd-mmm-yyyy');
    t1 = [day, ' ', start_str]; t2 = [day, ' ', stop_str];
    xlim([datenum(t1), datenum(t2)])