function [table] = select_from_sql(login, password, database_name, col_in_database, date, start_time, stop_time)

    %conn = database.ODBCConnection('NASHE-VSIO', login, password);
    conn = database.ODBCConnection('NASHE-VSIO', '', '');
    
    time_year = date(8:11);
    timefrom = datenum([date, ' ', start_time]);
    timeto = datenum([date, ' ', stop_time]);
    ddayfrom = num2str(timefrom - datenum(['00-Jan-', time_year, ' 00:00:00']));
    ddayto = num2str(timeto - datenum(['00-Jan-', time_year, ' 00:00:00']));
    
    col_str = col_in_database{1};
    for i=2:numel(col_in_database)
        col_str = [col_str, ', ', col_in_database{i,1}];
    end
    
    sqlGetData = '';
    if strcmp(database_name, 'maven.mag')
        sqlGetData = strcat(['SELECT ', col_str, ', DDAY FROM ', database_name, ' where TIME_YEAR=', time_year,' and DDAY>=', ddayfrom,' and DDAY<=', ddayto]);
    elseif strcmp(database_name, 'maven.test')
        sqlGetData = strcat(['SELECT ', col_str, ', ts_dateNum FROM ', database_name, ' where ts_dateNum>=', num2str(timefrom), ' and ts_dateNum<=', num2str(timeto)]);
    end  
    
    t = 0; 
    
    %curs = exec(conn, sqlGetData); %curs = exec(conn,'SELECT * from maven.key_parameters');
    %curs = fetch(curs);
    %table = curs.Data;
    %close (curs);
    
    table = select(conn, sqlGetData);
    
    close(conn);