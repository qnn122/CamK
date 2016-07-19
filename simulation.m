% Script file: simulation.m
% Split the video in to frames and review the processing steps
%

addpath ../
disp('Loading video...')
v = VideoReader('2016_05_28_15_05_34_video.mp4');
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

%% Play
% size the figure  based on the video's width and height
% hf = figure;
% set(hf, 'position', [50 50 vidW vidH])

% play back
M_td1 = zeros(570,1280);
M_td2 = ones(150,1280);
M_td = [M_td1;M_td2];
for i = 1:nFrames
    fprintf('Frame %d\n', i);
    I = mov(i).cdata;
    [Point,mask] = MakePoint(I,M_td);
    in = MaskKb(Point);
    [Ori_GrK,Ori_ClK] = AreaKb(I,in);

    %% Next step
    [GrK,ClK] = AreaKb(I,in);
    imshow(GrK);

    % K = kovac(ClK);
    % Y = ybr(ClK);
    Y1 = ycbcr(ClK);
    % Y2 = hsv(ClK);
    skin = medfilt2(Y1);
    % subplot(1,2,1);imshow(Y);
    % subplot(1,2,2);imshow(mask);

    % subplot(2,3,1);imshow(I);
    % subplot(2,3,2);imshow(K);
    % subplot(2,3,3);imshow(Y);
    % subplot(2,3,4);imshow(Y1);
    % subplot(2,3,5);imshow(Y2);

%     [curPoint,cP] = Detect_Fintip(skin,7,2.5);
%     imshow(Ori_GrK);
%     hold on
% 
%     % Plot fingertip
%     for i = 1 : length(curPoint)
%         plot(curPoint{i}(:,2),curPoint{i}(:,1),'*');
%     end
%     hold off
%     
    pause(0.1)
end