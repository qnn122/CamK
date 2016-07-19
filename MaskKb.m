function in = MaskKb(Point)
%% Rerturn binary image
% 1 : inside keyboard polygon
% 0: otherwise
xq = [];
for i = 1 : 1280;
    xq = [xq [571:720]'];
end
yq = [];
for i = 1 : 150;
    yq = [yq;[1:1280]];
end

in = inpolygon(xq,yq,Point(:,1),Point(:,2));