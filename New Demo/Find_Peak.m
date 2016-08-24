function peak = Find_Peak(data,window,dif)

peak = zeros(length(data),1);

flag = 0;
i = 0;
vt = 1;
while i <= length(data)
    if i - vt >= window
        flag = 1;
    end
    if (flag == 1)
        m = mean(data(i-window:i-1));
        s = std(data(i-window:i-1));
        if abs(data(i) - m) >= dif*s
            peak(i) = 1;
            flag = 0;
            data(i) = 0;
            vt = i + round(window/2);
            i = vt;
        end
    end
    i = i + 1;
end

% for i = window+1 : length(data)
%     m = mean(data(i-window:i-1));
%     s = std(data(i-window:i-1));
%     if abs(data(i) - m) >= dif*s
%         peak(i) = 1;
%         data(i) = 0;
%     end
% end