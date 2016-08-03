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

%
r = 5;
key = keydetection(im, X, K, r)