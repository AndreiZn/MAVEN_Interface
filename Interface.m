function varargout = Interface(varargin)
    % INTERFACE MATLAB code for Interface.fig
    %      INTERFACE, by itself, creates a new INTERFACE or raises the existing
    %      singleton*.
    %
    %      H = INTERFACE returns the handle to a new INTERFACE or the handle to
    %      the existing singleton*.
    %
    %      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in INTERFACE.M with the given input arguments.
    %
    %      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before Interface_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to Interface_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help Interface

    % Last Modified by GUIDE v2.5 25-Apr-2017 23:09:26

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ... 
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Interface_OpeningFcn, ...
                       'gui_OutputFcn',  @Interface_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
end

% --- Executes just before Interface is made visible.
function Interface_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Interface (see VARARGIN)
     
    handles = guidata(hObject);
    
    % Files and times:    
    handles.filename = '';
    handles.filefound = 0; %1 if a file of a necessary type and date was found
    handles.starttime = get(findobj('Tag', 'start_editbox'), 'String');
    handles.stoptime = get(findobj('Tag', 'stop_editbox'), 'String');
    
    % Current Axes:
    handles.currentaxes = [];
    handles.axeschosen = 0;
    handles.Sysmesnoaxes = 'Please choose an axis _';
    
    % Sliders:
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
    
    % initial y-pos of the axis1
    handles.init_ax1_pos = ax1Pos;
    
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
    
    % To save all information about arguments
    handles.Args = struct();
    
    % To save all information about plotted graphs and spectrograms
    handles.currentgraphs = [];
    
    % This line is sent to Sysmessages when a user didn't choose a folder
    % with files
    handles.Sysmesnofiles = ('The folder with files was not chosen');
    
    % handles of all axes available
    handles.axesav = {handles.axes1, handles.axes2, handles.axes3, handles.axes4, handles.axes5};
    
    % sum of heights of available axes
    handles.starting_size_of_panel = get(handles.scrolling_panel, 'Position');
    
    % 0 if AxesDesign menu is not open, 1 when it's open
    handles.AxDesignOpen = 0;
    
    SetAllButtonDownFcn(hObject, handles);
    
    % Set the current data value.
    % Choose default command line output for Interface
    handles.output = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
    
    %delete files of *.asv type
    cd('./Scripts')
    delete *.asv
    cd ('./Arguments')
    delete *.asv
    cd ('../../')
    
    %To save handles of objects that appear when working with arguments of
    %functions
    handles.argobj = uipanel ('Position',[.1 .1 0 0]); %creating an empty handle
    
    %Opening a folder with all files. If you don't add guidata here,
    %Interface will display an error when moving a mouse.
    handles.filefolderpath = uigetdir('', 'Choose a folder with files');

    if (~isequal(handles.filefolderpath, 0))
        handles.filefolderchosen = 1;
        Sysmessage(['The folder "', handles.filefolderpath, '" was chosen'])
    else
        handles.filefolderchosen = 0;
    end    
    guidata(hObject, handles);
    
    listbox2_CreateFcn(findobj('Tag', 'listbox2'), eventdata, handles)
    listbox2_Callback(findobj('Tag', 'listbox2'), eventdata, handles);
    
end 

