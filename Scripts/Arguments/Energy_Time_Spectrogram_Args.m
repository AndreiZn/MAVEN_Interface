function [Args, dscrp] = Energy_Time_Spectrogram_Args()

    field1 = 'Mass';
    value1 = {{'Cumulative', 0}; {'H+', 1}; {'He+', 4}; {'C+', 12}; {'O+', 16}; {'O2+', 32}; {'CO2+', 44}};
    field2 = 'LogScale';
    value2 = {{'on', 1}; {'off', 0}};
    field3 = 'File';
    value3 = {{'c6_32e64m', ''}}; %{filetype, path to the file}
    field4 = 'Colormap_min';
    value4 = {{'String', ''}};
    field5 = 'Colormap_max';
    value5 = {{'String', ''}};
    
    field_dscrp = 'description';
    value_dscrp = {'listbox', 'listbox', 'listbox', 'editbox', 'editbox'};
    
    Args = struct(field1, {value1}, field2, {value2}, field3, {value3}, field4, {value4}, field5, {value5});
    dscrp = struct(field_dscrp, {value_dscrp});