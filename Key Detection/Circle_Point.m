function Circle = Circle_Point(Co,r,sizeX,sizeY)
% Input
%   Co : Center Coordinate [x y]
%   r : radius
%   sizeX, sizeY : size of Picture containing Circle
% Output
%   Circle : Set of point in Circle

[columnsInImage,rowsInImage] = meshgrid(1:sizeX, 1:sizeY);
circlePixels = (rowsInImage - Co(2)).^2 + (columnsInImage - Co(1)).^2 <= r.^2;
[x,y] = find(circlePixels>0);
Circle = [y,x];