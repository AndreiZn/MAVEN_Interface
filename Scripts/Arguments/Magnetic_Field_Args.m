function [Args, dscrp] = Magnetic_Field_Args()
    
    field1 = 'File';
    value1 = {{'c6_32e64m', ''}}; %{filetype, path to the file}
    
    field_dscrp = 'description';
    value_dscrp = {'listbox'};
    
    Args = struct(field1, {value1});
    dscrp = struct(field_dscrp, {value_dscrp});