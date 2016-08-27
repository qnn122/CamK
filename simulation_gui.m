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

% Last Modified by GUIDE v2.5 26-Aug-2016 10:46:17

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

handles.resultstr = '';

% Adding dependencies' path
disp('Adding path ...')
addpath(genpath('./rvctools'));
addpath('./Fingertip_Detection');
addpath('./Key_Detection');
addpath('./KeyBoard_Detection');
addpath('./Keystroke_Detection');
disp('Done');

% Load radius
% setKeyboard(handles);
global r % TODO: place this one on a more appropriate place
r = 5;

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

% ************************ BROWSE BUTTON *********************************
% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get new video file
[filename, path] = uigetfile({'*.*','All Files' });
set(handles.text_filename, 'String', filename);
if filename == 0
    msgbox('No file chosen', 'Warning: no file selected')
    return
end

% Loading video
set(handles.text_status, 'String', 'Loading video... Please wait')
handles.v = VideoReader([path,filename]);
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

% Write the movie structure to workspace
assignin('base', 'mov', handles.mov);

% Set up slider
set(handles.slider_framenum, 'Min', 1,...
    'Max', handles.nFrames', ...
    'Value', 1);

imshow(handles.mov(get(handles.slider_framenum, 'Value')).cdata, 'Parent', handles.axes_rawimage);

% Load CSV file
CSV = csvread([path,filename(1:end-9),'acc.csv']);
timestamp = CSV(:,1); % timestamp of sensor signal
global Time_Sensor
global sensor_x
Time_Sensor = timestamp - timestamp(1);
sensor_x = CSV(:,2); % use x_axis value
disp('Load CSV successful');


% Set up keyboard layout
% global K
%I = handles.mov(17).cdata;   % frame no.17 seem to be good, mannual selection
% offset = str2double(get(handles.edit_offset, 'String'));
%[Ori_GrK, curPoint, Ori_ClK] = fingertipdetection(I, offset); % TODO: Need shorter way, this is temporary
%K = loadkeyboard(Ori_ClK);

% Determine keyboard mask - fillmask
% global kbmask
% I = handles.mov(100).cdata;
% kbmask = extract_kbmask(I, offset);

setKeyboard(handles);

% Update handles
guidata(hObject, handles);


% ************************ SLIDER *********************************
% --- Executes during object creation, after setting all properties.
function slider_framenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider_framenum_Callback(hObject, eventdata, handles)
% hObject    handle to slider_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Get current frame
curFrame = ceil(get(hObject, 'Value'));
handles = singleframe_processing(handles, curFrame);

guidata(hObject, handles)


% ******************** SET CURRENT FRAME *********************************
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

function edit_framenum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_framenum as text
%        str2double(get(hObject,'String')) returns contents of edit_framenum as a double

set(handles.slider_framenum, 'Value', str2double(get(hObject, 'String')));


% ************************** SET OFFSET *********************************
% --- Executes during object creation, after setting all properties.
function edit_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offset as text
%        str2double(get(hObject,'String')) returns contents of edit_offset as a double

offset = str2double(get(hObject, 'String'));
% global I
% [Ori_GrK, curPoint] = fingertipdetection(I, offset);


% ******************** START/PLAY/PAUSE BUTTON ***************************
% --- Executes during object creation, after setting all properties.
function pb_play_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes on button press in pb_play.

function pb_play_Callback(hObject, eventdata, handles)
% hObject    handle to pb_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nFrame = handles.nFrames;

% Perfome frame-to-frame simulation
if(strcmp(get(hObject,'String'),'Start'))
    set(hObject, 'String', 'Pause')
    for curFrame = 1:nFrame
        fprintf('Frame no. %d\n', curFrame);
        try
            tic;
            handles = singleframe_processing(handles, curFrame);    % Process a frame
            if isfield(handles, 'h_idx')                                 % Update signal's index
                idx = floor((curFrame/30)*100) + 65;
                set(handles.h_idx, 'XData', [idx idx]);
            end
            tElapsed = toc
            drawnow;
        catch e
            if strcmp(e.identifier, 'MATLAB:class:InvalidHandle')
                return
            end
            e
            disp('THE PROGRAM TERMINATED')
        end
    end
