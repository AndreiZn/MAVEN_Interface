function [Args] = Magnetic_Field_Args()
    
    field1 = 'file';
    value1 = {{'c6_32e64m', ''}}; %{filetype, path to the file}
    
    Args = struct(field1, {value1});