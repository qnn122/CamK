function K = Struct_Key(F)
% Input
%   F : Keys' boundary segment Pic
% Outpu
%   K : Data structure of Keys (cell > struct)

LW = bwlabel(F);
y_max = 0;
flag =  0;
if max(LW(:))~= 64
    disp('WARNING !!! NOT ENOUGH KEY');
end
for i = 1 : 64
    %disp(i);
    [x y] = find(F~=0);
    % Find key at the right of previous key (arrange by y)
    vt_y = find(y>y_max);
    if (~isempty(vt_y))
        x_key = x(vt_y);
        y_key = y(vt_y);
    else
        x_key = x;
        y_key = y;
    end
    
    % Find key which is nearest with the camera (arrange by x)
    x_max = max(x_key);
    minus = 2;
    vt_x = find(x_key>=x_max - minus);
    x_key = x_key(vt_x);
    y_key = y_key(vt_x);
    vt_y = find(y_key==min(y_key));
    y_key = y_key(vt_y);
    x_key = x_key(vt_y);
    x_key = x_key(1);
    y_key = y_key(1);
    gts = LW(x_key,y_key);
    [x y] = find(LW == gts);
    % Find 4 point + center
    x_min = min(x);
    x_max = max(x);
    y_min = min(y);
    y_max = max(y);
    x_tb = round(mean(x));
    y_tb = round(mean(y));
    
    % Check numb 54 'Up' + 'Down'
    if (i == 54)
        if (length(x) > 100) % Merge detected -> disconnect
            vt_x = find(x == x_tb);
            x_change = x(vt_x);
            y_change = y(vt_x);
            for k = 1 : length(x_change)
                LW(x_change(k),y_change(k)) = 0;
            end
            vt_x = find(x < x_tb);
            x_change = x(vt_x);
            y_change = y(vt_x);
            for k = 1 : length(x_change)
                LW(x_change(k),y_change(k)) = 63; % numb for 'Down' key
            end
            
            % Find again
            [x y] = find(LW == gts);
            % Find 4 point + center
            x_min = min(x);
            x_max = max(x);
            y_min = min(y);
            y_max = max(y);
            x_tb = round(mean(x));
            y_tb = round(mean(y));
        else
            
        end
    else
        
    end
    % Make Struct
    K{i} = struct;
    K{i}.td = [x_min y_min;x_min y_max;x_max y_max;x_max y_min; x_tb y_tb];
    K{i}.name = i;
    K{i}.area = round(polyarea(K{i}.td(1:4,1),K{i}.td(1:4,2)));
    temp = LW;
    LW(LW == gts) = 0;
    temp(temp==gts) = 0;
    temp(temp~=0) = 1;
    F = F & temp;
    
    % test plot
%     imshow(F)
%     if i > 53
%         pause
%     end
%     close all
    
end

if length(K)~= 64
    disp('ERROR ERROR ERROR ERROR ERROR ERROR ERROR');
end

%%
% Z = zeros(size(LW,1),size(LW,2));
% for i = 14 : max(LW(:))
%     [x y] = find(LW == i);
%     Z(x,y) = 1;
%     imshow(Z)
%     pause
%     close all
% end