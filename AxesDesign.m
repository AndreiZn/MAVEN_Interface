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

% Last Modified by GUIDE v2.5 24-Apr-2017 22:21:31

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
assignin('base', 'handlesInt', handles.Interface_handles)
% Choose default command line output for AxesDesign
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AxesDesign wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AxesDesign_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function xlabel_Callback(hObject, eventdata, handles)
% hObject    handle to xlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlabel as text
%        str2double(get(hObject,'String')) returns contents of xlabel as a double


% --- Executes during object creation, after setting all properties.
function xlabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ylabel_Callback(hObject, eventdata, handles)
% hObject    handle to ylabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylabel as text
%        str2double(get(hObject,'String')) returns contents of ylabel as a double


% --- Executes during object creation, after setting all properties.
function ylabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetButton.
function SetButton_Callback(hObject, eventdata, handles)
    
    % set current axis
    axes(handles.Interface_handles.currentaxes) %current axis in Interface
    
    % get all the properties
    xlab = get(handles.xlabel, 'String');
    ylab = get(handles.ylabel, 'String');
    ttl = get(handles.Title, 'String');
    
    if ~isequal(xlab, '(default)')
        xlabel(xlab)
    end    
    if ~isequal(ylab, '(default)')
        ylabel(ylab)
    end 
    if ~isequal(ttl, '(default)')
        title(ttl)
    end
    
    %delete(handles.figure1)

% --- Executes on button press in Set_Spectrogram_Button.
function Set_Spectrogram_Button_Callback(hObject, eventdata, handles)

    % set current axis
    axes(handles.Interface_handles.currentaxes) %current axis in Interface
    
    colormap_max = str2double(get(handles.colormap_max, 'String'));
    colormap_min = str2double(get(handles.colormap_min, 'String'));
    caxis([colormap_min colormap_max])
    
    % colorbar design
    bar_handle = colorbar;
    labels = get(bar_handle, 'yticklabel');
    barlabels = cell(size(labels, 1), 1);
    for i=1:size(labels, 1)
        barlabels{i} = ['10^{', labels{i}, '}'];
    end
    set(bar_handle, 'yticklabel', char(barlabels), 'FontWeight', 'bold', 'fontsize', 7)
    ylabel(bar_handle, 'Differential energy flux') 
     


function Title_Callback(hObject, eventdata, handles)
% hObject    handle to Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Title as text
%        str2double(get(hObject,'String')) returns contents of Title as a double


% --- Executes during object creation, after setting all properties.
function Title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function colormap_min_Callback(hObject, eventdata, handles)
% hObject    handle to colormap_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colormap_min as text
%        str2double(get(hObject,'String')) returns contents of colormap_min as a double


% --- Executes during object creation, after setting all properties.
function colormap_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function colormap_max_Callback(hObject, eventdata, handles)
% hObject    handle to colormap_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colormap_max as text
%        str2double(get(hObject,'String')) returns contents of colormap_max as a double


% --- Executes during object creation, after setting all properties.
function colormap_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
