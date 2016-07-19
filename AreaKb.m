function [GrK,ClK] = AreaKb(I, in, offset) 
%% AREAKB returns ....
% In:
% 	I:	raw image
% 	in:	binary keyboard area
%
% Out:
% 	GrK: Gray keyboard
%	Clk: Color keyboard
% See also: imshow
Gr = rgb2gray(I);
GrK = Gr(offset+1:size(I,1),:).*uint8(in);
ClK = I(offset+1:size(I,1),:,:).*repmat(uint8(in),[1,1,3]);