elseif (strcmp(get(hObject,'String'),'Pause'))
    set(hObject, 'String', 'Play')
    uiwait();
elseif (strcmp(get(hObject, 'String'), 'Play'))
    set(hObject, 'String', 'Pause');
    uiresume();
end


guidata(hObject, handles);



% **************** CUSTOMIZED FUNCTIONS *********************************
% ==================== MAIN FUNCTION - PROCESSING ========================
function handles = singleframe_processing(handles, curFrame)
persistent preCanddt curCanddt

global K
global r
global Time_Sensor
global sensor_x

if isempty(preCanddt) preCanddt = zeros(1,2); end
if isempty(curCanddt) curCanddt = 100*ones(1,2); end    % 100: arbitrary large enough number

% Update GUI
set(handles.edit_framenum, 'String', num2str(curFrame));    % edit framenum
set(handles.slider_framenum, 'Value', curFrame);                     % slider

% Show image
I = handles.mov(curFrame).cdata;
imshow(I, 'Parent', handles.axes_rawimage);


% ========================= Process image ===============================
set(handles.text_status, 'String', 'Processing ...');
% offset = str2double(get(handles.edit_offset, 'String'));

% ====== Fingertip detection ====
global kbmask
[curPoint, Ori_ClK] = fingertipdetection_onkb(I, kbmask, handles.axes_outimage); % Significant cost = 0.35-0.38s
if ~isscalar(curPoint)  % means fingertip detected
    set(handles.text_fingertip, 'ForegroundColor', [1 0 0]);

    % ===== Keystroke Detection ====
    % 1. Find candidate finger
    preCanddt = curCanddt;
    curCanddt = findCanddt(curPoint);
    if isKeyStroke(Time_Sensor, sensor_x, curFrame)
        disp(' ====== KeyStroke detected ====')
        set(handles.text_keystroke, 'ForegroundColor', [0.1 0.5 0.5])
        % Which key has been pressed
        curPoint
        try
            key = keydetection(Ori_ClK, curCanddt, K, r);
            if key == -1
                set(handles.text_key, 'String', '-1', 'ForegroundColor', [0.2 0.2 0.2])
            else
                set(handles.text_key, 'String', key, 'ForegroundColor', [1 0 0])
                % Display resulted string
                if strcmp(key, 'Spa')
                    handles.resultstr = horzat(handles.resultstr, ' ');
                else
                    handles.resultstr = horzcat(handles.resultstr, upper(key));
                end
                set(handles.text_result, 'String', handles.resultstr);
                
                pause(0.5)
            end
        catch e
            e
        end
    else
        set(handles.text_keystroke, 'ForegroundColor', [0.2 0.2 0.2]);
    end
else
    set(handles.text_fingertip, 'ForegroundColor', [0.2 0.2 0.2]);
end

set(handles.text_key, 'String', 'None', 'ForegroundColor', [0.2 0.2 0.2])

set(handles.text_status, 'String', 'Done');

drawnow;

% -----------------------------------------------------
function canddt = findCanddt(curPoint)
% In:
%   curPoint: cell containing all coordinates of fingertip
% Out:
%   canddit:  vector containing coordinate of candidate finger (lowest y)
y = curPoint(:,1);
if size(curPoint, 1) == 1
    canddt = curPoint;
else
    canddt = curPoint(find(y== max(y)), :);
end

