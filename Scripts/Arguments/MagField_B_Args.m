function [Args, dscrp] = MagField_B_Args()

    field1 = 'File'; %File! not 'file'
    value1 = {{'mag', ''}; {'', '.mat',}; {'', '.sts'}}; %{{filetype, path to the file}, {'', 'file extension}; ...}
    
    field_dscrp = 'description';
    value_dscrp = {'listbox'};
    
    Args = struct(field1, {value1});
    dscrp = struct(field_dscrp, {value_dscrp});