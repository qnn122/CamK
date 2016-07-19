clear
clc

%% Take Key Area first
load Pic        % release I: original rgb image
H = size(I, 1);
offset = 570;
M_td1 = zeros(offset,1280);
M_td2 = ones(H - offset,1280);
M_td = [M_td1;M_td2];
[Point,mask] = MakePoint(I,M_td);
in = MaskKb(Point);
[Ori_GrK,Ori_ClK] = AreaKb(I,in, offset);

%% Next step
load Touch
[GrK,ClK] = AreaKb(I,in, offset);

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

[curPoint,cP] = Detect_Fintip(skin,7,2.5);
imshow(Ori_GrK);
hold on
for i = 1 : length(curPoint)
    plot(curPoint{i}(:,2),curPoint{i}(:,1),'*');
end