% -----------------------------------------------------
function bol = isKeyStroke(Time_Sensor, sensor_x, curFrame)
% In case there are more than 1 finger detected, skip
% Find Timestamp
Win_Size = 5;
Fps = 30;
if curFrame>=2
    Time_Frame = (curFrame - 1)/Fps*1000; % time in sensor (by milisecond)
    temp = Time_Sensor - Time_Frame;
    pos = min(find(temp>0)); % find timestamp of sensor at that Frame
    data_sensor = sensor_x(pos - Win_Size : pos); % choose data sensor in that range
    peak = Pan_Tompkins(data_sensor,Win_Size); % detect peak
    if isempty(find(peak)) % not keystroke
        bol = 0;
    else %keystroke
        bol = 1;
    end
end

% -------------------------------------------------------
% TODO: Generalize this function, determine keyboard from the calibration
% process
function K = loadkeyboard(handles)
% ===============  Load information of Original keyboard =======================
K_Layout = load ('Key_Struct_Layout.mat');
K_Layout = K_Layout.K;
LayoutPoints = K_Layout{65};
K_Layout = K_Layout(1:64);

% ===============  Decide area of Frame keyboard =======================
Frame_temp = load('KeyBoard.mat');
Frame = Frame_temp.KeyBoard_Frame;

% Some shit
offset = 280;
%offset = str2double(get(handles.edit_offset, 'String'));
% M_td1 = zeros(size(Frame,1)-offset,size(Frame,2));
% M_td2 = ones(offset,size(Frame,2));
% M_td = [M_td1; M_td2]; % Create mask

% Find Point and Mask
global kbmask
[FramePoints, mask, kbmask] = MakePoint(Frame, offset);

% ========= Determine new keyboard structure ============================
K = Create_Key_Struct(LayoutPoints, FramePoints, 12, K_Layout);
% offset = str2double(get(handles.edit_offset, 'String'));
for i = 1 : 64
    for j = 1 : 5
        K{i}.td(j,1)=K{i}.td(j,1)-size(Frame,1)+offset;
    end
end

% Display homography transform
[H, W, C] = size(Frame);
frac = Frame((H-offset+1):end, :, :);
a = double(rgb2gray(frac)).*double((kbmask));
figure; imshow(a, [])
hold on
for i = 1 : 64
    key = K{i}.td(1:4,:);
    fill(key(:,2), key(:,1), [1 0 0], 'facealpha', .5);
end
hold off

disp('Done');
% -------------------------------------------------------
function setKeyboard(handles)
global S_avg
global K

K = loadkeyboard(handles);

% Find S_avg as Average size of key area
if isempty(S_avg)
    S_avg = 0;
    for i = 1 : length(K)
        S_avg = S_avg + K{i}.area;
    end
    S_avg = S_avg / (64 + 5 - 1);
end


% --- Executes on button press in btn_browsesig.
function btn_browsesig_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browsesig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get new signal file
[filename, path] = uigetfile({'*.*','All Files' });
set(handles.text_filesig, 'String', filename);
if filename == 0
    msgbox('No file chosen', 'Warning: no file selected')
    return
end

set(handles.text_status, 'String', 'Loading signal... Please wait')
sig = csvread([path,filename]);

timestamp = sig(:,1); % timestamp of sensor signal
sensor_x = sig(:,2); % use x_axis value

% Detect peak
peak = Pan_Tompkins(sensor_x,5); % detect peak

% Normalize signal
sensor_offremv = sensor_x - mean(sensor_x);
sensor_norm = sensor_offremv./max(sensor_offremv);

% Display
plot(sensor_norm, 'r-', 'Parent', handles.axes_sig);
hold on;
stem(peak, 'g-', 'Parent', handles.axes_sig);

% Initializing sliding index
idx = 1;
h_idx = line([idx idx], [min(sensor_norm) 1.2], 'Color', [0.5 0.5 1], 'linewidth', 1.5, 'Parent', handles.axes_sig);
hold off;
axis tight


% Update GUI
set(handles.text_status, 'String', 'Done')
handles.sig = sig;
handles.idx = idx;
handles.h_idx = h_idx;
guidata(hObject, handles);
