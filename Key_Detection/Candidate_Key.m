function CK = Candidate_Key(Co,K)
% Input
%   Co : Coordinate (x,y)
%   K : Struct_Key
% Output
%   CK : Struct of 4 candidate Key

% beginning key each line and find x-coordinate for each line
line = [1 15 29 42 54];
x_line = zeros(length(line),1);
for i = 1 : length(line)
    if i ~= length(line)
        en = line(i+1);
    else
        en = 64 + 1;
    end
    sum = 0;
    for j = line(i) : en-1
        sum = sum + K{j}.td(5,1);
    end
    sum = sum / (en - line(i));
    x_line(i) = sum;
end

% find distance -> 2 row nearest (x_cor)
dist_x = abs(x_line-Co(1));
x_line = [];
[t1,t2] = min(dist_x);
x_line = [x_line;t2];
dist_x(t2) = 10000; %<- give it a massive value to remove min
[t1,t2] = min(dist_x);
x_line = [x_line;t2];

% find 4 nearest keys (y_cor)
CK = [];
for i = 1 : length(x_line)
    row = line(x_line(i));
    if x_line(i) ~= 5
        next_row = line(x_line(i)+1);
    else
        next_row = 64 + 1;
    end
    y_line = [];
    for k = row : next_row - 1
        y_line = [y_line; K{k}.td(5,2)];
    end
    dist_y = abs(y_line-Co(2));
    y_line = [];
    [t1,t2] = min(dist_y);
    y_line = [y_line;t2];
    dist_y(t2) = 10000;
    [t1,t2] = min(dist_y);
    y_line = [y_line;t2];
    y_line = y_line + row - 1;
    CK = [CK;y_line(1);y_line(2)];
end

