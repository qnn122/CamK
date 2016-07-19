%% FINGERTIP DETECTION
%
%
%

%% 1. Calibration: Segment keyboard area
% Load file
load Pic

% Show image
imshow(I)

%%
% Segment key board
H = size(I, 1);

% Reduce the region processed
offset = 570;
M_td1 = zeros(offset,1280);
M_td2 = ones(H - offset,1280);
M_td = [M_td1;M_td2];

% Find 4 marked circles in the keyboard
[Point,mask] = MakePoint(I,M_td);

% 
Point

% 
imshow(mask)

%%
keyboardArea = MaskKb(Point);
imshow(keyboardArea)

%%
[Ori_GrK,Ori_ClK] = AreaKb(I, keyboardArea, offset);
imshow(Ori_GrK);
imshow(Ori_ClK);

%% 2. Finger detection
% Take new input and segment it
load Touch
[GrK,ClK] = AreaKb(I,in, offset);
imshow(ClK);

%%
% Skin segment
Y1 = ycbcr(ClK);
imshow(Y1);

%%
skin = medfilt2(Y1);
imshow(skin);

%% 3. Fingertip detection
[curPoint,cP] = Detect_Fintip(skin,7,2.5);
curPoint
%%
imshow(Ori_GrK);
hold on
for i = 1 : length(curPoint)
    plot(curPoint{i}(:,2),curPoint{i}(:,1),'*');
end