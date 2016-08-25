function New_CK = Circle_filter(CK,I,r,K)
% Input
%   CK : Candidate_key (position of key. Ex: 1 for "Del")
%   I : Center Points in Circle (vector 1 x 2)
%   r : radius
%   K : Key_Struct
% Output
%   New_CK : New Candidate_Key (filter)

New_CK = zeros(4,1);
for i = 1 : length(CK)
    A = K{CK(i)}.td(1,:);
    B = K{CK(i)}.td(2,:);
    C = K{CK(i)}.td(3,:);
    D = K{CK(i)}.td(4,:);
    if Intersection(I,r,A,B,C,D) % point in Key
        New_CK(i) = CK(i);
    end 
end
New_CK = New_CK(find(New_CK));
