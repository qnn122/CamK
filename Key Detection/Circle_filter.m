function New_CK = Circle_filter(CK,CP,K)
% Input
%   CK : Candidate_key (position of key. Ex: 1 for "Del")
%   CP : Points in Circle (vector n x 2)
%   K : Key_Struct
% Output
%   New_CK : New Candidate_Key (filter)

New_CK = zeros(4,1);
for i = 1 : length(CK)
    for j = 1 : length(CP)
        A = K{CK(i)}.td(1,:);
        B = K{CK(i)}.td(2,:);
        C = K{CK(i)}.td(3,:);
        D = K{CK(i)}.td(4,:);
        P = CP(j,:);
        dot1 = dot(B-A,P-A);
        dot2 = dot(C-B,P-B);
        dot3 = dot(D-C,P-C);
        dot4 = dot(A-D,P-D);
        if (dot1 >= 0 && dot2 >= 0 && dot3 >= 0 && dot4 >= 0) % point in Key
            New_CK(i) = CK(i);
            break;
        end
    end
end
New_CK = New_CK(find(New_CK));
