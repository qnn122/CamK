function F = Key_Segment(Ori_ClK)
% Input
%   Ori_ClK : RAW RGB Keyboard (Pic)
% Output
%   F : Keys segment Pic

KB = rgb2gray(Ori_ClK);

% filter
m = 3;
n = 3;
KB = imfilter(KB, fspecial('gaussian', [m n]));

% Use Canny edge
Edge = edge(KB,'Canny');

% Remove Small (< 20)
thres = 20;
L = bwareaopen(Edge,thres);

% Remove Long which not in keyboard (the lowest and highest boundary)
L = bwlabel(L);
temp = zeros(max(L(:)),2);
for i = 1 : max(L(:))
    temp(i,:) = [i size(find(L==i),1)];
end

vtl = find(temp(:,2));
high = 120;
low = 30;
for i = 1 : length(vtl)
    [x y] = find(L == temp(vtl(i),1));
    if isempty(find(x>high)) == 0 || isempty(find(x<low)) == 0
        L(L == temp(vtl(i),1)) = 0;
    end
end

% Apply Morphology 'bridge' disconnect pixel
Lf = bwmorph(L,'bridge');
Lf = imfill(im2double(Lf));

thres = 100;
Lf = bwareaopen(Lf,thres);

% Find white color pixel in Keyboard (default key's color is white)
YBR = rgb2ycbcr(Ori_ClK);
e = 125;
k = 10;
YBR = YBR(:,:,1)>255-e & abs(YBR(:,:,2)-YBR(:,:,3))<k & abs(YBR(:,:,2)-128)<k & abs(YBR(:,:,3)-128)<k;

% Merge 2 map into 1
F = YBR & Lf;

% Remove Small (< 100)
thres = 100;
F = bwareaopen(F,thres);

% Detect Key area. If not in approximate range -> Not a key. Do twice 
num_key = 64 + 5 - 1;
S_all = sum(Lf(:));
S_avg = S_all / num_key;

a_low = 0.15;
a_high = 2;
F = filter_Key(F,S_avg,a_low,a_high);

a_low = 0.15;
a_high = 1.15;
F = filter_Key(F,S_avg,a_low,a_high);

F = bwmorph(F,'endpoints');
F = bwmorph(F,'spur');
thres = 50;
F = bwareaopen(F,thres);