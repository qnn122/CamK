function [Point,mask] = MakePoint(I,M_td)
%% Retrun coordinate of 4 points
% From top-left to bot-right
% 4x2 matrix

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
