% Load video and other parameters
path = 'D:\Opportunities\Internship at University of Natural Science\';
filename = 'test2.mp4';
handles.v = VideoReader([path,filename]);
handles.nFrames = handles.v.NumberOfFrames;
handles.vidH = handles.v.Height;
handles.vidW = handles.v.Width;

% Preallocate movie structure
I = zeros(handles.vidH, handles.vidW, 3, 'uint8');
        
% Read frame
f = 1;    % frame being analyzed
I = read(handles.v, f);

% Fingertip detection
offset = 500;
[Ori_GrK, curPoint] = fingertipdetection(I, offset);