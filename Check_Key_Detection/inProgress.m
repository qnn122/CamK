%% TEMPLATE KEYBOARD
clear
clc

Frame = imread('Template_Keyboard.png');
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


% Find white color pixel in Keyboard (default key's color is white)
YBR = rgb2ycbcr(Ori_ClK);
e = 50;
k = 10;
YBR = YBR(:,:,1)>255-e & abs(YBR(:,:,2)-YBR(:,:,3))<k & abs(YBR(:,:,2)-128)<k & abs(YBR(:,:,3)-128)<k;

% Remove largest white part -> remains keys part
L = bwlabel(YBR);
temp = zeros(max(L(:)),2);
for i = 1 : max(L(:))
    temp(i,:) = [i size(find(L==i),1)];
end

vtl = find(temp(:,2)==max(temp(:,2)));
L(L == temp(vtl,1)) = 0;
L(L~=0) = 1;
L = imfill(L);

% Detect Edge

Edge = edge(L,'Canny');
thres = 20;
Edge = bwareaopen(Edge,thres);

% Create Struct from template
K = Struct_Key(Edge,Point);

% plot test
% imshow(Ori_ClK); hold on;
% for i = 1 : 64
%     % disp(K{i}.name)
%     plot(K{i}.td(5,2),K{i}.td(5,1),'r*');
%     for j = 1 : 4
%         plot(K{i}.td(j,2),K{i}.td(j,1),'y*');
%     end
% end

% Save
save Key_Struct K
%% MAPING FROM TEMPLATE TO KEYBOARD IN VIDEO
% Load pic containing perfect keyboard
Frame = load ('KeyBoard.mat'); %Ori_ClK
Frame = Frame.Ori_ClK;

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


% A : Point(1) - B : Point(2) - C : Point(3) - B : Point(4) (clockwise)
A = Point(1,:);
B = Point(2,:);
C = Point(3,:);
D = Point(4,:);
% AD = D - A;
% AB = B - A;
% BC = C - B;
% CD = D - C;
DA = A - D;
DC = C - D;
CB = B - C;
% vectorW = Point(2,:) - Point(1,:);

% Load Struct
load Key_Struct
for j = 1 : length(K)
    Key = K{j}.axis;
    Key_map{j} = zeros(4,2);
    for i = 1 : 4
        DE = Key(i,1)* DA;
        CF = Key(i,1)* CB;
        E = DE + D;
        F = CF + C;
        EF = F - E;
        EP = Key(i,2)* EF;
        P = EP + E;
%         P = P;
        Key_map{j}(i,:) = [P(1),P(2)];
    end
end