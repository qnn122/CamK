function [GrK,ClK] = AreaKb(I, fillmask) 
%% AREAKB returns ....
% In:
% 	I <m x n x 3>:  a RGBraw image
% 	fillmask : binary keyboard area
%
% Out:
% 	GrK: Gray keyboard
%	Clk: Color keyboard
% See also: imshow

offset = size(I, 1) - size(fillmask, 1);
Gr = rgb2gray(I);
GrK = Gr(offset+1:size(I,1),:).*uint8(fillmask);
ClK = I(offset+1:size(I,1),:,:).*repmat(uint8(fillmask),[1,1,3]);