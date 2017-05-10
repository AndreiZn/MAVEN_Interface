function [Args, dscrp] = Mass_Spectrum_Args()

    field1 = 'Time';
    value1 = {{'String', ''}};
    field2 = 'File';
    value2 = {{'c6_32e64m', ''}};
    
    field_dscrp = 'description';
    value_dscrp = {'editbox', 'listbox'};
    
    Args = struct(field1, {value1}, field2, {value2});
    dscrp = struct(field_dscrp, {value_dscrp});