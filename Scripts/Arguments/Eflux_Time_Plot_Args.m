function [Args, dscrp] = Eflux_Time_Plot_Args()
    
    field1 = 'Mass';
    value1 = {{'H+', 1}; {'He+', 4}; {'C+', 12}; {'O+', 16}; {'O2+', 32}; {'CO2+', 44}};
    field2 = 'LogScale';
    value2 = {{'off', 0}; {'on', 1}};
    field3 = 'File';
    value3 = {{'c6_32e64m', ''}; {'', '.'}};
    
    field_dscrp = 'description';
    value_dscrp = {'listbox', 'listbox', 'listbox'};
    
    Args = struct(field1, {value1}, field2, {value2}, field3, {value3});
    dscrp = struct(field_dscrp, {value_dscrp});