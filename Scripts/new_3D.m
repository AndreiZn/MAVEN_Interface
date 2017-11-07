function [message, error] = new_3D(ax, filefolderpath, date, start_time, stop_time, specific_args)
    
    %filename = 'D:\������\Programming\Matlab Programs\MAVEN\MAVEN_Interface_Small\MAVEN_Files\d1_32e4d16a8m\2015\01\mvn_sta_l2_d1-32e4d16a8m_20150104_v01_r12.cdf';
    [filename, message, error] = get_file(date, filefolderpath);
    if ~isempty(filename)
        
        mass = specific_args{1,1};
        
        epoch = spdfcdfread(filename, 'variables', 'epoch');
        eflux = spdfcdfread(filename, 'variables', 'eflux');
        energy = spdfcdfread(filename, 'variables', 'energy');
        swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
        mass_arr = spdfcdfread(filename, 'variables', 'mass_arr');
        magf = spdfcdfread(filename, 'variables', 'magf');
        quat_mso = spdfcdfread(filename, 'variables', 'quat_mso');
        k=0;

        timelen = 10;
        %start_time = 3571; stop_time = start_time + timelen-1;

        start_str = start_time; stop_str = stop_time; %save str version of start, stop times
        %time 
        difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
        start_time = find (difference == min(difference), 1);
        %difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
        %stop_time = find (difference == min(difference), 1);

        stop_time = start_time + timelen-1;
        %===============================
        %�������� ������� (Hammer projection)
        % Phi = (-78.75:22.5:78.75)*pi./180;
        % Lambda = [-157.917 -135.417 -112.917 -90.417 -67.917 -45.417 -22.917 -0.417 22.083 44.583 67.083 89.583 112.083 134.583 157.083 179.583]*pi./180;
        Phi = zeros(5, 7);
        Phi(:, 1) = [-8.1158724;-4.0579362;0;4.0579362;8.1158724]*pi/180;
        Phi(:, 2) = [-11.25812535;-5.62906265;0;5.62906275;11.25812545]*pi/180;
        Phi(:, 3) = [-15.6169737;-7.8084863;0;7.8084885;15.6169759]*pi/180;
        Phi(:, 4) = [-21.6634545;-10.8317275;0;10.8317265;21.6634535]*pi/180;
        Phi(:, 5) = [-30.050973;-15.025485;0;15.025491;30.050979]*pi/180;
        Phi(:, 6) = [-41.685922;-20.842962;0;20.842958;41.685918]*pi/180;
        Phi(:, 7) = [-45.866664;-22.933332;0;22.933332;45.866664]*pi/180;

        Lambda = [-168.75000;-146.25000;-123.75000;-101.25000;-78.750000;-56.250000;-33.750000;-11.250000;11.250000;33.750000;56.250000;78.750000;101.25000;123.75000;146.25000;168.75000;191.25000]*pi/180;
        X = zeros(size(Phi, 1), length(Lambda), 7);
        Y = zeros(size(Phi, 1), length(Lambda), 7);
        for en = 1:7
            for i = 1:length(Lambda)
                for j = 1:size(Phi, 1)
                    X(j, i, en) = 2*sqrt(2)*cos(Phi(j, en))*sin(Lambda(i)/2)/sqrt(1+cos(Phi(j, en))*cos(Lambda(i)/2));
                    Y(j, i, en) = sqrt(2)*sin(Phi(j, en))/sqrt(1+cos(Phi(j, en))*cos(Lambda(i)/2));
                end
            end
        end
        dotcont = zeros(100, 2);
        Phi = linspace(-pi/2, pi/2, 100);
        Lambda = [-168.75, 191.25]*pi/180;
        c=1;
        for i=1:length(Lambda)
            for j=1:length(Phi)
                dotcont(c, 1) = 2*sqrt(2)*cos(Phi(j))*sin(Lambda(i)/2)/sqrt(1+cos(Phi(j))*cos(Lambda(i)/2));
                dotcont(c, 2) = sqrt(2)*sin(Phi(j))/sqrt(1+cos(Phi(j))*cos(Lambda(i)/2));
                c=c+1;
            end
        end
        %clear Phi Lambda i j
        %===============================
        
        d_mass = 3; %a.u. (accuracy)
        swpind = swp_ind(start_time);
        m = mass_arr(16, swpind+1, 1, :);
        mass_num_range = find(( m>(mass-d_mass) )&( m<(mass+d_mass) ));
        mass_num = round((mass_num_range(1)+mass_num_range(end))/2);
        
        for j = 1:1
            k = k + 1;
            h = figure(k);
            %set(h, 'pos', [7 77 1287 707])
            set(h, 'pos', [0 -60 1920 1004])

            tft = [start_time+10*(j-1) stop_time+10*(j-1)];
            eflux_disp = eflux(:, :, :, tft(1):tft(2));
            quat_mso_disp = quat_mso(tft(1):tft(2), :);

            quats = quat_mso(tft(1):tft(2), :);
            verify = eflux_disp ~=0;
            colordata = [min(min(min(min(log10(eflux_disp(verify)))))), max(max(max(max(log10(eflux_disp(verify))))))];
            c = 1;

            for enum=1:2:32
                for timenum =1:timelen
                    h = subplot(16, timelen, c);
                    fdist = zeros(5, 17);
                    fdist(1, 1:16) = eflux_disp(1:4:64, enum, mass_num, timenum);
                    fdist(2, 1:16) = eflux_disp(2:4:64, enum, mass_num, timenum);
                    fdist(3, 1:16) = eflux_disp(3:4:64, enum, mass_num, timenum);
                    fdist(4, 1:16) = eflux_disp(4:4:64, enum, mass_num, timenum);
                    fdist = flipud(fdist);
                    %fdist = fdist(:, [9:16, 1:8, 17]);
                    fdist = fdist([2 3 4 5 1], :);

                    if(enum>7)
                        en=7;
                    else
                        en = enum;
                    end
                    pcolor(squeeze(X(:, :, en)), squeeze(Y(:, :, en)), log10(fdist));
                    caxis(colordata)
                    colormap(jet)
                    hold on
                    plot(dotcont(:, 1), dotcont(:, 2), 'color', 'black')
                    hold off
                    ylim([min(dotcont(:, 2)) max(dotcont(:, 2))])
                    axis equal

                    p = get(h, 'pos');
                    p(2) = p(2) + 0.04;
                    p(4) = p(4)*1.3;
                    p(2) = p(2) - (enum-1)*0.0015;
                    p(2) = p(2) + 0.006;
                    p(3) = p(3)*1.3;
                    set(h, 'pos', p)

                    shading flat
                    set(gca, 'xtick', [], 'ytick', [])
                    if(enum == 1)
                        title(datestr(epoch(timenum+tft(1)-1), 'HH:MM:SS'), 'FontWeight', 'bold')
                    end

                    if (enum == 32)
                        set(gca, 'xtick', 8.5, 'xticklabel', num2str(swp_ind(timenum+tft(1)-1)+1), 'fontsize', 6)
                    end

                    %Magnetic field
                    mf = magf (tft(1):tft(2), :);
                    Bx = mf(timenum, 1); By = mf(timenum, 2); Bz = mf(timenum, 3);
                    B = sqrt(Bx^2 + By^2 + Bz^2);

                    thetam = asin(Bz/B);
                    if (Bx==0)
                        if (By>0)
                            lambdam = pi/2;
                        elseif (By<0)
                            lambdam = -pi/2;
                        else
                            lambdam = 0; %!
                        end
                    else
                        lambdam = atan (By/Bx);
                        if ((By>=0)&&(Bx<0))
                            lambdam = lambdam + pi;
                        end
                        if ((By<0)&&(Bx<0))
                            lambdam = lambdam - pi;
                        end
                    end

                    hold on
                    Xmf = 2*sqrt(2)*cos(thetam)*sin(lambdam/2)/sqrt(1+cos(lambdam)*cos(lambdam/2));
                    Ymf = sqrt(2)*sin(thetam)/sqrt(1+cos(thetam)*cos(lambdam/2));
                    plot(Xmf, Ymf, '*', 'color', 'red')
                    %End.Magnetic field

                    soldir = quatrotate(quat_mso_disp(timenum, :), [-1 0 0]);
                    thetas = asin(soldir(3));
                    if (soldir(1)==0)
                        if (soldir(2)>0)
                            lambdas = pi/2;
                        elseif (soldir(2)<0)
                            lambdas = -pi/2;
                        else
                            lambdas = 0; %!
                        end
                    else
                        lambdas = atan (soldir(2)/soldir(1));
                        if ((soldir(2)>=0)&&(soldir(1)<0))
                            lambdas = lambdas + pi;
                        end
                        if ((soldir(2)<0)&&(soldir(1)<0))
                            lambdas = lambdas - pi;
                        end
                    end

                    Xs = 2*sqrt(2)*cos(thetas)*sin(lambdas/2)/sqrt(1+cos(lambdas)*cos(lambdas/2));
                    Ys = sqrt(2)*sin(thetas)/sqrt(1+cos(thetas)*cos(lambdas/2));
                    plot(Xs, Ys, '*', 'color', 'green')
                    hold off

                    c = c+1;
                end
                %text(-222.567, 3.085, ['Energy=', num2str(round(energy(enum, swp_ind(timenum+tft(1)-1)+1, 1, mass_num))), 'eV/','Mass=', num2str(round(mass_arr (enum, swp_ind(tft(1))+1, 1, mass_num))), 'a.u.'], 'FontWeight', 'bold', 'FontSize', 8.5)
                text(-98    , 3, ['Energy=', num2str(round(energy(enum, swp_ind(timenum+tft(1)-1)+1, 1, mass_num))), 'eV/','Mass=', num2str(mass), 'a.u.'], 'FontWeight', 'bold', 'FontSize', 8.5)
            end

            bar_handle = colorbar;
            set(bar_handle, 'pos', [0.918    0.11    0.027  0.867])
            labels = get(bar_handle, 'yticklabel');
            barlabels = cell(size(labels, 1), 1);
            for i=1:size(labels, 1)
                barlabels{i} = ['10^{', labels{i}, '}'];
            end
            set(bar_handle, 'yticklabel', char(barlabels), 'FontWeight', 'bold', 'fontsize', 10)
            ylabel(bar_handle, 'Differential energy flux')

        end
    end

function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'd1_32e4d16a8m';
    chosenfunc = 'new_3D';
    extensions = {{'', '.cdf',}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts') 