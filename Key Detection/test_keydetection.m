% Script file: test_keydetection.m
% Test keydetection function

% Load keyboard layout
K_temp = load('Key_Struct');
K = K_temp.K;

% Load keyboard image
im_temp = load('Key_Area');
im = im_temp.Ori_ClK;

% Coordinate of fingertip
hf = figure();
ht = uicontrol('Style', 'text', 'String', '-1', ...
                'Units', 'normalized', 'Position', [0.45 0.8 0.1 0.1],...
                'FontSize', 20, 'ForegroundColor', 'b');
r = 5;
imshow(im)
x = 0;
while x >= 0    % Click outside of the axes (left side to break)
    [x,y] = ginput(1)
    key = keydetection(im, [y,x], K, r);
    if key == -1
        set(ht, 'String', '-1')
    else
        set(ht, 'String', key)
    end
end

