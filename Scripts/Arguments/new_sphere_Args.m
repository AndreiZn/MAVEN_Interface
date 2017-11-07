function [Args, dscrp] = new_sphere_Args()

    field1 = 'File'; %File! not 'file'
    value1 = {{'d1_32e4d16a8m', ''}; {'', '.cdf',}}; %{{filetype, path to the file}, {'', 'file extension}; ...}
    
    field_dscrp = 'description';
    value_dscrp = {'listbox'};
    
    Args = struct(field1, {value1});
    dscrp = struct(field_dscrp, {value_dscrp});