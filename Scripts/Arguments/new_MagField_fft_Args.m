function [Args, dscrp] = new_MagField_fft_Args()

    field1 = 'File'; %File! not 'file'
    value1 = {{'mag', ''}; {'', '.mat',}; {'', '.sts'}}; %{{filetype, path to the file}, {'', 'file extension}; ...}
    field2 = 'NewFigure'; 
    value2 = {{'Yes', 1}; {'No', 0}}; 
    
    field_dscrp = 'description';
    value_dscrp = {'listbox',  'listbox'};
    
    Args = struct(field1, {value1}, field2, {value2});
    dscrp = struct(field_dscrp, {value_dscrp});