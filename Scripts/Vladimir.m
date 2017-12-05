function [message, error] = Vladimir (ax, filefolderpath, date, start_time, stop_time, specific_args)

    %[filename, message, error] = get_file(date, filefolderpath);

    %*************** Set time range **********************
    %TimeStart = datenum('2015-01-04 18:37:30','yyyy-mm-dd HH:MM:SS'); 
    %TimeEnd = datenum('2015-01-04 18:55:00','yyyy-mm-dd HH:MM:SS');
    TimeStart = datenum([date, ' ', start_time], 'dd-mmm-yyyy HH:MM:SS');
    TimeEnd = datenum([date, ' ', stop_time], 'dd-mmm-yyyy HH:MM:SS');
    
    %*************** Constants **************************
    scale_velocity = 0.8*10^-2 ; % scaling factor for O+ and p velocities vectors in cylindrical system. 
    scale_electric_field = 4*10^-4; % scaling factor for Electric field vectors in cylindrical system. 
    Rm=3390;
    step = 10;
    step_text = 40; 
    amu = 1.6 * 10^-24; % [g]
    anu = 1;
    c = 3 * 10^10; %[cm/s]
    q = 4.8 * 10^(-10); % SGSE charge unit
    m_p = 1 * amu;
    m_O = 16 * amu;
    m_O2 = 32 * amu;
    m_CO2 = 44 * amu;
    kB = 1.38 * 10^-16; % [erg/K]
    date = datestr(TimeStart, 'yyyy-mm-dd');

    
    %***************  Find file with data ***********************
    datefrom = datestr(TimeStart, 'yyyymmdd'); 
    dateto = datestr(TimeEnd, 'yyyymmdd');
    root = '\\193.232.6.100\общие\Владимир\MAVEN_data_in_MatLab_format';
    monthpath = root; 
    month_filelist =  dir(monthpath);
    for i = 1:length(month_filelist)
        if (length(month_filelist(i).name)<10)
            continue
        end
        if(all(month_filelist(i).name(22:29) == datefrom)) % for MAG data
            filename = [monthpath '\' month_filelist(i).name];
            isfound = true;
            products_mag = load (filename);

        end
        if(all(month_filelist(i).name(26:33) == datefrom))  % for STATIC data
            filename = [monthpath '\' month_filelist(i).name];
            isfound = true;
            switch (month_filelist(i).name(47))
                case 'H'
                    products_H = load (filename);
                case 'O'
                    if (length(month_filelist(i).name) == 51)
                        products_O = load (filename);
                    end
                    if (length(month_filelist(i).name) == 52)
                        products_O2 = load (filename);
                    end
            end
        end
    end


    %******************** Load files ****************

    %****************** variables *********
    epoch = products_O.epoch;
    x = products_O.pos_sc_mso(( epoch >= TimeStart & epoch <= TimeEnd),1)/Rm;
    y = products_O.pos_sc_mso(( epoch >= TimeStart & epoch <= TimeEnd),2)/Rm;
    z = products_O.pos_sc_mso(( epoch >= TimeStart & epoch <= TimeEnd),3)/Rm;
    R_O = sqrt(x.^2 + y.^2+z.^2);
    R_cyl_O = sqrt(y.^2 + z.^2);
    SZA = 180 / pi * atan ( R_cyl_O./x);
    SZA (x<0) = SZA (x<0)  + 180; 

    %********************* O+ ***********

    n_O = products_O.concentration(( epoch >= TimeStart & epoch <= TimeEnd));
    T_O = products_O.temp(( epoch >= TimeStart & epoch <= TimeEnd));
    v_x_O = products_O.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),1);
    v_y_O = products_O.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),2);
    v_z_O = products_O.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),3);
    v_O = sqrt (v_x_O.^2 + v_y_O.^2 + v_z_O.^2);

    %********************* p *************
    n_p = products_H.concentration(( epoch >= TimeStart & epoch <= TimeEnd));
    T_p = products_H.temp(( epoch >= TimeStart & epoch <= TimeEnd));
    v_x_p = products_H.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),1);
    v_y_p = products_H.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),2);
    v_z_p = products_H.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),3);
    v_p = sqrt (v_x_p.^2 + v_y_p.^2 + v_z_p.^2);

    %********************* O2+ *************
    n_O2 = products_O2.concentration(( epoch >= TimeStart & epoch <= TimeEnd));
    T_O2 = products_O2.temp(( epoch >= TimeStart & epoch <= TimeEnd));
    v_x_O2 = products_O2.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),1);
    v_y_O2 = products_O2.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),2);
    v_z_O2 = products_O2.v_mso(( epoch >= TimeStart & epoch <= TimeEnd),3);
    v_O2 = sqrt (v_x_O2.^2 + v_y_O2.^2 + v_z_O2.^2);

    %******************** B field (with low time resolution (averaged) from file of STATIC data) *****************
    Blx = products_O.magf(( epoch >= TimeStart & epoch <= TimeEnd),1);
    Bly = products_O.magf(( epoch >= TimeStart & epoch <= TimeEnd),2);
    Blz = products_O.magf(( epoch >= TimeStart & epoch <= TimeEnd),3);
    Bl = sqrt(Blx.^2 + Bly.^2 + Blz.^2);

    %****************  B field (with high time resolution from file for MAG data) **********************
    mf_epoch = products_mag.mf_epoch;
    Bx = products_mag.Bx(( mf_epoch >= TimeStart & mf_epoch <= TimeEnd));
    By = products_mag.By(( mf_epoch >= TimeStart & mf_epoch <= TimeEnd));
    Bz = products_mag.Bz(( mf_epoch >= TimeStart & mf_epoch <= TimeEnd));
    B = sqrt(Bx.^2 + By.^2 + Bz.^2);
    mf_epoch = mf_epoch( mf_epoch >= TimeStart & mf_epoch <= TimeEnd);

    %**********************  velocities ***********
    v_x_bulk = (v_x_p.*n_p + v_x_O.*n_O*16 + v_x_O2.*n_O*32 )./(n_p + n_O*16 + n_O2*32 );
    v_y_bulk = (v_y_p.*n_p + v_y_O.*n_O*16 + v_y_O2.*n_O*32 )./(n_p + n_O*16 + n_O2*32 );
    v_z_bulk = (v_z_p.*n_p + v_z_O.*n_O*16 + v_z_O2.*n_O*32 )./(n_p + n_O*16 + n_O2*32 );
    v_bulk = sqrt(v_x_bulk.^2 + v_y_bulk.^2 + v_z_bulk.^2);

    %*********************  Electric fiel calculation ***********
    Ex = v_z_bulk.*Bly - v_y_bulk.*Blz;
    Ey = v_x_bulk.*Blz - v_z_bulk.*Blx;
    Ez = v_y_bulk.*Blx - v_x_bulk.*Bly;

    epoch = epoch( epoch >= TimeStart & epoch <= TimeEnd);


    figure(1)
    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    %************************* Figure(1.1) Cylindrical system ************
    subplot(2,3,1)

    %***************  Bow shock ************
    yb=0:0.01:4.5;
    xb=(-exp(yb).^0.2)*0.2+0.04*yb-0.2.*yb.^2.15+1.6;
    plot1 = plot(xb,yb,'k'); %******** plot bow shock ******
    hold on

    %************   Magnetosphere boundary ******
    ymb=0:0.01:2.5;
    xmb=(-exp(ymb).^2)*0.05+0.1*ymb-0.2.*ymb.^2+1.25;
    rmb=sqrt(xmb.^2 + ymb.^2);
    plot2 = plot(xmb,ymb,'k'); %***** plot magnetosphere boundary ***
    hold on
    axis equal tight
    t=(0:0.001:2*pi);

    %*************** plot Mars ****
    plot3 = plot(cos(t),sin(t),'k');  %*************** plot Mars

    %**************  Plot properties *************
    xlabel('X_{MSO}, R_M')
    ylabel('R_{MSO}, R_M')
    plot_title = strcat(datestr(epoch(1),'yyyy-mm-dd'), {' '}, datestr(epoch(1),'HH:MM:SS'),{'-'}, datestr(epoch(end),'HH:MM:SS'));
    title(plot_title)
    ylim([0 2])
    xlim([-0.5 2])

    %************* plot orbit *********
    plot4 = plot(x,R_cyl_O); 

    %************  Calculate 
    v_phi_O = atan_angle(v_z_O, v_y_O);
    v_phi_p = atan_angle(v_z_p, v_y_p);
    v_phi_O2 = atan_angle(v_z_O2, v_y_O2);
    phi = atan_angle(z,y);
    E_phi = atan_angle(Ez,Ey); %Electric field


    %*********************  Plot velocity and electric field vectors in
    %cylindrical system **************************
    vectors1 = quiver(x(1:step:end),sqrt(y(1:step:end).^2+z(1:step:end).^2), v_x_O(1:step:end), sqrt( v_y_O(1:step:end).^2 + v_z_O(1:step:end).^2 ).*cos( v_phi_O (1:step:end) - phi(1:step:end) ),'Autoscale','off','Color','r');
    vectors2 = quiver(x(1:step:end),sqrt(y(1:step:end).^2+z(1:step:end).^2), v_x_p(1:step:end), sqrt( v_y_p(1:step:end).^2 + v_z_p(1:step:end).^2 ).*cos( v_phi_p (1:step:end) - phi(1:step:end) ),'Autoscale','off','Color','b');
    vectors3 = quiver(x(1:step:end),sqrt(y(1:step:end).^2+z(1:step:end).^2),Ex(1:step:end), sqrt( Ey(1:step:end).^2 + Ez(1:step:end).^2 ).*cos( E_phi (1:step:end) - phi(1:step:end) ),'Autoscale','off','Color','g');
    grid on


    %************ Scaling factor for velocity vectors ****************
    hU = get(vectors1,'UData') ;
    hV = get(vectors1,'VData') ;
    set(vectors1,'UData',scale_velocity*hU,'VData',scale_velocity*hV) %************ Scaling factor for O+ velocity vectors ****************

    hU = get(vectors2,'UData') ;
    hV = get(vectors2,'VData') ;
    set(vectors2,'UData',scale_velocity*hU,'VData',scale_velocity*hV)  %************ Scaling factor for p velocity vectors ****************



    %************ Scaling factor for Electric field vectors ****************
    hU = get(vectors3,'UData') ;
    hV = get(vectors3,'VData') ;
    set(vectors3,'UData',scale_electric_field*hU,'VData',scale_electric_field*hV) 


    %**********  Legend  **************
    vectors1.DisplayName = 'O^+';
    vectors2.DisplayName = 'p';
    vectors3.DisplayName = '- [V_{bulk}xB]';
    plot1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot2.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot3.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot4.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend show

    %**********  Show stars and times on orbit plot  **************************
    plot(x(1:step_text:end), R_cyl_O(1:step_text:end),'*r') 
    text(double(x(1:step_text:end)), double(R_cyl_O(1:step_text:end)), datestr(epoch(1:step_text:end),'HH:MM:SS'),'FontSize',10,'Rotation',-45)
    % q3.DisplayName = 'O_2^+'
    % title('O^+ and p velocities')
    set(gca, 'FontSize',16)




    %******************* figure(1.2) Orbit and velocities vectors in YZ plane  **************
    subplot(2,3,4)
    t=(0:0.001:2*pi);
    plot3 = plot(cos(t),sin(t),'k');
    grid on
    xlabel('Y_{MSO}, R_M')
    ylabel('Z_{MSO}, R_M')
    axis equal tight
    hold on
    plot5 = plot(y,z);
    vectors4 = quiver(y(1:step:end),z(1:step:end),v_y_O(1:step:end), v_z_O(1:step:end),'Autoscale','off','DisplayName','O','Color','r');
    vectors5 = quiver(y(1:step:end),z(1:step:end),v_y_p(1:step:end), v_z_p(1:step:end),'Autoscale','off','Color','b');
    vectors6 = quiver(y(1:step:end),z(1:step:end),Ey(1:step:end), Ez(1:step:end),'Autoscale','off','Color','g');

    % qscale = 1.2*10^-3 ; % scaling factor for all vectors

    hU = get(vectors4,'UData') ;
    hV = get(vectors4,'VData') ;
    set(vectors4,'UData',scale_velocity*hU,'VData',scale_velocity*hV)
    hU = get(vectors5,'UData') ;
    hV = get(vectors5,'VData') ;
    set(vectors5,'UData',scale_velocity*hU,'VData',scale_velocity*hV) 


    % qscale_electric_field = 0.0001;
    hU = get(vectors6,'UData') ;
    hV = get(vectors6,'VData') ;
    set(vectors6,'UData',scale_electric_field*hU,'VData',scale_electric_field*hV) 

    %*************  Legend *************
    vectors4.DisplayName = 'O^+';
    vectors5.DisplayName = 'p';
    vectors6.DisplayName = '- [V_{bulk}xB]';
    plot1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot2.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot3.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot4.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot5.Annotation.LegendInformation.IconDisplayStyle = 'off';
    legend show

    %**********  Show stars and times on orbit plot  **************************
    text(double(y(1:step_text:end)),double(z(1:step_text:end)),datestr(epoch(1:step_text:end),'HH:MM:SS'),'FontSize',10,'Rotation',-90) 
    plot(y(1:step_text:end),z(1:step_text:end),'*r') 

    %**********  Plot properties *************
    xlim([-2 2])
    ylim([-0.5 2])
    set(gca, 'FontSize',16)



    %*******************   figure(1.3) **************
    subplot(2,3,2)
    t=(0:0.001:2*pi);
    plot3 = plot(cos(t),sin(t),'k');
    hold on
    plot4 = plot(y,z);
    xlabel('Y_{MSO}, R_M')
    ylabel('Z_{MSO}, R_M')
    axis equal tight
    hold on
    grid on
    vectors1 = quiver(y(1:step:end),z(1:step:end),Bly(1:step:end), Blz(1:step:end),'Autoscale','off','Color',[1 0 1]);
    plot3.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot4.Annotation.LegendInformation.IconDisplayStyle = 'off';
    vectors1.DisplayName = 'B';
    legend show
    text(double(y(1:step_text:end)),double(z(1:step_text:end)),datestr(epoch(1:step_text:end),'HH:MM:SS'),'FontSize',10,'Rotation',-90) 
    plot(y(1:step:end),z(1:step:end),'.r') 
    plot(y(1:step_text:end),z(1:step_text:end),'*k') 
    xlim([-2 2])
    ylim([-0.5 2])
    vectors1.DisplayName = 'B';
    set(gca, 'FontSize',16)

    qscale = 0.05 ; % scaling factor for O+ and p velocities vectors. 
    hU = get(vectors1,'UData') ;
    hV = get(vectors1,'VData') ;
    set(vectors1,'UData',qscale*hU,'VData',qscale*hV)



    %*******************   figure(1.4) Magnetic field angular distribution in YZ plan **************
    subplot(2,3,5)
    atan_Bz_to_By = atan(Bz./By)*180/pi;
    atan_Bz_to_By (By>=0 & Bz<0)=360 + atan_Bz_to_By (By>=0 & Bz<0);
    atan_Bz_to_By(By<0 & Bz>=0) =180 + atan_Bz_to_By(By<0 & Bz>=0);  %%% Here was ( - atan ). this was a mistake
    atan_Bz_to_By(By<0 & Bz<0)=180+atan_Bz_to_By(By<0 & Bz<0);
    h = rose(atan_Bz_to_By*pi/180,12);
    h.Color = [1 0 1];
    ylabel('-B_y')
    xlabel('-B_z')
    vec_pos = get(get(gca, 'XLabel'), 'Position');
    [N,edges]=histcounts(atan_Bz_to_By,12);
    edges_new = edges(1:end-1) + diff(edges)/2;
    set(gca, 'FontSize',16)

    %*******************   figure(1.5) Electric field angular distribution in YZ plane **************
    subplot(2,3,6)
    h=rose(atan_angle(Ez,Ey),12);
    h.Color='green';
    ylabel('-E_y')
    xlabel('-E_z')
    vec_pos = get(get(gca, 'XLabel'), 'Position');
    [N,edges]=histcounts(atan_Bz_to_By,12);
    edges_new = edges(1:end-1) + diff(edges)/2;
    set(gca, 'FontSize',16)
