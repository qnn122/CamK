function I = ycbcr(X)
% YCBCK: skin segmentation
% Out:
% 	I:

I = rgb2ycbcr(X);
B = double(I(:,:,2));
R = double(I(:,:,3));

A = 1.5862*B + 20 - R;
L1 = (A >= 0);

B = R - 0.3448*B - 76.2069;
L2 = (B >= 0);

C = R + 4.5652*B - 234.5652;
L3 = (C >= 0);

D = -1.15*B + 301.75 - R;
L4 = (D >= 0);

E = -2.2857*B + 432.85 - R;
L5 = (E >= 0);

I = L1 & L2 & L3 & L4 & L5;