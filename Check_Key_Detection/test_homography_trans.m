% Script file: test_homography_trans.m
% Test keydetection function

% Load keyboard image
im_temp = load('Key_Area');
im = im_temp.Ori_ClK;

%% ===============  Decide area of Original keyboard =======================
Frame = imread('Template_Keyboard.png');
portion = 1; % portion of detect (from bottom up)
offset = round(portion*size(Frame,1));
M_td1 = zeros(size(Frame,1)-offset,size(Frame,2)); 
M_td2 = ones(offset,size(Frame,2));
M_td = [M_td1;M_td2]; % Create mask

% Find Point and Mask
[LayoutPoints, mask] = MakePoint(Frame,M_td);
% Fill Polygon
in = MaskKb(LayoutPoints,offset,size(Frame,2),size(Frame,1));
% Find Keyboard base on in-mask
[Ori_GrK,Ori_ClK] = AreaKb(Frame,in);

%% ===============  Decide area of Frame keyboard =======================
Frame_temp = load('KeyBoard.mat');
% Cut frame
firstportion = 0.35; % portion of detect (from bottom up)
H= size(Frame_temp.Ori_ClK,1);
offset = round(firstportion*H);
Frame = Frame_temp.Ori_ClK(H-offset+1:H, :, :);

% Some shit
portion = 1; % portion of detect (from bottom up)
offset = round(portion*size(Frame,1));
M_td1 = zeros(size(Frame,1)-offset,size(Frame,2)); 
M_td2 = ones(offset,size(Frame,2));
M_td = [M_td1;M_td2]; % Create mask

% Find Point and Mask
[FramePoints, mask] = MakePoint(Frame,M_td);
% Fill Polygon
in = MaskKb(FramePoints, offset,size(Frame,2),size(Frame,1));
% Find Keyboard base on in-mask
[mappedOri_GrK, mappedOri_ClK] = AreaKb(Frame,in);

%% Find transformation coeff
F = findcoefhomotrans(FramePoints, LayoutPoints);

% Visualization
hf1 = figure();
horig = axes('Parent', hf1);
imshow(Ori_GrK); % original

% Coordinate of fingertip
% ht = uicontrol('Style', 'text', 'String', '-1', ...
%                 'Units', 'normalized', 'Position', [0.45 0.45 0.1 0.1],...
%                 'FontSize', 20, 'ForegroundColor', 'b');    % Message
r = 5;
hf2 = figure();
hmap = axes('Parent', hf2);
imshow(mappedOri_GrK);
x = 0;

% Interactive ...
while x >= 0    % Click outside of the axes (left side to break)
    gca();
    [y,x] = ginput(1)
    P = homotrans([x,y], F);
%     if key == -1
%         set(ht, 'String', '-1')
%     else
%         set(ht, 'String', key)
%     end
    hold on;
    h1= plot(P(2), P(1), 'r*', 'MarkerSize', 12);
    set(h1, 'Parent', horig);
    h2= plot(y, x, 'r*', 'MarkerSize', 6);
    set(h2, 'Parent', hmap);
end

