% ----------- TEST ALL OVER AGAIN -----------------

% Link Video : F:\Desktop\CamKvid\DataCollection_100Hz\Thay_Binh_02\2016_05_28_15_06_17\2016_05_28_15_06_17_video.mp4

% Frame to take Keyboard : 21

clear
clc

%% DETECT KEYBOARD AREA

% Load pic containing perfect keyboard
Frame = load ('KeyBoard.mat'); %Ori_ClK
Frame = Frame.Ori_ClK;
Frame = imread('Template_Keyboard.png');

% Decide area of detecting keyboard
portion = 1; % portion of detect (from bottom up)
offset = round(portion*size(Frame,1));
M_td1 = zeros(size(Frame,1)-offset,size(Frame,2)); 
M_td2 = ones(offset,size(Frame,2));
M_td = [M_td1;M_td2]; % Create mask

% Find Point and Mask
[Point,mask] = MakePoint(Frame,M_td);
% Fill Polygon
in = MaskKb(Point,offset,size(Frame,2),size(Frame,1));
% Find Keyboard base on in-mask
[Ori_GrK,Ori_ClK] = AreaKb(Frame,in,offset);


%% Key - segmentation

F = Key_Segment(Ori_ClK);
% Make data structure for keys
K = Struct_Key(F);
