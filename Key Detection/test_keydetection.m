% Script file: test_keydetection.m
% Test keydetection function

% Load keyboard layout
K_temp = load('Key_Struct');
K = K_temp.K;

% Load keyboard image
im_temp = load('Key_Area');
im = im_temp.Ori_ClK;

% Coordinate of fingertip
X = [68, 655];              % H key

% Click to get Coordinate if user want
% imshow(im);
% [y,x] = getpts(); % Press enter right after clicked
% close all
% 
% 
% % show clicked point
% imshow(im); hold on;
% plot(y,x,'r*');
% pause; close all;
% 
% X = round([x,y]);

%
r = 5;
key = keydetection(im, X, K, r);
disp(key);