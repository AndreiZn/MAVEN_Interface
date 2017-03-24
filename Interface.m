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

    % Last Modified by GUIDE v2.5 22-Mar-2017 10:19:01

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
    
    %Files and times:    
    handles.filename = '';
    handles.starttime = get(findobj('Tag', 'edit1'), 'String');
    handles.stoptime = get(findobj('Tag', 'edit2'), 'String');
    
    %Current Axes:
    handles.currentaxes = handles.axes1;
    
    %Sliders:
    handles.slider_leftend = datenum(handles.starttime); handles.slider_rightend = datenum(handles.stoptime);
    handles.leftsliderflag = 0; handles.rightsliderflag = 0;
    
    %Handles needed to drag and drop objects:
    handles.dragging = [];
    handles.orPos = [];
    
    %Call and fill out the edit1 and edit2
    %edit1_Callback(findobj('Tag', 'edit1'), eventdata, handles);
    %edit2_Callback(findobj('Tag', 'edit2'), eventdata, handles);
    
    %Mass handle:
    handles.masstype = 1; 
    %Masstypes: 1 - 1a.u. 
    %           2 - 4a.u.
    %           3 - 12a.u.
    %           4 - 16a.u.
    %           5 - 32a.u.
    %           6 - 38a.u.
    %           7 - 44a.u.
    
    %To save all information about arguments
    handles.Args = struct();
    
    %Number of plotted graphs
    handles.counterofgraphs = 0;
    
    %To save all information about plotted graphs and spectrograms
    handles.currentgraphs = struct('Script', {''}, 'Axes', handles.currentaxes, 'Args', handles.Args);
    
    %This is for MassSpectrum
    handles.timecorrectness = 0; % = 1 if massspectime has the following format: 'HH:MM:SS' 
    handles.massspcparam = 0; %linear scale for the mass spectrum 
    
    axes(handles.axes1);
    
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
    if (~isempty(handles.filefolderpath))
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

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to axes1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: place code in OpeningFcn to populate axes1
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes1);
% c0forInterface(handles.starttime, handles.stoptime, handles.filename);
% handles.slider_leftend = handles.starttime; handles.slider_rightend = handles.stoptime;
% handles.legendmoments = momentsforInterface(handles.filenameformoments, handles.starttimemom, handles.stoptimemom, handles.masstype, handles.axes2, handles.axes3, handles.axes4);
% magfforInterface (handles.filename, handles.starttime, handles.stoptime, handles.axes6);
% guidata(hObject, handles);
% set(findobj('Tag', 'slider2'), 'Value', 0)
% set(findobj('Tag', 'slider3'), 'Value', 1)
% SetAllButtonDownFcn(hObject, handles);
end

