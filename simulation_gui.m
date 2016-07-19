function varargout = simulation_gui(varargin)
% SIMULATION_GUI MATLAB code for simulation_gui.fig
%      SIMULATION_GUI, by itself, creates a new SIMULATION_GUI or raises the existing
%      singleton*.
%
%      H = SIMULATION_GUI returns the handle to a new SIMULATION_GUI or the handle to
%      the existing singleton*.
%
%      SIMULATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATION_GUI.M with the given input arguments.
%
%      SIMULATION_GUI('Property','Value',...) creates a new SIMULATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulation_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulation_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulation_gui

% Last Modified by GUIDE v2.5 15-Jul-2016 14:02:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulation_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @simulation_gui_OutputFcn, ...
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


% --- Executes just before simulation_gui is made visible.
function simulation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simulation_gui (see VARARGIN)

% Choose default command line output for simulation_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simulation_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulation_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get new video file
filename = uigetfile({'*.*','All Files' });
set(handles.text_filename, 'String', filename);

% Loading video
set(handles.text_status, 'String', 'Loading video... Please wait')
handles.v = VideoReader('2016_05_28_15_05_34_video.mp4');
handles.nFrames = handles.v.NumberOfFrames;
handles.vidH = handles.v.Height;
handles.vidW = handles.v.Width;

% Preallocate movie structure
set(handles.text_status, 'String', 'Preallocating... It may take a while. Please wait')
handles.mov(1:handles.nFrames) = ...
    struct('cdata', zeros(handles.vidH, handles.vidW, 3, 'uint8'), ...
            'colormap', []);
        
% Read on frame at a time
hwb = waitbar(0, 'Prellocating movie structure. Please wait ...');
for i = 1:handles.nFrames
    handles.mov(i).cdata = read(handles.v, i);
    waitbar(i/handles.nFrames);
end
close(hwb);
set(handles.text_status, 'String', 'Done')

% Set up slider
set(handles.slider_framenum, 'Min', 1,...
                     'Max', handles.nFrames', ...
                     'Value', 1);
                 
imshow(handles.mov(get(handles.slider_framenum, 'Value')).cdata, 'Parent', handles.axes_rawimage);
        
% Update handles
guidata(hObject, handles);

% --- Executes on slider movement.
function slider_framenum_Callback(hObject, eventdata, handles)
% hObject    handle to slider_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Get current frame
curFrame = ceil(get(hObject, 'Value'));

% Set edit text
set(handles.edit_framenum, 'String', num2str(curFrame));

% Show image
I = handles.mov(curFrame).cdata;
imshow(I, 'Parent', handles.axes_rawimage);

% ========================= Process image ===============================
set(handles.text_status, 'String', 'Processing ...');
[Ori_GrK, curPoint] = fingertipdetection(I);

% Show resultant image
imshow(Ori_GrK, 'Parent', handles.axes_outimage);
% hold on
% for i = 1 : length(curPoint)
%     plot(curPoint{i}(:,2),curPoint{i}(:,1),'*');
% end
% hold off
set(handles.text_status, 'String', 'Done');

% --- Executes during object creation, after setting all properties.
function slider_framenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_framenum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_framenum as text
%        str2double(get(hObject,'String')) returns contents of edit_framenum as a double

set(handles.slider_framenum, 'Value', str2double(get(hObject, 'String')));

% --- Executes during object creation, after setting all properties.
function edit_framenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
