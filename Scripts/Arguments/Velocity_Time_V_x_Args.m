function [Args, dscrp] = Velocity_Time_V_x_Args()
    
    field1 = 'Mass';
    value1 = {{'H+', 1}; {'He+', 4}; {'C+', 12}; {'O+', 16}; {'O2+', 32}; {'CO2+', 44}};
    field2 = 'LogScale';
    value2 = {{'off', 0}; {'on', 1}};
    field3 = 'File';
    value3 = {{'SQL', 'sql'}; {'d1_32e4d16a8m', 'd1'}}; %{filetype, path to the file}
    
    field_dscrp = 'description';
    value_dscrp = {'listbox', 'listbox', 'listbox'};
    
    Args = struct(field1, {value1}, field2, {value2}, field3, {value3});
    dscrp = struct(field_dscrp, {value_dscrp});