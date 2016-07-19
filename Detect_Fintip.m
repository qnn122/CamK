function [curPoint,cP] = Detect_Fintip(skin,dis,ang)
E = edge(uint8(skin),'Canny');
CC = bwconncomp(E);     % find separate regions
B={};
C={};
nB = 0;
for i = 1 : CC.NumObjects
    PixId = CC.PixelIdxList{i};
    if (length(PixId >= 50))    % highly likely (a) finger(s)
        [x,y] = ind2sub(size(E), PixId);
        K = E(min(x):max(x),min(y):max(y)); % Rect region surrounds the detected obj
        nB = nB + 1;
        B{nB} = K;
        C{nB} = [x,y];    % Unordered boundary of the obj           
    end
end

path = {};
for i = 1 : nB
    K = B{i};
    mix = min(C{i}(:,1));
    miy = min(C{i}(:,2));
    st1 = C{i}(1,1) - mix + 1;
    st2 = C{i}(1,2) - miy + 1;
    patht = bwtraceboundary(K,[st1, st2],'N');
    patht(:,1) = patht(:,1) + mix - 1;
    patht(:,2) = patht(:,2) + miy - 1;
    patht1 = unique(patht,'rows','stable');
    path{i} = [patht1;patht(length(patht1)+1,:)];
end

% imshow(GrK);
% for i = 1 : length(path)
%     hold on;
%     p = path{i};
%     for j = 1 : length(p)
%         plot(p(j,2),p(j,1),'*');
%         pause
%     end
% end


curPoint = {};
ncP = 0;
for i = 1 : length(path)
    number = FindCurve(path{i},dis,ang);
    a = find(number);
    if (~isempty(a))
        temp = path{i}(a,:);
        [a,b] = max(temp(:,1));
        ncP = ncP + 1;
        curPoint{ncP} = temp(b,:);
        cP{i} = temp;
    end
end