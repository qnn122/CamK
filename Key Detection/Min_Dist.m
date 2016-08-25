function d = Min_Dist(A,B,I)

% find minimum distance from I to AB
% Input
%   A,B,I : Point A,B,I
% Output
%   d : min distance

H = Projection_Point(A,B,I);
if ((H(1)-A(1)) * (H(1)-B(1)) < 0) && ((H(2)-A(2)) * (H(2)-B(2)) < 0) % H in AB
    d = norm(H-I);
else % min is IA or IB
    d1 = norm(A-I);
    d2 = norm(B-I);
    if d1 < d2
        d = d1;
    else
        d = d2;
    end
end

