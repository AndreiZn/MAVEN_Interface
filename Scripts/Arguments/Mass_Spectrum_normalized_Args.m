function [Args, dscrp] = Mass_Spectrum_normalized_Args()

    field1 = 'Time';
    value1 = {{'String', ''}};
    field2 = 'File';
    value2 = {{'c6_32e64m', ''}; {'', '.'}};
    field3 = 'logscale';
    value3 = {{'on', 1}; {'off', 0}};
    
    field_dscrp = 'description';
    value_dscrp = {'editbox', 'listbox', 'listbox'};
    
    Args = struct(field1, {value1}, field2, {value2}, field3, {value3});
    dscrp = struct(field_dscrp, {value_dscrp});