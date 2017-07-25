function [Args, dscrp] = Eflux_Time_Spectrogram_Args()

    field1 = 'Mass';
    value1 = {{'H+', 1}; {'He+', 4}; {'C+', 12}; {'O+', 16}; {'O2+', 32}; {'CO2+', 44}};
    field2 = 'File';
    value2 = {{'c6_32e64m', ''}; {'', '.'}}; %{filetype, path to the file}
    
    field_dscrp = 'description';
    value_dscrp = {'listbox', 'listbox'};
    
    Args = struct(field1, {value1}, field2, {value2});
    dscrp = struct(field_dscrp, {value_dscrp});