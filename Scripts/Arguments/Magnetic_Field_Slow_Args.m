function [Args] = Flux_Time_Spectrogram_Args()
    field1 = 'file';
    value1 = {{'mag', ''}}; %{filetype, path to the file}
    
    Args = struct(field1, {value1});
