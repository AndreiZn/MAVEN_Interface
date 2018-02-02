function [filename, message, error] = GetFile(chosenfunc, filetype, extensions, date, filefolderpath)
    
    files_final = {''};
    ind = 1;
    num_of_paths = numel(filefolderpath);
    
    while ( (isequal(files_final, {''}))&&(ind<=num_of_paths) )
        
        ffp = filefolderpath{ind};

        filename = '';

        datev = datevec(date); %datev = [2017 3 20 ...]

        year = num2str(datev(1)); % '2017'

        month = num2str(datev(2)); % '3'            
        if isequal(size(month, 2), 1)
            month = ['0', month];
        end            

        day = num2str(datev(3));
        if isequal(size(day, 2), 1)
            day = ['0', day];
        end 

        %filepath
        filepath = [ffp, '\', filetype,'\', year, '\',month];

        files = dir(filepath); %all files and folders from the address = filepath 
        files = {files(3:end).name}'; %delete first two folders, because they are always '.' and '..'
        assignin('base', 'fls', filepath)
        %checking whether the folder has any files
        if (isempty(files))
            message = ['There are no files of ', filetype, ' type for ', date, ' at ', ffp, ', which are necessary for ', chosenfunc];
            error = '1_no_files';
        else
            %find all files related to the chosen date
            %files2 will contain all files related to the date = 'date'              
            files2 = files_relatedto_date(files, year, month, day);

            % find files with necessary extension
            files3 = {''}; % this variable collects files with extension 'ext' (see below)

            for extension_ind = 1:numel(extensions)    
                if ~isequal(files3, {''}) %if files with one of the extensions were found
                    break
                else    
                    ext = extensions{extension_ind}(2); % extension. e.g, .mat
                    ext = ext{1}; % to make it a string                            
                    files3 = files_with_extension (files2, ext); % find file with extension 'ext' among files2
                end    
            end
            
            files_final = files3{1};
            
            if isequal(files_final, '')
                message = ['No files with ', ext, ' extension for the chosen date for the ', chosenfunc];
                error = '2_no_files_ext';
            end   
            
        end      
        
        ind = ind + 1;
        
    end
    
    if isequal(files_final, '')
        return
    end    
     
    % a path to the file:
    fpath = [filepath, '\', files_final];
    filename = fpath;
    message = ['"', files_final, '"', ' was successfully uploaded and the system is ready to plot ', chosenfunc];
    error = '0_no_error';
    
% This function gets file names, a year, a month and a day and returns those files from fls that contain 'ymd' 
function [fls2] = files_relatedto_date(fls, y, m, d)

    p_frd = 1;
    fls2{p_frd} = [];
    for ind_frd=1:size(fls, 1)
        if ( ~isempty( findstr([y,m,d], fls{ind_frd}) ) )
            fls2{p_frd} = fls{ind_frd};
            p_frd = p_frd + 1;
        end
    end    

function [fls_out] = files_with_extension (fls, extension) % find files with extension 'extension' among files 'fls'
    
    p_fwe = 1;
    fls_out{1} = '';
    for ind_fwe = 1:numel(fls)
        f = fls{ind_fwe}; % 'filename.ext' 
        k = strfind (f, extension);
        if ~isempty(k)
            fls_out{p_fwe} = f; 
            p_fwe = p_fwe + 1;
        end    
    end 