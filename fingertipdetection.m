function [Ori_GrK, curPoint, Ori_ClK] = fingertipdetection(I, offset)
% FINGERTIPDETECTION localized fingertips (if any) in an image and return
% the their positions and plot them along with the original image
%
% In:
%   I <m x n x 3>   : a RGB image
%   offset          : the vertical segment that will be cut off from the
%                       original image

[H, W, C] = size(I);
% tic;
% Detect finger tip and plot
% M_td1 = zeros(offset, W);
% M_td2 = ones(H - offset, W);
% M_td = [M_td1; M_td2];

%tElapsed_fgtdtn_in = toc      % max = 0.007 --> not signi

% ======== Extract keyboard area ... =========
[Point, mask, in] = MakePoint(I, offset); ...(based on 4 circles)
[Ori_GrK, Ori_ClK] = AreaKb(I, in);
%tElapsed_fgtdtn_in = toc       % 0.23 - 0.3s

% ======== Skin - hand segmentation ===========
Y1 = ycbcr(Ori_ClK);
skin = medfilt2(Y1);

% Plot segmented image. ready to be labeled (finger tip)
imshow(Ori_GrK);

%tElapsed_fgtdtn_in = toc       % significant = 0.3 - 0.3s

% ======== Detect Fingertip ===========
curPoint = 0;
try
    [curPoint, cP] = Detect_Fintip(skin,7,2.5);     % speed test = 0.05 -> not significant
catch e
    warning('MATLAB:unassignedOutputs', ...
            'Could not detect any fingertip');
%     if strcmp(e.identifier, 'MATLAB:unassignedOutputs')
%         warning('Could not detect any fingertip');
%     end
    return
end
    
hold on
% Plot fingertip
for i = 1 : length(curPoint)
    plot(curPoint(:,2),curPoint(:,1),'*', ... % 2: y, 1:x
        'MarkerSize', 12)
end
hold off
disp('=== fingertip detected ===')