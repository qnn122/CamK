function F = findcoefhomotrans(oldPoint, newPoint)
% FINDCOEFHOMOTRANS find coeffience of homographic transforming function
% give 4 points of each coordinate system
%
% input : 
%   oldPoint <4 x 2>: original system
%   newPoint <4 x 2>: mapped system
% output :
%   F <8 x 1>:  coefficients

x1 = oldPoint(1,:);
x2 = oldPoint(2,:);
x3 = oldPoint(3,:);
x4 = oldPoint(4,:);
X1 = newPoint(1,:);
X2 = newPoint(2,:);
X3 = newPoint(3,:);
X4 = newPoint(4,:);

p = [x1 1;x2 1;x3 1;x4 1];
ze = zeros(4,3);
p = [p ze; ze p];

r1 = -[x1*X1(1);x2*X2(1);x3*X3(1);x4*X4(1)];
r2 = -[x1*X1(2);x2*X2(2);x3*X3(2);x4*X4(2)];
r = [r1;r2];

p = [p r];
P = [X1(1);X2(1);X3(1);X4(1);X1(2);X2(2);X3(2);X4(2)];
F = p\P;