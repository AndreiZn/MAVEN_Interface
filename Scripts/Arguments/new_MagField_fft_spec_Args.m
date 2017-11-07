function [Args, dscrp] = new_MagField_fft_spec_Args()

    field1 = 'File'; %File! not 'file'
    value1 = {{'mag', ''}; {'', '.mat',}; {'', '.sts'}}; %{{filetype, path to the file}, {'', 'file extension}; ...}
    field2 = 'WindowSize';
    value2 = {{'String', ''}};
    field3 = 'NewFigure'; 
    value3 = {{'Yes', 1}; {'No', 0}}; 
    
    field_dscrp = 'description';
    value_dscrp = {'listbox', 'editbox', 'listbox'};
    
    Args = struct(field1, {value1}, field2, {value2}, field3, {value3});
    dscrp = struct(field_dscrp, {value_dscrp});