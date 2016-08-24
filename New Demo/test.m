% run for nothing 

clear
clc

name = '2016_05_31_17_13_52_';

%% READ VIDEO CLIP

disp('Loading video...')
v = VideoReader([name 'video.mp4']);
disp('Done')
nFrames = v.NumberOfFrames;
vidH = v.Height;
vidW = v.Width;

%% Preallocate movie structure
disp('Preallocating...')
mov(1:nFrames) = ...
    struct('cdata', zeros(vidH, vidW, 3, 'uint8'), ...
    'colormap', []);

%% Read on frame at a time
for i = 1:nFrames
    mov(i).cdata = read(v, i);
end
disp('Done')

%% Test make point each frame
offset = 280; % set offset (careful)
M_td1 = zeros(vidH-offset,vidW);
M_td2 = ones(offset,vidW);
M_td = [M_td1; M_td2]; % Create mask


% Find Point and Mask each frame for test
for i = 1 : nFrames
    disp(i)
    [Points, mask] = MakePoint(mov(i).cdata, M_td);
    % Fill Polygon
    in = MaskKb(Points,offset,vidW,vidH);
    % Find Keyboard base on in-mask
    [Ori_GrK,Ori_ClK] = AreaKb(mov(i).cdata,in);
    
    subplot(2,1,2);imshow(mask);
    subplot(2,1,1);imshow(Ori_ClK);
    pause(0.1)
end

%% READ CSV FILE
name = '2016_05_31_17_13_52_';
disp('Loading csv file...')
CSV = csvread([name 'acc.csv']);
timestamp = CSV(:,1); % timestamp of sensor signal
sensor_x = CSV(:,2); % use x_axis value

peak = Pan_Tompkins(sensor_x,5); % detect peak

figure;
peaktime = Find_timestamp(peak,timestamp,mov); % map peak timestamp to Frame and view
