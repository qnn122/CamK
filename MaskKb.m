function in = MaskKb(Point, offset, W, H)   % 0.178 s
%% Rerturn binary image
% 1 : inside keyboard polygon
% 0: otherwise

xq = repmat([offset+1:H]', 1, W);

yq = repmat(1:W, H-offset, 1);

in = inpolygon(xq,yq,Point(:,1),Point(:,2));