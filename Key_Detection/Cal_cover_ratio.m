function p = Cal_cover_ratio(key,Skin,K,S_avg)
% Input
%   key : number of key
%   Skin : Skin segment in keyboard area pic
%   K : Keys struct
% Output
%   p : cover ratio

B = zeros(size(Skin,1),size(Skin,2));
B(K{key}.td(1,1):K{key}.td(4,1),K{key}.td(1,2):K{key}.td(2,2)) = 1;
B = B & Skin;
p = sum(B(:))/K{key}.area;
f = K{key}.area / S_avg;
p = p * f;