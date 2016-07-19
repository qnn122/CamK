function in = MaskKb(Point, offset, W, H)
%% Rerturn binary image
% 1 : inside keyboard polygon
% 0: otherwise

xq = [];
for i = 1 : W;
    xq = [xq [offset+1:H]'];
end
yq = [];
for i = 1 : (H-offset);
    yq = [yq;[1:W]];
end

in = inpolygon(xq,yq,Point(:,1),Point(:,2));