function [Point,mask, fillmask] = MakePoint(I,offset)
% Retrun coordinate of 4 points
% From top-left to bot-right
% 4x2 matrix

% Input
%   I: RGB image
%   offset: from bottom up
% Output
%   Point: <4x2> 4 markers as in ordered (Coordinate in full image I, not
%                                         in offset image)
%   mask: <same size with I> binary img with 4 white part for 4 markers
%   fillmask: <offset x W> binary img with white filled polygon of 4 markers 
%            (old MaskKb function)

H = size(I,1);
W = size(I,2);
% M_td1 = zeros(vidH-offset,vidW);
% M_td2 = ones(offset,vidW);
% M_td = [M_td1; M_td2];
M_td = zeros(H,W);
M_td(H-offset+1:end,1:end) = 1;

cR = I(:, :, 1);
cG = I(:, :, 2);
cB = I(:, :, 3);
mask1 = (cR < 0.9*cB) & (cG < 0.88*cB);
mask = mask1 & M_td;
mask = medfilt2(mask);
% imshow(mask)
CC = bwconncomp(mask);
le = [];
for i = 1 : length(CC.PixelIdxList)
    le = [le;length(CC.PixelIdxList{i})];
end
[b,ix] = sort(le,'descend');
%NewMask = zeros(size(Gr,1),size(Gr,2));
for i = 5 : length(ix)
    id = ix(i);
    PixId = CC.PixelIdxList{id};
    [x,y] = ind2sub(size(mask), PixId);
    mask(x,y) = 0;
end
Point = [];
for i = 1 : 4
    id = ix(i);
    PixId = CC.PixelIdxList{id};
    [x,y] = ind2sub(size(mask), PixId);
    Point = [Point;[round(mean(x)) round(mean(y))]];
end
Point = OrderPoint(Point);

xq = repmat([H-offset+1:H]', 1, W);

yq = repmat(1:W, offset, 1);

fillmask = inpolygon(xq,yq,Point(:,1),Point(:,2));