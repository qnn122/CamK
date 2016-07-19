function [Ori_GrK, curPoint] = fingertipdetection(I, offset)
[H, W, C] = size(I);

% Detect finger tip and plot
M_td1 = zeros(offset, W);
M_td2 = ones(H - offset, W);
M_td = [M_td1;M_td2];
[Point,mask] = MakePoint(I,M_td);

in = MaskKb(Point, offset, W, H);
[Ori_GrK,Ori_ClK] = AreaKb(I,in, offset);

%% Next step
[GrK,ClK] = AreaKb(I,in, offset);

% K = kovac(ClK);
% Y = ybr(ClK);
Y1 = ycbcr(ClK);
% Y2 = hsv(ClK);
skin = medfilt2(Y1);
% subplot(1,2,1);imshow(Y);
% subplot(1,2,2);imshow(mask);

% subplot(2,3,1);imshow(I);
% subplot(2,3,2);imshow(K);
% subplot(2,3,3);imshow(Y);
% subplot(2,3,4);imshow(Y1);
% subplot(2,3,5);imshow(Y2);

% Plot segmented iamge. ready to be labeled (finger tip)
imshow(Ori_GrK);

% ======== Detect Fingertip ===========
curPoint = 0;
try
    [curPoint,cP] = Detect_Fintip(skin,7,2.5);
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
    plot(curPoint{i}(:,2),curPoint{i}(:,1),'*', ...
        'MarkerSize', 12)
end
hold off
disp('=== fingertip detected ===')