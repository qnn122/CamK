function kbmask = extract_kbmask(I, offset)
% EXTRACT_KBMASK extract keyboard area where one value represent keyboard
% portion, zero otherwise.

[H, W, C] = size(I);
% tic;
% Detect finger tip and plot
M_td1 = zeros(offset, W);
M_td2 = ones(H - offset, W);
M_td = [M_td1; M_td2];

%tElapsed_fgtdtn_in = toc      % max = 0.007 --> not signi

% ======== Extract keyboard area ... =========
[Point, mask] = MakePoint(I, M_td); ...(based on 4 circles)
kbmask = MaskKb(Point, offset, W, H);