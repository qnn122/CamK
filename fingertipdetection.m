function [Ori_GrK, curPoint] = fingertipdetection(I, offset)
[H, W, C] = size(I);
% tic;
% Detect finger tip and plot
M_td1 = zeros(offset, W);
M_td2 = ones(H - offset, W);
M_td = [M_td1; M_td2];

%tElapsed_fgtdtn_in = toc      % max = 0.007 --> not signi

[Point,mask] = MakePoint(I,M_td);

in = MaskKb(Point, offset, W, H);
[Ori_GrK,Ori_ClK] = AreaKb(I,in, offset);


%% Next step
[GrK,ClK] = AreaKb(I,in, offset);

%tElapsed_fgtdtn_in = toc       % 0.23 - 0.3s

% Skin - hand segmentation
Y1 = ycbcr(ClK);
skin = medfilt2(Y1);

% Plot segmented iamge. ready to be labeled (finger tip)
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