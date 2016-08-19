function [GrK,ClK] = AreaKb(I, in) 
%% AREAKB returns ....
% In:
% 	I <m x n x 3>:  a RGBraw image
% 	in :    binary keyboard area
%
% Out:
% 	GrK: Gray keyboard
%	Clk: Color keyboard
% See also: imshow

offset = size(I, 1) - size(in, 1);
Gr = rgb2gray(I);
GrK = Gr(offset+1:size(I,1),:).*uint8(in);
ClK = I(offset+1:size(I,1),:,:).*repmat(uint8(in),[1,1,3]);