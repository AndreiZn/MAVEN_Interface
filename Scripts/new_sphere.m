function [message, error] = new_sphere(ax, filefolderpath, date, start_time, stop_time, specific_args)

    [filename, message, error] = get_file(date, filefolderpath);
    if ~isempty(filename)

        epoch = spdfcdfread(filename, 'variables', 'epoch');
        eflux = spdfcdfread(filename, 'variables', 'eflux');
        energy = spdfcdfread(filename, 'variables', 'energy');
        swp_ind = spdfcdfread(filename, 'variables', 'swp_ind');
        magf = spdfcdfread(filename, 'variables', 'magf');
        quat_mso = spdfcdfread(filename, 'variables', 'quat_mso');
        
        start_str = start_time; stop_str = stop_time; %save str version of start, stop times
        %time 
        difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(start_time));
        start_time = find (difference == min(difference), 1);
        difference = abs(datenum(datestr(epoch, 'HH:MM:SS')) - datenum(stop_time));
        stop_time = find (difference == min(difference), 1);

        timefrom = datenum(epoch(start_time));
        timeto = datenum(epoch(stop_time));
        
        choose_ind = find(epoch>timefrom & epoch<timeto);
        epoch = epoch(choose_ind);
        swp_ind = swp_ind(choose_ind);
        eflux = eflux(:, :, :, choose_ind);
        quat_mso = quat_mso(choose_ind, :);
        magf = magf(choose_ind, :);

        magf = quatrotate(quatinv(quat_mso), magf);

        for timenum = 1:1%length(epoch)
            
            eflux_disp = squeeze(eflux(:, :, 1, timenum));
            for i=1:64
                eflux_disp(i, :) = eflux_disp(i, :)./energy(:, swp_ind(timenum)+1, i, 1)';
            end
            eflux_disp = squeeze(sum(eflux_disp, 2));
            fdist = zeros(5, 17);
            fdist(1, 1:16) = eflux_disp(1:4:64);
            fdist(2, 1:16) = eflux_disp(2:4:64);
            fdist(3, 1:16) = eflux_disp(3:4:64);
            fdist(4, 1:16) = eflux_disp(4:4:64);
            fdist = flipud(fdist);
            fdist = fdist([2 3 4 5 1], :);

            figure(42)
            [X, Y, Z] = sphere(18, 36);
            surf(X, Y, Z, 'facealpha', 0, 'linestyle', '--')
            hold on

            B = 0.5*sqrt(sum(magf(timenum, :).^2, 2));
            cd('../Aux_Fncs')
            feval('arrow3d', [0 0 0], [magf(timenum, 1)/B, magf(timenum, 2)/B, magf(timenum, 3)/B]);
            cd('../Scripts')

            nphi = 16;
            ntheta = 4;

            theta = (45/90)*(-ntheta:2:ntheta)/ntheta*pi/2;
            phi = (-nphi:2:nphi)'/nphi*pi;
            cosphi = cos(phi); %cosphi(1) = 0; cosphi(nphi+1) = 0;
            sintheta = sin(theta); %sintheta(1) = -1; sintheta(ntheta+1) = 1;

            x = cosphi*cos(theta);
            y = sin(phi)*cos(theta);
            z = ones(nphi+1, 1)*sintheta;

            for i=1:(nphi+1)*(ntheta+1)
                newvec = quatrotate(quatinv(quat_mso(timenum, :)), [x(i), y(i), z(i)]);
                x(i) = newvec(1);
                y(i) = newvec(2);
                z(i) = newvec(3);
            end

            h = surf(x', y', z', fdist);
            colormap(jet)
            axis equal
            xlabel('x')
            ylabel('y')
            zlabel('z')
            hold off
            grid on
            title(datestr(epoch(timenum), 'HH:MM:SS'))

            %saveas(42, datestr(epoch(timenum), 'HH-MM-SS'))
        end
        
    end

function [file, msg, err] = get_file(date, filefolderpath)
    
    filetype = 'd1_32e4d16a8m';
    chosenfunc = 'new_sphere';
    extensions = {{'', '.cdf',}};
    
    cd('../Aux_Fncs')
    [file, msg, err] = feval('GetFile', chosenfunc, filetype, extensions, date, filefolderpath); 
    cd('../Scripts')     