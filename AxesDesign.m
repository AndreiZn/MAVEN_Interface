function varargout = AxesDesign(varargin)
    % AXESDESIGN MATLAB code for AxesDesign.fig
    %      AXESDESIGN, by itself, creates a new AXESDESIGN or raises the existing
    %      singleton*.
    %
    %      H = AXESDESIGN returns the handle to a new AXESDESIGN or the handle to
    %      the existing singleton*.
    %
    %      AXESDESIGN('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in AXESDESIGN.M with the given input arguments.
    %
    %      AXESDESIGN('Property','Value',...) creates a new AXESDESIGN or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before AxesDesign_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to AxesDesign_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help AxesDesign

    % Last Modified by GUIDE v2.5 27-Jul-2017 15:49:42

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @AxesDesign_OpeningFcn, ...
                       'gui_OutputFcn',  @AxesDesign_OutputFcn, ...
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


% --- Executes just before AxesDesign is made visible.
function AxesDesign_OpeningFcn(hObject, eventdata, handles, varargin)

    handles.Interface_handles = varargin{2};

    % Choose default command line output for AxesDesign
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    xlabel_CreateFcn(findobj('Tag', 'xlabel'), eventdata, handles);
    Title_CreateFcn(findobj('Tag', 'Title'), eventdata, handles);
    ylabel_CreateFcn(findobj('Tag', 'ylabel'), eventdata, handles);    
    y_min_CreateFcn(findobj('Tag', 'y_min'), eventdata, handles);
    y_max_CreateFcn(findobj('Tag', 'y_max'), eventdata, handles);
    logscale_checkbox_CreateFcn(findobj('Tag', 'logcale_checkbox'), eventdata, handles)
    Legend_CreateFcn(findobj('Tag', 'Legend'), eventdata, handles)
    colormap_min_CreateFcn(findobj('Tag', 'colormap_min'), eventdata, handles);
    colormap_max_CreateFcn(findobj('Tag', 'colormap_max'), eventdata, handles);
    % UIWAIT makes AxesDesign wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AxesDesign_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);

    % Get default command line output from handles structure
    varargout{1} = handles.output;



function xlabel_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function xlabel_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    if ~isempty (handles)
        xlab_text = get(handles.Interface_handles.currentaxes, 'xlabel');
        xlab_str = get(xlab_text, 'String');
        set(hObject, 'String', xlab_str)
    end

function Title_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Title_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    if ~isempty (handles)
        ttl_text = get(handles.Interface_handles.currentaxes, 'title');
        ttl_str = get(ttl_text, 'String');
        set(hObject, 'String', ttl_str)
    end    
    
function ylabel_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ylabel_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    if ~isempty (handles)
        ylab_text = get(handles.Interface_handles.currentaxes, 'ylabel');
        ylab_str = get(ylab_text, 'String');
        set(hObject, 'String', ylab_str)
    end

function y_min_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function y_min_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    if ~isempty (handles)
        ylim = get(handles.Interface_handles.currentaxes, 'ylim');
        set(hObject, 'String', ylim(1))
    end

function y_max_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function y_max_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end 
    if ~isempty (handles)
        ylim = get(handles.Interface_handles.currentaxes, 'ylim');
        set(hObject, 'String', ylim(2))
    end
    
% --- Executes during object creation, after setting all properties.
function logscale_checkbox_CreateFcn(hObject, eventdata, handles)
	
    if ~isempty(handles)
        scale = get(handles.Interface_handles.currentaxes, 'YScale');
        assignin('base', 'scale', scale)
        if strcmp(scale, 'linear')
            set (findobj('Tag', 'logcale_checkbox'), 'Value', 0)
        elseif strcmp(scale, 'log')
            set (findobj('Tag', 'logcale_checkbox'), 'Value', 1)
        end    
    end
    
% --- Executes on button press in logscale_checkbox.
function logscale_checkbox_Callback(hObject, eventdata, handles)

    t = get(hObject,'Value');
    if t == 1
        set (handles.Interface_handles.currentaxes, 'YScale', 'log')
    else
        set (handles.Interface_handles.currentaxes, 'YScale', 'linear')
    end   
    
