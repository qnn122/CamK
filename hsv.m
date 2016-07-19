function I = hsv(X)
L = rgb2hsv(X);
L1 = fix(255*L(:,:,1));
L2 = L(:,:,2);
I = L1 < 50 & L2 >0.23 & L2 <0.68;