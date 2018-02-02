function [Args, dscrp] = nO_divided_by_np_Args()
    
    field1 = 'LogScale';
    value1 = {{'off', 0}; {'on', 1}};
    field2 = 'File';
    value2 = {{'SQL', 'sql'}; {'d1_32e4d16a8m', 'd1'}}; %{filetype, path to the file}
    
    field_dscrp = 'description';
    value_dscrp = {'listbox', 'listbox'};
    
    Args = struct(field1, {value1}, field2, {value2});
    dscrp = struct(field_dscrp, {value_dscrp});