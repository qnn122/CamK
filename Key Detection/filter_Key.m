function F = filter_Key(O,S_avg,a,b)
% Input
%   O : pre Key_segment Pic (not remove noise, big zone yet)
%   S_avg : Average of Key Area
%   a, b : parameter of appro Key Area
% Output
%   F : Key_segment Pic

I = bwlabel(O);
F = zeros(size(I,1),size(I,2));
for i = 1 : max(I(:))
    area = size(find(I==i),1);
    Mask = I;
    Mask(Mask~=i) = 0;
    Mask(Mask~=0) = 1;
    if (area < a*S_avg || area > b*S_avg)
        Mask = bwmorph(Mask,'erode');
    end
    F = F | Mask;
end