function H = Projection_Point(A,B,C)

% Find Projection of C on AB
% Input
%   A,B,C : Point A,B,C
% Output
%   H : Projection Point of C on AB

xa = A(1); xb = B(1); xc = C(1);
ya = A(2); yb = B(2); yc = C(2);

% [sol_xh, sol_yh] = solve([(ya - yb)*xh + (xb-xa)*yh + xa*yb - xb*ya== 0 ...
%                          ,(xb - xa)*(xh-xc) + (yb-ya)*(yh-yc)  == 0], [xh, yh]);

xh = (xc*xa^2 - 2*xc*xa*xb - xa*ya*yb + yc*xa*ya + xa*yb^2 - yc*xa*yb + xc*xb^2 + xb*ya^2 - xb*ya*yb - yc*xb*ya + yc*xb*yb)/(xa^2 - 2*xa*xb + xb^2 + ya^2 - 2*ya*yb + yb^2);
yh = (xa^2*yb - xa*xb*ya - xa*xb*yb + xc*xa*ya - xc*xa*yb + xb^2*ya - xc*xb*ya + xc*xb*yb + yc*ya^2 - 2*yc*ya*yb + yc*yb^2)/(xa^2 - 2*xa*xb + xb^2 + ya^2 - 2*ya*yb + yb^2);

H = [xh yh];