function R = Intersection(I,r,A,B,C,D)

% check if circle center point I with radius r intersect polygon ABCD

% Input
%   I : center point
%   r : radius
%   A,B,C,D : Polygon
% Output
%   R : boolean (1 or 2)

if inpolygon(I(1),I(2),[A(1) B(1) C(1) D(1)],[A(2) B(2) C(2) D(2)]) % point in Key
    R = 1;
else
    d = Min_Dist(A,B,I);
    if ( d < r )
        R = 1;
    else
        d = Min_Dist(B,C,I);
        if ( d < r )
            R = 1;
        else
            d = Min_Dist(C,D,I);
            if ( d < r )
                R = 1;
            else
                d = Min_Dist(D,A,I);
                if ( d < r )
                    R = 1;
                else
                    R = 0;
                end
            end
        end
    end
end