% --- Executes on button press in legend_checkbox.
function legend_checkbox_Callback(hObject, eventdata, handles)
    
    
    if get(findobj('Tag', 'legend_checkbox'), 'Value') == 1
        
        legend(handles.Interface_handles.currentaxes, 'show')
        legend_txt = get(legend(handles.Interface_handles.currentaxes), 'String');
        
        if ~isempty(legend_txt)
            str = legend_txt{1};
            for i=2:numel(legend_txt)
                str = [str, ', ', legend_txt{i}];
            end    
            set (findobj('Tag', 'Legend'), 'String', str)
        else
            set (findobj('Tag', 'Legend'), 'String', '')
        end
        
    else
        legend(handles.Interface_handles.currentaxes, 'off');
        set (findobj('Tag', 'Legend'), 'String', '')
    end 
    set(handles.Interface_handles.currentaxes, 'YLimMode', 'auto')
         
function Legend_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Legend_CreateFcn(hObject, eventdata, handles)
   
    if ~isempty (handles)
        
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end  

        if ~isempty(legend(handles.Interface_handles.currentaxes))
            set(findobj('Tag', 'legend_checkbox'), 'Value', 1)
            legend_checkbox_Callback(findobj('Tag', 'legend_checkbox'), eventdata, handles)
        else
            set(findobj('Tag', 'legend_checkbox'), 'Value', 0)
            legend_checkbox_Callback(findobj('Tag', 'legend_checkbox'), eventdata, handles)
        end    
    
    end
        
    
% --- Executes on button press in SetButton.
function SetButton_Callback(hObject, eventdata, handles)
    
    cur_ax = handles.Interface_handles.currentaxes; % current axis in Interface
    % set current axis
    axes(cur_ax) %current axis in Interface
    
    % get all the properties
    xlab = get(handles.xlabel, 'String');
    ttl = get(handles.Title, 'String');
    ylab = get(handles.ylabel, 'String');
    ylim1 = str2double(get(handles.y_min, 'String'));
    ylim2 = str2double(get(handles.y_max, 'String'));
    if get(findobj('Tag', 'legend_checkbox'), 'Value') == 1
        leg_str = get(findobj('Tag', 'Legend'), 'String');
        leg_cell = strsplit(leg_str,',');
        legend(handles.Interface_handles.currentaxes, 'String', leg_cell)
    end
    
    xlabel(xlab)
    title(ttl)

    ylabel(ylab)
    ylim([ylim1 ylim2])
    
    
% --- Executes on button press in PrpInspector.
function PrpInspector_Callback(hObject, eventdata, handles)
    inspect(handles.Interface_handles.currentaxes)

function colormap_min_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function colormap_min_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'String', 'not applicable')
    if ~isempty (handles)       
        
        chld = get(handles.Interface_handles.currentaxes, 'Children');
        if isa(chld, 'matlab.graphics.primitive.Surface')            
            CLim = get(handles.Interface_handles.currentaxes, 'CLim');
            set(hObject, 'String', CLim(1))
        end
    end

function colormap_max_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function colormap_max_CreateFcn(hObject, eventdata, handles)
    
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'String', 'not applicable')
    if ~isempty (handles)       
        chld = get(handles.Interface_handles.currentaxes, 'Children');
        if isa(chld, 'matlab.graphics.primitive.Surface')            
            CLim = get(handles.Interface_handles.currentaxes, 'CLim');
            set(hObject, 'String', CLim(2))
        end
    end
          
% --- Executes on button press in Set_Spectrogram_Button.
function Set_Spectrogram_Button_Callback(hObject, eventdata, handles)

    % set current axis
    axes(handles.Interface_handles.currentaxes) %current axis in Interface
    
    colormap_max = str2double(get(handles.colormap_max, 'String'));
    colormap_min = str2double(get(handles.colormap_min, 'String'));
    caxis([colormap_min colormap_max])
    
    % colorbar design
    handles.bar_handle = colorbar;
    labels = get(handles.bar_handle, 'yticklabel');
    barlabels = cell(size(labels, 1), 1);
    for i=1:size(labels, 1)
        barlabels{i} = ['10^{', labels{i}, '}'];
    end
    set(handles.bar_handle, 'yticklabel', char(barlabels), 'FontWeight', 'bold', 'fontsize', 7)
    
    guidata(hObject, handles); 
     

% --- Executes when user attempts to close figure1 == AxesDesign menu.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
    
    handles.Interface_handles.AxDesignOpen = 0; % it means that AxesDesign menu is closed
    Interface_obj = handles.Interface_handles.figure1; % handle of the main Interface object
    guidata(Interface_obj, handles.Interface_handles); % update Interface handles
    guidata(hObject, handles);
    delete(hObject);
