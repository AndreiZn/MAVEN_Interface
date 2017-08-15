function init_variables(hObject) %initialization of variables
    
    handles = guidata(hObject);
    
    %Files and times:    
    handles.filename = '';
    handles.filefound = 0; %1 if a file of a necessary type and date was found
    handles.starttime = get(findobj('Tag', 'start_editbox'), 'String');
    handles.stoptime = get(findobj('Tag', 'stop_editbox'), 'String');
    
    %Current Axes:
    handles.currentaxes = [];
    handles.axeschosen = 0;
    handles.Sysmesnoaxes = 'Please choose an axis _';
    
    %Sliders:
    handles.slider_leftend = datenum(handles.starttime); handles.slider_rightend = datenum(handles.stoptime);
    handles.leftsliderflag = 0; handles.rightsliderflag = 0;
    
    % Handles needed for drag and drop objects:
    handles.dragging = [];
    handles.orPos = [0 0];
    
    % Handles related to size changing of axes:
    handles.border = 0; %==1 when CurrentPoint == border of some axis
    handles.ignoredragging = 0; %if it equals 1, axes shouldn't be moved
    handles.ignoresize_changing = 0; %if it equals 1, axes' sizes are not changing
    handles.once = struct('left', 0, 'right', 0, 'top', 0, 'bottom', 0, ... 
                          'topl', 0, 'topr', 0, 'botl', 0, 'botr', 0); % if handles.once.left equals 1, 
                         % then currently we are changing the left border position
    
    % initial y-distance between axes:
    ax1Pos = get(handles.axes1, 'Position'); ax2Pos = get(handles.axes2, 'Position'); height = ax2Pos(4);    
    handles.init_delta_y = ax1Pos(2) - ax2Pos(2) - height; %y difference between the top of axis2 and the bottom of ax1
    
    % delta-y fig_pos and starting)size_of_nale
    static_pos = get(handles.static_panel, 'Position'); static_pos = static_pos(4);
    scrollin_pos = get(handles.scrolling_panel, 'Position'); scrolling_pos = scrollin_pos(4);
    handles.delta_panels =  static_pos - scrolling_pos;
    
    % Mass handle:
    handles.masstype = 1; 
    % Masstypes: 1 - 1a.u. 
    %           2 - 4a.u.
    %           3 - 12a.u.
    %           4 - 16a.u.
    %           5 - 32a.u.
    %           6 - 38a.u.
    %           7 - 44a.u.
    
    %To save all information about arguments
    handles.Args = struct();
    
    %To save all information about plotted graphs and spectrograms
    handles.currentgraphs = [];
    
    % This line is sent to Sysmessages when a user didn't choose a folder
    % with files
    handles.Sysmesnofiles = ('The folder with files was not chosen');
    
    % handles of all axes available
    handles.axesav = {handles.axes1, handles.axes2, handles.axes3, handles.axes4, handles.axes5};
    
    %sum of heights of available axes
    handles.panelheight = height_of_axes(handles.axesav);
    handles.starting_size_of_panel = get(handles.scrolling_panel, 'Position');
    
    %This is for MassSpectrum
    handles.timecorrectness = 0; % = 1 if massspectime has the following format: 'HH:MM:SS' 
    handles.massspcparam = 0; %linear scale for the mass spectrum 
    
    % Update handles structure
    guidata(hObject, handles);
end

%function returns sum of heights of axes
function [res] = height_of_axes(axes)

    res = 0;
    for ind_hoa=1:size(axes, 2)
        pos = get (axes{ind_hoa}, 'Position');
        h = pos(4);
        res = res + h;
    end
    
end