function edit1_Callback(hObject, eventdata, handles)
    if (handles.leftsliderflag==0)        
        userstarttime = get(hObject, 'String');
        format = '\d\d:\d\d:\d\d';
        if (~isempty(regexp(userstarttime,format, 'once')))  %format: HH:MM:SS       
            handles.starttime = userstarttime; 
            Sysmessage(['Start time = ', userstarttime]) 
        else
            Sysmessage('Error! Time format is HH:MM:SS')
        end        
    else
        handles.leftsliderflag = 0; 
        set (hObject, 'String', handles.starttime)
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function edit2_Callback(hObject, eventdata, handles)
    if (handles.rightsliderflag==0)        
        userstoptime = get(hObject, 'String');
        format = '\d\d:\d\d:\d\d';
        if (~isempty(regexp(userstoptime, format, 'once')))  %format: HH:MM:SS       
            handles.stoptime = userstoptime; 
            Sysmessage(['Stop time = ', userstoptime]) 
        else
            Sysmessage('Error! Time format is HH:MM:SS')            
        end
    else
        handles.rightsliderflag = 0; 
        set (hObject, 'String', handles.stoptime)
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end   
end

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles) %starttime slider
    timenum = (handles.slider_rightend - handles.slider_leftend)*get(hObject, 'Value') + handles.slider_leftend;
    handles.starttime = datestr(timenum, 'HH:MM:SS');
    handles.leftsliderflag = 1;
    guidata(hObject, handles);
    edit1_Callback(findobj('Tag', 'edit1'), eventdata, handles);

    %automatic plot (without pressing the button "Plot"
    pushbutton6_Callback (findobj('Tag', 'pushbutton6'), eventdata, handles)
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

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
    timenum = (handles.slider_rightend - handles.slider_leftend)*get(hObject, 'Value') + handles.slider_leftend;
    handles.stoptime = datestr(timenum, 'HH:MM:SS');
    handles.rightsliderflag = 1;
    guidata(hObject, handles);
    edit2_Callback(findobj('Tag', 'edit2'), eventdata, handles);

    %automatic plot (without pressing the button "Plot"
    pushbutton6_Callback (findobj('Tag', 'pushbutton6'), eventdata, handles)
    handles.slider_leftend = datenum(handles.starttime); handles.slider_rightend = datenum(handles.stoptime);
    guidata(hObject, handles);
    SetAllButtonDownFcn(hObject, handles);
    set(findobj('Tag', 'slider2'), 'Value', 0)
    set(findobj('Tag', 'slider3'), 'Value', 1)
end

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if ~isempty(handles.dragging)
            newPos = get(gcf,'CurrentPoint');
            posDiff = newPos - handles.orPos;
            set(handles.dragging,'Position',get(handles.dragging,'Position') + [posDiff(1:2) 0 0]);
            handles.dragging = [];
    end
    guidata(hObject, handles);
end

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if ~isempty(handles.dragging)
        newPos = get(gcf,'CurrentPoint');
        posDiff = newPos - handles.orPos;
        handles.orPos = newPos;
        set(handles.dragging,'Position',get(handles.dragging,'Position') + [posDiff(1:2) 0 0]);
    end
    guidata(hObject, handles);
end

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata)
    handles = guidata(hObject);
    handles.dragging = handles.axes1;
    handles.orPos = get(gcf,'CurrentPoint');
    guidata(hObject, handles);
end

function axes2_ButtonDownFcn(hObject, eventdata)
    handles = guidata(hObject);
    handles.dragging = handles.axes2;
    handles.orPos = get(gcf,'CurrentPoint');
    guidata(hObject, handles);
end

function axes3_ButtonDownFcn(hObject, eventdata)
    handles = guidata(hObject);
    handles.dragging = handles.axes3;
    handles.orPos = get(gcf,'CurrentPoint');
    guidata(hObject, handles);
end

function axes4_ButtonDownFcn(hObject, eventdata)
    handles = guidata(hObject);
    handles.dragging = handles.axes4;
    handles.orPos = get(gcf,'CurrentPoint');
    guidata(hObject, handles);
end

function axes5_ButtonDownFcn(hObject, eventdata)
    handles = guidata(hObject);
    handles.dragging = handles.axes5;
    handles.orPos = get(gcf,'CurrentPoint');
    guidata(hObject, handles);
end

function SetAllButtonDownFcn (hObject, handles)
    set (handles.axes1, 'ButtonDownFcn',@axes1_ButtonDownFcn);
    set (handles.axes2, 'ButtonDownFcn',@axes2_ButtonDownFcn);
    set (handles.axes3, 'ButtonDownFcn',@axes3_ButtonDownFcn);
    set (handles.axes4, 'ButtonDownFcn',@axes4_ButtonDownFcn);
    set (handles.axes5, 'ButtonDownFcn',@axes5_ButtonDownFcn);
end

% --- Executes on button press in radiobutton5.
%Axes1 radiobutton
function radiobutton5_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value')==1)
        handles.currentaxes = handles.axes1;
        guidata(hObject, handles);
    end
end

% --- Executes on button press in radiobutton6.
%Axes2 radiobutton
function radiobutton6_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value')==1)
        handles.currentaxes = handles.axes2;
        guidata(hObject, handles);
    end
end

% --- Executes on button press in radiobutton7.
%Axes3 radiobutton
function radiobutton7_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value')==1)
        handles.currentaxes = handles.axes3;
        guidata(hObject, handles);
    end
end

% --- Executes on button press in radiobutton8.
%Axes4 radiobutton
function radiobutton8_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value')==1)
        handles.currentaxes = handles.axes4;
        guidata(hObject, handles);
    end
end

% --- Executes on button press in radiobutton9.
%Axes5 radiobutton
function radiobutton9_Callback(hObject, eventdata, handles)
    if (get(hObject,'Value')==1)
        handles.currentaxes = handles.axes5;
        guidata(hObject, handles);
    end
end

%this function gets file names, a year, a month and a day and returns those files from fls that contain 'ymd' 
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
    handles.Args = feval ([contents{get(hObject,'Value')}, '_Args']); %Args has all information about arguments of the function "contents{get(hObject,'Value')}"
    cd ('../../') %get back to the main folder
    
    fieldnms = fieldnames (handles.Args);
    for i = 1:size(fieldnms, 1)
        
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
                  'BackgroundColor','white',...
                  'Position',[.856 (.812-.102*i) .10 .09]);

        %list of arguments      
        handles.lst_with_args(i) = uicontrol('Style','listbox','FontSize', 9,... 
                  'Position',[1180 (600-75*i) 136 50],...
                  'String',str); 

        %it's necessary to save all objects created to delete them later. 
        %This information is saved in handles.argobj      
        handles.temphndl = [handles.argpanel(i), handles.lst_with_args(i)];
        handles.argobj = [handles.argobj, handles.temphndl];       
        
        if (isequal(field_i, 'file'))
            
            filetype = args_i{1}(1); % because that's how the file-wise part of Args looks like: field1 = 'filetype'; value1 = {{'c6', ''}}; Args = struct(field1, {value1});
            %so we get, for example,  'c6' out of it.
            filetype = filetype{1}; %to make it a sring
            
            %getting the date            
            date = get(findobj('Tag', 'edit5'), 'String'); %date has a format of 20-Mar-2017
            datev = datevec(date); %datev = [2017 3 20 ...]
            assignin('base', 'date', date)
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
            
            files = dir(filepath); %all files and folders from the "address = filepath 
            files = {files(3:end).name}'; %delete first three folders, because they are always '.' and '..'

            %checking whether the folder has any files
            if (isempty(files))
                message = ['There are no files of ', filetype, ' type for ', date, ' at ', handles.filefolderpath, ', which are necessary for ', handles.chosenfunc];
                Sysmessage(message); %send message to the Sysmessage edit box
            else
                %find all files related to the chosen date
                %files2 will contain all files related to the date = 'date'              
                files2 = files_relatedto_date(files, handles.year, handles.month, handles.day);
                files2 = files2{1}; %if files2 still has several files we choose the first one                
                
                %checking whether the folder has necessary files
                if (isempty(files2))
                    message = ['There are no files of ', filetype, ' type for ', date, ' at ', handles.filefolderpath, ', which are necessary for ', handles.chosenfunc];
                    Sysmessage(message); %send message to the Sysmessage edit box
                else
                    %finally, a path to the file:
                    fpath = [filepath, '\', files2];
                    handles.Args.(field_i){1}{2} = fpath;                    
                    handles.filename = fpath;
                    Sysmessage(['"', files2, '"', ' was successfully uploaded and the system is ready to plot ', handles.chosenfunc]);
                end
            end
        end
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
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    lst_with_fncts = findobj('Tag', 'listbox2'); %lst_with_fncts - listbox with function names
    contents = cellstr(get(lst_with_fncts,'String'));%all names of functions from the listbox with functions
    chosen_fnct = contents{get(lst_with_fncts,'Value')}; %a user chose a function "chosen_fnct" 
    
    %getting all of values of arguments chosen by a user
    fieldnms = fieldnames(handles.Args);
    
    specific_args = cell(1, size(fieldnms, 1));%specific_args saves arguments' values to pass to a function
    for i = 1:size(fieldnms, 1)
        field_i = fieldnms(i); %field_i is a cell 1x1
        field_i = field_i{1}; %field_i becomes a string
        args_i = handles.Args.(field_i); %get all args from the i-field
        j = get(handles.lst_with_args(i),'Value');
        temp = args_i{j}(2); %temp is a cell 1x1
        specific_args{1, i} = temp{1}; %temp{1} is a string   
    end
    
    %runc the chosen_fnct with arguments from the "Scripts" Folder
    cd('./Scripts')
    feval(chosen_fnct, handles.currentaxes, handles.starttime, handles.stoptime, handles.filename, specific_args)
    cd('../') %get back to the main folder
    handles.counterofgraphs = handles.counterofgraphs + 1;
    handles.currentgraphs = [handles.currentgraphs, struct('Script', {chosen_fnct}, 'Axes', handles.currentaxes, 'Args', handles.Args)];
    assignin('base', 'counterofgraphs', handles.counterofgraphs)
    assignin('base', 'currentgraphs', handles.currentgraphs)
    
    SetAllButtonDownFcn(hObject, handles);
    guidata(hObject, handles);
end

%Button "Clear out the axes"
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    delete_ind = []; %delete_ind will contain rows to be deleted from handles.currentgraphs
    lim = handles.counterofgraphs+1; 
    for i = 2:lim
        if (handles.currentgraphs(i).Axes == handles.currentaxes) %compare an axes chosen by a user and i-axes in currentgraphs             
            handles.counterofgraphs = handles.counterofgraphs - 1; 
            delete_ind = [delete_ind, i]; %handles.currentgraphs(i) = [];
        end
    end
    
    for j = size(delete_ind, 2):-1:1
        handles.currentgraphs(delete_ind(j)) = []; %clear rows from handles.currentgraphs
    end    
    cla(handles.currentaxes, 'reset') %clear the axes
    
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
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
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
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
    img = feval('screencapture', handles.figure1, [42 -150 1165 882]);
    [FileName, FilePath] = uiputfile({'*.png'}, 'Save as', './ScreenShots/NewShot');  
    cd('./ScreenShots')
    imwrite (img, [FilePath, FileName])
    cd('../')
end

%"Date" editbox 
function edit5_Callback(hObject, eventdata, handles)   
    %checking the format, it should be like '21-Mar-2017'
    format = '[0-3]\d-(Jan|Feb|Mar|...|Dec)-\d\d\d\d';
    str = get(findobj('Tag', 'edit5'), 'String'); %String in edit5(date_editbox)
    if (~isempty(regexp(str,format, 'once')))
        listbox2_Callback(findobj('Tag', 'listbox2'), eventdata, handles);       
    else
        Sysmessage('Error! Date format is dd-Mmm-yyy');
    end
end


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    h = uicalendar('Weekend',  [1 0 0 0 0 0 1], ...
                      'InitDate', datetime('1-Oct-2014'), ...  
                      'DestinationUI', findobj('Tag', 'edit5'));
    uiwait(h);
    edit5_Callback(findobj('Tag', 'edit5'), eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function pushbutton9_CreateFcn(hObject, eventdata, handles)
    hObject.CData = imread('calendar.png');
end

%This function sends line to the Sysmessage edit box
function Sysmessage(line)
    str = get(findobj('Tag', 'Sysmessage'), 'String');
    time = [datestr(datetime('now'), 'HH:MM:SS'), ':> '];
    if (isempty(str))
        str = char([time, line]);
    else        
        str = char({str, [time, line]});
    end
    set(findobj('Tag', 'Sysmessage'), 'String', str)
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

% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
    [FileName, FilePath] = uiputfile({'*.fig'}, 'Save as', './Projects/NewProject');
    savefig([FilePath, FileName])    
end

% --- Executes on button press in openprjbutton.
function openprjbutton_Callback(hObject, eventdata, handles)
    delete(handles.figure1)
    uiopen(['./Projects','figure'])
end

% --- Executes on button press in newwindowbutton.
function newwindowbutton_Callback(hObject, eventdata, handles)
    Interface
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
    %set(handles.slider4, 'SliderStep', [0.1,0.1]); 
    %Get slider's position 
    sl_pos = get(hObject, 'Value'); 
    %Get uipanel1 position  (to be moved)
    panel_pos = get(handles.uipanel8, 'Position'); 
    %Get uipanel2 position
    fig_pos = get(handles.uipanel7, 'Position'); 
    %Set uipanel1 new position 
    set(handles.uipanel8, 'Position', [panel_pos(1), 0, panel_pos(3), panel_pos(4)]);
end

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes during object creation, after setting all properties.
function savebutton_CreateFcn(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function pushbutton6_CreateFcn(hObject, eventdata, handles)
end