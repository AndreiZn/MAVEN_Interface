function [Args, dscrp] = Bx_divided_by_B_Args()
    
    field1 = 'File'; %File! not 'file'
    value1 = {{'SQL', 'sql',}; {'mag', 'mag'}; {'', '.sts'}}; %{filetype, path to the file}
    
    field_dscrp = 'description';
    value_dscrp = {'listbox'};
    
    Args = struct(field1, {value1});
    dscrp = struct(field_dscrp, {value_dscrp});