% --- Outputs from this function are returned to the command line.
function varargout = Interface_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% Start_time editbox
function start_editbox_Callback(hObject, eventdata, handles)

    if (handles.leftsliderflag==0)        
        userstarttime = get(hObject, 'String');
        format = '\d\d:\d\d:\d\d';
        if (~isempty(regexp(userstarttime,format, 'once')))  %format: HH:MM:SS       
            handles.starttime = userstarttime; 
            Sysmessage(['Start time = ', userstarttime, ' _']) 
        else
            Sysmessage('Error! Time format is HH:MM:SS')
        end        
    else
        handles.leftsliderflag = 0; 
        set (hObject, 'String', handles.starttime)
    end
    
    guidata(hObject, handles);
    
    listbox2_Callback(findobj('Tag', 'listbox2'), eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function start_editbox_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

% Stop_time editbox
function stop_editbox_Callback(hObject, eventdata, handles)

    if (handles.rightsliderflag==0)        
        userstoptime = get(hObject, 'String');
        format = '\d\d:\d\d:\d\d';
        if (~isempty(regexp(userstoptime, format, 'once')))  %format: HH:MM:SS       
            handles.stoptime = userstoptime; 
            Sysmessage(['Stop time = ', userstoptime, ' _']) 
        else
            Sysmessage('Error! Time format is HH:MM:SS')            
        end
    else
        handles.rightsliderflag = 0; 
        set (hObject, 'String', handles.stoptime)
    end
    
    guidata(hObject, handles);
    
    listbox2_Callback(findobj('Tag', 'listbox2'), eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function stop_editbox_CreateFcn(hObject, eventdata, handles)
    
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

% --- Executes on time-slider movement.
function slider2_Callback(hObject, eventdata, handles) %start_time slider

    timenum = (handles.slider_rightend - handles.slider_leftend)*get(hObject, 'Value') + handles.slider_leftend;
    handles.starttime = datestr(timenum, 'HH:MM:SS');
    handles.leftsliderflag = 1;
    guidata(hObject, handles);
    start_editbox_Callback(findobj('Tag', 'start_editbox'), eventdata, handles);

    %automatic plot (without pressing the button "Plot"
    plotbutton_Callback (findobj('Tag', 'plotbutton'), eventdata, handles)
    handles.slider_leftend = datenum(handles.starttime); handles.slider_rightend = datenum(handles.stoptime);
    guidata(hObject, handles);
    SetAllButtonDownFcn(hObject, handles);
    set(findobj('Tag', 'slider2'), 'Value', 0)
    set(findobj('Tag', 'slider3'), 'Value', 1)
    
end

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
    
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
end

% --- Executes on time-slider movement.
function slider3_Callback(hObject, eventdata, handles) %stop_time slider

    timenum = (handles.slider_rightend - handles.slider_leftend)*get(hObject, 'Value') + handles.slider_leftend;
    handles.stoptime = datestr(timenum, 'HH:MM:SS');
    handles.rightsliderflag = 1;
    guidata(hObject, handles);
    stop_editbox_Callback(findobj('Tag', 'stop_editbox'), eventdata, handles);

    %automatic plot (without pressing the button "Plot"
    plotbutton_Callback (findobj('Tag', 'plotbutton'), eventdata, handles)
    handles.slider_leftend = datenum(handles.starttime); handles.slider_rightend = datenum(handles.stoptime);
    guidata(hObject, handles);
    SetAllButtonDownFcn(hObject, handles);
    set(findobj('Tag', 'slider2'), 'Value', 0)
    set(findobj('Tag', 'slider3'), 'Value', 1)
    
end

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

end

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
end

% This function sets a ButtonDownFunction - so that axes can be moved
function SetAllButtonDownFcn (hObject, handles)    
    
    for ind_sabdf=1:numel(handles.axesav)
        set (handles.axesav{ind_sabdf}, 'ButtonDownFcn',@axes_ButtonDownFcn);
    end
    
end

function surface_ButtonDownFcn(hObject, eventdata, handles)
    %h = get (hObject, 'Parent');
    %axes_ButtonDownFnc(h, eventdata)
end

function axes_ButtonDownFcn(hObject, eventdata)
    
    handles = guidata(hObject);
    % What is being dragged
    handles.dragging = hObject;
    handles.orPos = get(gcf,'CurrentPoint');
    
    if (handles.border==0)&&(handles.ignoredragging==0)
        % handles.currentaxes is passed to plots
        handles.currentaxes = hObject;
        handles.axeschosen = 1; 

        % Colors of all axes should be white, except for the current axis 
        SetAxesColors(handles.axesav, handles.currentaxes)
        set(hObject, 'Color', [1 0.97 0.92])
        
        % ignore size changing
        handles.ignoresize_changing = 1;
    end
    
    if (handles.border==1)&&(handles.ignoresize_changing==0)
        handles.ignoredragging = 1; %ignore dragging; now, dragging may take effect only after ButtonUpFnc 
    end
    
    guidata(hObject, handles);
    
end

function SetAxesColors (axs, curax)

    for ind_sac=1:numel(axs)
        a = axs{ind_sac};
        if (~isequal(a, curax))
            set (a, 'Color', 'White')
        end    
    end 
    
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
    
    handles.dragging = [];
    handles.ignoresize_changing = 0; % sizes of axes can be changed again
    handles.ignoredragging = 0; % axes can be dragged again
    handles.once = struct('left', 0, 'right', 0, 'top', 0, 'bottom', 0, ... 
                          'topl', 0, 'topr', 0, 'botl', 0, 'botr', 0); % if handles.once.left equals 1, 
                         % then currently we are changing the left border position
                         
    guidata(hObject, handles);
    
    % update AxesDesign menu if it was already opened
    if handles.AxDesignOpen == 1
        AxesDesign(hObject, handles);
    end
end

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
    
    %Pointer Position
    handles.scrolling_panel_pos = get(handles.scrolling_panel, 'Position');
    displ = handles.scrolling_panel_pos(4) - handles.starting_size_of_panel(4); %displacement
    %newPos = get(gcf,'CurrentPoint') + displ;
    newPos = get(gcf,'CurrentPoint');
    posDiff = newPos - handles.orPos;
    handles.orPos = newPos; 
    p_x = newPos(1);
    p_y = newPos(2) + displ*get(findobj('Tag', 'panel_slider'), 'Value');
    
    if (handles.ignoresize_changing == 0)
        
        for ind=1:numel(handles.axesav)
            % Axis position
            ax_pos = get(handles.axesav{ind}, 'Position');
            ax_x = ax_pos(1);
            ax_y = ax_pos(2);
            ax_width = ax_pos(3);
            ax_height = ax_pos(4);

            % Pointer changes from 'arrow' to 'top' or 'left' if p_x and p_y ==
            % or close to ax_width or ax_height. So they belong to some range,
            % which is determined by delta_x and delta_y:
            delta_x = 2.5;
            delta_y = 1;

            % border conditions
            % real border:
            min_left = p_x>ax_x+0.65*delta_x; 
            max_right = p_x<ax_x+ax_width+1.1*delta_x;
            min_bottom = p_y>ax_y+0.28*delta_y;
            max_top = p_y<ax_y+ax_height+0.6*delta_y;
            % make the border a bit thicker than one pixel for convinience:
            left_border = (min_left)&&(p_x<ax_x+1.4*delta_x);
            right_border = (p_x>ax_x+ax_width)&&(max_right);
            bottom_border = (min_bottom)&&(p_y<ax_y+delta_y);
            top_border = (p_y>ax_y+ax_height-0.2*delta_y)&&(max_top);

            % additional conditions
            between_lr = (min_left)&&(max_right);
            between_ud = (min_bottom)&&(max_top);

            % Set handles.border. 1 if it's a border, 0 if it's not.
            if (right_border||left_border||bottom_border||top_border)&&(between_lr&&between_ud)
                handles.border = 1;
                break %if it's true for at least one axes, break
            else
                handles.border = 0;
                set(gcf, 'Pointer', 'arrow')
            end
        end

        % Set the Pointer to 'top', 'left', etc., if CurrentPoint is a border
        if ((left_border&&(~right_border)&&(~top_border)&&(~bottom_border)&&between_ud) || handles.once.left == 1)
            set(gcf, 'Pointer', 'left')            
            if ~isempty(handles.dragging)
                handles.once.left = 1;
                set(handles.dragging, 'Position', get(handles.dragging,'Position') + [posDiff(1) 0 -posDiff(1) 0]);
            end    
        elseif ((right_border&&(~left_border)&&(~top_border)&&(~bottom_border)&&between_ud) || (handles.once.right == 1))
            set(gcf, 'Pointer', 'right')            
            if ~isempty(handles.dragging)
                handles.once.right = 1;
                set(handles.dragging, 'Position', get(handles.dragging,'Position') + [0 0 posDiff(1) 0]);
            end        
        elseif (top_border&&(~left_border)&&(~right_border)&&(~bottom_border)&&between_lr) || (handles.once.top == 1)
            set(gcf, 'Pointer', 'top')            
            if ~isempty(handles.dragging)
                handles.once.top = 1;
                set(handles.dragging, 'Position', get(handles.dragging,'Position') + [0 0 0 posDiff(2)]);
            end
        elseif (bottom_border&&(~left_border)&&(~right_border)&&(~top_border)&&between_lr) || (handles.once.bottom == 1)
            set(gcf, 'Pointer', 'bottom')            
            if ~isempty(handles.dragging)
                handles.once.bottom = 1;
                set(handles.dragging, 'Position', get(handles.dragging,'Position') + [0 posDiff(2) 0 -posDiff(2)]);
            end
        end

        % Set the Pointer to 'topl' or 'topr', if CurrentPoint is a corner
        if (right_border&&top_border) || (handles.once.topr == 1)
            set(gcf, 'Pointer', 'topr')            
            if ~isempty(handles.dragging)
                handles.once.topr = 1;
                set(handles.dragging, 'Position', get(handles.dragging,'Position') + [0 0 posDiff(1) posDiff(2)]);
            end
        elseif (left_border&&bottom_border) || (handles.once.botl == 1)
            set(gcf, 'Pointer', 'botl')
            if ~isempty(handles.dragging)
                handles.once.botl = 1;
                set(handles.dragging, 'Position', get(handles.dragging,'Position') + [posDiff(1) posDiff(2) -posDiff(1) -posDiff(2)]);
            end
        elseif (left_border&&top_border) || (handles.once.topl == 1)
            set(gcf, 'Pointer', 'topl')
            if ~isempty(handles.dragging)
                handles.once.topl = 1;
                set(handles.dragging, 'Position', get(handles.dragging,'Position') + [posDiff(1) 0 -posDiff(1) posDiff(2)]);
            end
        elseif (right_border&&bottom_border) || (handles.once.botr == 1) 
            set(gcf, 'Pointer', 'botr')
            if ~isempty(handles.dragging)
                handles.once.botr = 1;
                set(handles.dragging, 'Position', get(handles.dragging,'Position') + [0 posDiff(2) posDiff(1) -posDiff(2)]);
            end
        end                 
    end
    
    % Dragging
    if (~isempty(handles.dragging))&&(handles.border == 0)&&(handles.ignoredragging==0)
        set(handles.dragging, 'Position', get(handles.dragging,'Position') + [posDiff(1:2) 0 0]);
    end
    
    SetAllButtonDownFcn(hObject, handles);
    
    guidata(hObject, handles);
    
end

% change all axes colors to white when clicking on the scrolling_panel.
% currentaxis becomes []
function scrolling_panel_ButtonDownFcn(hObject, eventdata, handles)
    
    handles = guidata(hObject);    
    handles.currentaxes = [];
    handles.axeschosen = 0;
    SetAxesColors(handles.axesav, handles.currentaxes)
    
    guidata(hObject, handles);
    
end

% change all axes colors to white when clicking on the static_panel.
% currentaxis becomes []
function static_panel_ButtonDownFcn(hObject, eventdata, handles)

    scrolling_panel_ButtonDownFcn(hObject, eventdata, handles);
    
end

% This function gets file names, a year, a month and a day and returns those files from fls that contain 'ymd' 
function [fls2] = files_relatedto_date(fls, y, m, d)

    p_frd = 1;
    fls2{p_frd} = [];
    for ind_frd=1:size(fls, 1)
        if ( ~isempty( findstr([y,m,d], fls{ind_frd}) ) )
            fls2{p_frd} = fls{ind_frd};
            p_frd = p_frd + 1;
        end
    end
    
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox2
    
    %delete all previously created objects with information about arguments.  
    delete(handles.argobj);
    handles.argobj = uipanel ('Position',[.1 .1 0 0]); %creating an empty handle
    
    contents = cellstr(get(hObject,'String')); %content of the listbox2
    handles.chosenfunc = contents{get(hObject,'Value')};
    cd ('./Scripts/Arguments') %move to the "Scripts"
    [handles.Args, dsc] = feval ([contents{get(hObject,'Value')}, '_Args']); %Args has all information about arguments of the function "contents{get(hObject,'Value')}"
    cd ('../../') %get back to the main folder
    
    if (handles.filefolderchosen == 1)
    
        fieldnms = fieldnames (handles.Args);
        handles.dscrp = dsc.description; % it's a 1x(numel(fieldnms)) cell with description of arguments: {'listbox', 'listbox', 'editbox', ...}
        for i = 1:size(fieldnms, 1)
            
            dscrp_i = handles.dscrp{i}; % to make it a string 'editbox'
            
            if strcmp(dscrp_i, 'listbox')
                
                field_i = fieldnms(i); %field_i is a cell 1x1
                field_i = field_i{1}; %field_i becomes a string
                args_i = handles.Args.(field_i); %get all args from the i-field

                str = cell(1, size(args_i, 1)); %preliminary creation of the str, which is described below  
                for j = 1:size(args_i,1)
                    str(j) = args_i{j}(1); %str will collect all names of arguments. 
                                           %That's what we see in a new listbox. For example, for Args.mass str contains of 'H+', 'He+', 'O+' and so on.   
                end

                %panel which is used only to display a name of an argument
                panelname = field_i; %name of a new panel
                handles.argpanel(i) = uipanel ('Title',panelname,'FontSize',11,...
                          'BackgroundColor','white', 'Units', 'characters',...
                          'Position', [212 (39.7-7*(i-1)) 25 4.5]); %[.856 (.812-.102*i) .10 .09]);

                %list of arguments      
                handles.lst_with_args(i) = uicontrol('Style','listbox','FontSize', 9,... 
                          'Units', 'characters', 'Position', [212 (38.4-7*(i-1)) 25 4.5],... %,[1180 (600-75*i) 136 50],...
                          'String',str); 

                %it's necessary to save all objects created to delete them later. 
                %This information is saved in handles.argobj      
                handles.temphndl = [handles.argpanel(i), handles.lst_with_args(i)];
                handles.argobj = [handles.argobj, handles.temphndl];       

                if (isequal(field_i, 'File'))

                    filetype = args_i{1}(1); % because that's how the file-wise part of Args looks like: field1 = 'filetype'; value1 = {{'c6', ''}}; Args = struct(field1, {value1});
                    %so we get, for example,  'c6' out of it.
                    filetype = filetype{1}; %to make it a sring

                    %getting the date            
                    date = get(findobj('Tag', 'date_editbox'), 'String'); %date has a format of 20-Mar-2017
                    datev = datevec(date); %datev = [2017 3 20 ...]
                    handles.year = num2str(datev(1)); % '2017'

                    handles.month = num2str(datev(2)); % '3'            
                    if isequal(size(handles.month, 2), 1)
                        handles.month = ['0', handles.month];
                    end            

                    handles.day = num2str(datev(3));
                    if isequal(size(handles.day, 2), 1)
                        handles.day = ['0', handles.day];
                    end 


                    %filepath
                    filepath = [handles.filefolderpath, '\', filetype,'\', handles.year, '\', handles.month];

                    files = dir(filepath); %all files and folders from the address = filepath 
                    files = {files(3:end).name}'; %delete first three folders, because they are always '.' and '..'

                    %checking whether the folder has any files
                    if (isempty(files))
                        message = ['There are no files of ', filetype, ' type for ', date, ' at ', handles.filefolderpath, ', which are necessary for ', handles.chosenfunc];
                        Sysmessage(message); %send message to the Sysmessage edit box
                        handles.filefound = 0; %a file was not found
                    else
                        %find all files related to the chosen date
                        %files2 will contain all files related to the date = 'date'              
                        files2 = files_relatedto_date(files, handles.year, handles.month, handles.day);
                        files2 = files2{1}; %if files2 still has several files we choose the first one                

                        %checking whether the folder has necessary files
                        if (isempty(files2))
                            message = ['There are no files of ', filetype, ' type for ', date, ' at ', handles.filefolderpath, ', which are necessary for ', handles.chosenfunc];
                            Sysmessage(message); %send message to the Sysmessage edit box
                            handles.filefound = 0; %a file was not found
                        else
                            %finally, a path to the file:
                            fpath = [filepath, '\', files2];
                            handles.Args.(field_i){1}{2} = fpath;                    
                            handles.filename = fpath;
                            Sysmessage(['"', files2, '"', ' was successfully uploaded and the system is ready to plot ', handles.chosenfunc]);
                            handles.filefound = 1; %a file was found
                        end
                    end 
                end % if field_i == 'file'
            end % if dscrp == 'listbox'
            
            if strcmp(dscrp_i, 'editbox')
                
                % title-panel
                handles.argpanel(i) = uipanel ('Title',fieldnms{i},'FontSize',11,...
                          'BackgroundColor','white', 'Units', 'characters',...
                          'Position', [212 (39.7-7*(i-1)) 25 4.5]); %[.856 (.812-.102*i) .10 .09]);
                %list of arguments      
                handles.edbox(i) = uicontrol('Style','edit','FontSize', 9,... 
                          'Units', 'characters', 'Position', [212 (38.4-7*(i-1)) 25 4.5],...
                          'HorizontalAlignment', 'left', 'String', '');
                
                %it's necessary to save all objects created to delete them later. 
                %This information is saved in handles.argobj      
                handles.argobj = [handles.argobj, handles.edbox];  
            end  % end of: if strcmp(dscrp_i, 'editbox')             
        end % for loop (fieldnms)
    else   
        Sysmessage (handles.Sysmesnofiles)
    end   
    
    guidata(hObject, handles);
    
end

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    listing = dir('./Scripts'); %all files and folders from the "address = './Scripts'" 
    Scripts = {listing(4:end).name}'; %delete first three folders, because they are always '.', '..' and 'Arguments'
    for j = 1:size(Scripts, 1)
        Scripts{j} = Scripts{j}(1:(end-2)); %delete last two symbols from names of files, because they always have '.m' as last two symbols 
    end
    set (hObject, 'String', Scripts) 
    
end

% "Plot" button
% --- Executes on button press in plotbutton.
function plotbutton_Callback(hObject, eventdata, handles)
    
    if (handles.axeschosen == 1)
        if (handles.filefolderchosen == 1)
            if (handles.filefound == 1)
                
                lst_with_fncts = findobj('Tag', 'listbox2'); %lst_with_fncts - listbox with function names
                contents = cellstr(get(lst_with_fncts,'String'));%all names of functions from the listbox with functions
                chosen_fnct = contents{get(lst_with_fncts,'Value')}; %a user chose a function "chosen_fnct" 

                %getting all of values of arguments chosen by a user
                fieldnms = fieldnames(handles.Args);

                specific_args = cell(1, size(fieldnms, 1)); % specific_args saves arguments' values to pass to a function
                chosen_Args = handles.Args; % the same as specific_args, but with field_nms, while sp_args consist only of values
                % specific_args are passed to Scripts. Scripts don't care
                % about filednames; chosen_Args are more convinient to use,
                % for example, in rebuild_all function
                % chosen_Args is initialized as handles.Args to get the
                % correct structure
                
                for i = 1:size(fieldnms, 1)
                    
                    if strcmp(handles.dscrp{i}, 'listbox')
                        
                        field_i = fieldnms(i); %field_i is a cell 1x1
                        field_i = field_i{1}; %field_i becomes a string
                        args_i = handles.Args.(field_i); %get all args from the i-field
                        j = get(handles.lst_with_args(i),'Value');
                        temp = args_i{j}(2); %temp is a cell 1x1
                        specific_args{1, i} = temp{1}; %temp{1} is a string

                        chosen_Args.(field_i) = args_i{j};
                    end
                    
                    if strcmp(handles.dscrp{i}, 'editbox')
                        
                        field_i = fieldnms{i}; % e.g. 'Colormap'
                        args_i = handles.Args.(field_i);
                        
                        str = get (handles.edbox(i), 'String'); % user's input
                        assignin('base', 'args_i', args_i)
                        args_i{1}{2} = str;
                        
                        specific_args{1, i} = str;
                        chosen_Args.(field_i) = args_i; 
                    end
                    
                    assignin('base', 'spec_Args', specific_args)
                    assignin('base', 'chosen_Args', chosen_Args)
                end
                
                Sysmessage (['Please wait. "', chosen_fnct, '" is being plotted'])
                %run the chosen_fnct with arguments from the "Scripts" Folder
                cd('./Scripts')
                feval(chosen_fnct, handles.currentaxes, handles.starttime, handles.stoptime, handles.filename, specific_args)
                cd('../') %get back to the main folder
                Sysmessage ([chosen_fnct, ' was successfully plotted _'])
                
                % add info about the plotted graph to handles.currentgraphs
                if (isempty(handles.currentgraphs)) % handles.currentgraphs is initialized with empty fields to set the structure of this variable
                    handles.currentgraphs = struct('Script', {chosen_fnct}, 'Axes', handles.currentaxes, 'Args', chosen_Args); %this empty line is rewritten
                else 
                    handles.currentgraphs = [handles.currentgraphs, struct('Script', {chosen_fnct}, 'Axes', handles.currentaxes, 'Args', chosen_Args)];
                end            
                
                %handles.filefound = 0; % otherwise mistakes are possible, e.g., 
                % if in *_Args 'File' had been written as 'file', program would have plotted
                % *.m, but using a wrong file
                %handles.filename = ''; 
                
                assignin('base', 'currentgraphs', handles.currentgraphs)

                SetAllButtonDownFcn(hObject, handles);
                
                guidata(hObject, handles);
                
            else
                Sysmessage('There are no files of the necessary type for the chosen date _'); %send message to the Sysmessage edit box
            end    
        else   
            Sysmessage (handles.Sysmesnofiles)
        end
    else
        Sysmessage (handles.Sysmesnoaxes)
    end
    
end

% --- Executes on button press in rebuild_all.
function rebuild_all_Callback(hObject, eventdata, handles)
    
    if (handles.filefolderchosen == 1)
        if (handles.filefound == 1)
            
            Sysmessage('Please wait. The graphs are being rebuilt _')
            
            for i=1:numel(handles.currentgraphs)

                % get all info about i-currentgraph
                fnct = handles.currentgraphs(i).Script; 
                ax = handles.currentgraphs(i).Axes;
                file = handles.currentgraphs(i).Args.file; %file structure
                filename = file{1,2};

                % get all of values of arguments
                args = handles.currentgraphs(i).Args;
                fieldnms = fieldnames(args);
                specific_args = cell(1, size(fieldnms, 1));%specific_args saves arguments' values to pass to a function
                for index = 1:size(fieldnms, 1)
                    field_ind = fieldnms(index); %field_ind is a cell 1x1
                    field_ind = field_ind{1}; %field_ind becomes a string
                    args_ind = args.(field_ind); %get all args from the ind-field  
                    specific_args{1, index} = args_ind{1,2}; % get the value  
                end

                %runc the chosen_fnct with arguments from the "Scripts" Folder
                cd('./Scripts')
                feval(fnct, ax, handles.starttime, handles.stoptime, filename, specific_args)
                cd('../') %get back to the main folder

            end
            
            Sysmessage ('The graphs were successfully rebuilt _')
            
            set(findobj('Tag', 'slider2'), 'Value', 0)
            set(findobj('Tag', 'slider3'), 'Value', 1)
        else
            Sysmessage('There are no files of the necessary type for the chosen date _');
        end    
    else
        Sysmessage (handles.Sysmesnofiles)
    end
    
    SetAllButtonDownFcn(hObject, handles);
    
    guidata(hObject, handles);

end

%Button "Clear out the axes"
% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)

    delete_ind = []; %delete_ind will contain rows to be deleted from handles.currentgraphs
    lim = numel(handles.currentgraphs); 
    for i = 1:lim
        if (handles.currentgraphs(i).Axes == handles.currentaxes) %compare an axes chosen by a user and i-axes in currentgraphs             
            delete_ind = [delete_ind, i]; %handles.currentgraphs(i) = [];
        end
    end
    
    for j = numel(delete_ind):-1:1
        handles.currentgraphs(delete_ind(j)) = []; %clear rows from handles.currentgraphs
    end    
    cla(handles.currentaxes, 'reset') %clear the axes
    
    SetAllButtonDownFcn(hObject, handles);
    
    guidata(hObject, handles);
    
end

function edit4_Callback(hObject, eventdata, handles)
    usertime = get(hObject, 'String');
        if (size (usertime, 2) == 8) %if it has the format of 'HH:MM:SS'
            handles.timecorrectness = 1; 
            handles.timemassspc = closesttime (handles.epoch, usertime);
            guidata(hObject, handles);
            set (hObject, 'String', datestr(handles.epoch(handles.timemassspc), 'HH:MM:SS'))
            cd ('./Aux_Fncs')
            Flux_Mass_Plot(handles.currentaxes, handles.filename, handles.timemassspc, handles.massspcparam);
            cd('../')
            set(findobj('Tag', 'checkbox7'),'Value', 1)
            SetAllButtonDownFcn(hObject, handles);
        else
            set (hObject, 'String', 'Error! Format is HH:MM:SS')
            handles.timecorrectness = 0; 
            guidata(hObject, handles);
        end
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
    if (get(findobj('Tag', 'checkbox2'),'Value')==0)
        handles.massspcparam = 0;
        guidata(hObject, handles);
        if (handles.timecorrectness == 1)
            cd ('./Aux_Fncs')
            Flux_Mass_Plot(handles.currentaxes, handles.filename, handles.timemassspc, handles.massspcparam);
            cd ('../')
            SetAllButtonDownFcn(hObject, handles);
        end
    else
        handles.massspcparam = 1;
        guidata(hObject, handles);
        if (handles.timecorrectness == 1)
            cd ('./Aux_Fncs')
            Flux_Mass_Plot(handles.currentaxes, handles.filename, handles.timemassspc, handles.massspcparam);
            cd ('../')
            SetAllButtonDownFcn(hObject, handles);
        end
    end    
end


% Save as a picture (screencapture)
% --- Executes on button press in save_as_pic_button.
function save_as_pic_button_Callback(hObject, eventdata, handles)

    img = feval('screencapture', handles.figure1, [42 -150 1165 882]);
    [FileName, FilePath] = uiputfile({'*.png'}, 'Save as', './ScreenShots/NewShot');  
    cd('./ScreenShots')
    imwrite (img, [FilePath, FileName])
    cd('../')
    
end

%"Date" editbox 
function date_editbox_Callback(hObject, eventdata, handles)  

    %checking the format, it should be like '21-Mar-2017'
    format = '[0-3]\d-(Jan|Feb|Mar|...|Dec)-\d\d\d\d';
    str = get(findobj('Tag', 'date_editbox'), 'String'); %String in date_editbox
    if (~isempty(regexp(str,format, 'once')))
        listbox2_Callback(findobj('Tag', 'listbox2'), eventdata, handles);       
    else
        Sysmessage('Error! Date format is dd-Mmm-yyy');
    end
    
end


% --- Executes during object creation, after setting all properties.
function date_editbox_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


% --- Executes on button press in calendarbutton.
function calendarbutton_Callback(hObject, eventdata, handles)

    h = uicalendar('Weekend',  [1 0 0 0 0 0 1], ...
                      'InitDate', datetime('1-Oct-2014'), ...  
                      'DestinationUI', findobj('Tag', 'date_editbox'));
    uiwait(h);
    date_editbox_Callback(findobj('Tag', 'date_editbox'), eventdata, handles);
    
end


% --- Executes during object creation, after setting all properties.
function calendarbutton_CreateFcn(hObject, eventdata, handles)
    hObject.CData = imread('calendar.png');
end

%This function sends line to the Sysmessage edit box
function Sysmessage(line)

    hEdit = findobj('Tag', 'Sysmessage');
    str = get(hEdit, 'String');
    time = [datestr(datetime('now'), 'HH:MM:SS'), ':> '];
    if (isempty(str))
        str = char({[time, line]});
    else        
        str = char({str, [time, line]});
    end
    set(hEdit, 'String', str)
    
    %We want to Set (hEdit, 'Sliderposition', 'bottom'); Implementation:
    jhEdit = feval('findjobj', hEdit); % Get the underlying Java control peer (a scroll-pane object)
    jEdit = jhEdit.getComponent(0).getComponent(0); % Get the scroll-pane's internal edit control
    jEdit.setCaretPosition(jEdit.getDocument.getLength); % Now move the caret position to the end of the text

end

function Sysmessage_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function Sysmessage_CreateFcn(hObject, eventdata, handles)    

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end    
    
    set(hObject, 'String', '')

end

% --- Executes on slider movement.
function panel_slider_Callback(hObject, eventdata, handles)

    %Get slider's position 
    sl_pos = get(hObject, 'Value'); 
    %Get scrolling_panel position  (to be moved)
    panel_pos = get(handles.scrolling_panel, 'Position'); 
    %Get static_panel position
    fig_pos = get(handles.static_panel, 'Position'); 
    
    max_pos = fig_pos - handles.starting_size_of_panel - handles.delta_panels;
    max_pos = max_pos(4);
    set(handles.scrolling_panel, 'Position', [panel_pos(1), max_pos*(1-sl_pos), panel_pos(3), panel_pos(4)]);
    
    guidata(hObject, handles);
    
end

% --- Executes during object creation, after setting all properties.
function panel_slider_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
end

% --- Executes during object creation, after setting all properties.
function savebutton_CreateFcn(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function plotbutton_CreateFcn(hObject, eventdata, handles)
end

% Find the highest axes
function [ha] = highest_axes(axs)
    
    if (~isempty(axs))
        pos = get (axs{1}, 'Position');
        max_y = pos(2);
        ha = axs{1};
        for ind_ha=2:size(axs, 2)
            pos = get (axs{ind_ha}, 'Position');
            if (pos(2)>max_y)
                max_y = pos(2);
                ha = axs{ind_ha};
            end    
        end
    else
        ha = '';
    end
    
end

% --- Executes on button press in NewAxis.
function NewAxis_Callback(hObject, eventdata, handles)    
    
    % There are two panels. One is moving and the other is a static background
    panel_pos = get(handles.scrolling_panel, 'Position'); 
    fig_pos = get(handles.static_panel, 'Position');
    
    % find the highest axes from currently available ones
    h_ax = highest_axes(handles.axesav);
    if ~isempty(h_ax)
        highest_pos = get(h_ax, 'Position'); % its position
    else
        highest_pos = handles.init_ax1_pos;
    end    
    
    % space for new axes = y-size of the highestaxes + initial distance between axes:
    delta_y = highest_pos(4)+handles.init_delta_y;
    
    % initial scrolling panel position
    handles.scrolling_panel_init = get (handles.scrolling_panel, 'Position');
    
    % Change the size and position of panels with axes
    fig_pos(4) = fig_pos(4) + delta_y;
    fig_pos(2) = fig_pos(2) - delta_y;
    panel_pos(4) = panel_pos(4) + delta_y;    
    set (handles.static_panel, 'Position', fig_pos)
    set (handles.scrolling_panel, 'Position', panel_pos)
    
    % again find the highest axes from currently available ones
    h_ax = highest_axes(handles.axesav);
    if ~isempty(h_ax)
        highest_pos = get(h_ax, 'Position'); % its position
    else
        highest_pos = handles.init_ax1_pos;
    end    
    
    % add a new axes
    numofax = size(handles.axesav, 2); %number of axes available
    tag = ['axes', num2str(numofax+1)];
    new_ax_pos = highest_pos; 
    new_ax_pos(2) = new_ax_pos(2) + delta_y;
    handles.(tag) = axes(handles.scrolling_panel, 'Units', 'characters', 'ActivePositionProperty', 'position', 'Position', new_ax_pos);
    set (handles.(tag), 'XTick', [], 'Ytick', [])
    
    % add a new axes to axesavailable
    handles.axesav{numofax + 1} = handles.(tag); 
    
    % Move the slider up
    set(findobj('Tag', 'panel_slider'), 'Value', 1)
    panel_slider_Callback(findobj('Tag', 'panel_slider'), eventdata, handles)
    
    SetAllButtonDownFcn(hObject, handles); % So that axes can be moved
    
    guidata(hObject, handles);
    
end

% --- Executes on button press in DeleteAxis.
function DeleteAxis_Callback(hObject, eventdata, handles)
    
    if (~isempty(handles.currentaxes))
        j = 0;
        num = numel(handles.axesav);
        temp = cell(1, num-1); % this cell will collect all axes except for the deleted one

        % {axes1, axes2, axes3} -> {axes1, axes3} if current.axis == axes2
        for i=1:num
            if ~isequal(handles.currentaxes, handles.axesav{i})
                j = j + 1;
                temp{j} = handles.axesav{i};
            end    
        end    
        handles.axesav = temp;

        delete(handles.currentaxes) % delete the actual axis
        
        handles.currentaxes = []; 
        handles.axeschosen = 0;
        
        guidata(hObject, handles);
    end
    
end


function uitoggletool2_ClickedCallback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function New_Project_Callback(hObject, eventdata, handles)
    Interface
end

% --------------------------------------------------------------------
function Open_Project_Callback(hObject, eventdata, handles)
    
    Save_Project_Callback(hObject, eventdata, handles)
    delete(handles.figure1)
    uiopen(['./Projects','figure'])
    
end

% --------------------------------------------------------------------
function Save_Project_Callback(hObject, eventdata, handles)

    [FileName, FilePath] = uiputfile({'*.fig'}, 'Save as', './Projects/NewProject');
    
    if ~isequal(FileName, 0)
        savefig([FilePath, FileName])   
    end
    
end

% --------------------------------------------------------------------
function Menu_Project_Callback(hObject, eventdata, handles)
end


% --------------------------------------------------------------------
function Colorbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Colorbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function Menu_Axes_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Align_Vertically_Callback(hObject, eventdata, handles)
    
    h_ax = handles.currentaxes;
    
    if isempty(h_ax)
        h_ax = highest_axes(handles.axesav); % if current_axis is empty, then h_ax = highest_axis
    end    
    
    if ~isempty(h_ax)        
        h_ax_pos = get(h_ax, 'Position'); 
        for i=1:numel(handles.axesav)
            ax = handles.axesav{i}; % axis that is being aligned
            pos = get(ax, 'Position'); 
            set(ax, 'Position', [h_ax_pos(1) pos(2) pos(3) pos(4)])
        end 
    end
    
end


% --------------------------------------------------------------------
function Set_Equal_Width_Callback(hObject, eventdata, handles)
   
    h_ax = handles.currentaxes;
    
    if isempty(h_ax)
        h_ax = highest_axes(handles.axesav); % if current_axis is empty, then h_ax = highest_axis
    end    
    
    if ~isempty(h_ax)
        h_ax_pos = get(h_ax, 'Position');
        for i=1:numel(handles.axesav)
            ax = handles.axesav{i}; % axis that is being aligned
            pos = get(ax, 'Position'); 
            set(handles.axesav{i}, 'Position', [pos(1) pos(2) h_ax_pos(3) pos(4)])
        end 
    end 
    
end


% --------------------------------------------------------------------
function Set_Width_And_Align_Callback(hObject, eventdata, handles)

    h_ax = handles.currentaxes;
    
    if isempty(h_ax)
        h_ax = highest_axes(handles.axesav); % if current_axis is empty, then h_ax = highest_axis
    end    
    
    if ~isempty(h_ax)
        h_ax_pos = get(h_ax, 'Position');
        for i=1:numel(handles.axesav)
            ax = handles.axesav{i}; % axis that is being aligned
            pos = get(ax, 'Position'); 
            set(handles.axesav{i}, 'Position', [h_ax_pos(1) pos(2) h_ax_pos(3) pos(4)])
        end 
    end
    
end


% --------------------------------------------------------------------
function Axes_Style_Callback(hObject, eventdata, handles)
    handles.AxesDesign = AxesDesign(hObject, handles);
    handles.AxDesignOpen = 1;
    guidata(hObject, handles);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    delete(hObject);
    if handles.AxDesignOpen == 1
        delete(handles.AxesDesign);
    end
end