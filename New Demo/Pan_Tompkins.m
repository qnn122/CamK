function peak = Pan_Tompkins(data,windowWidth)
%
% h = fdesign.lowpass('N,F3dB', 12, 0.5);
% d1 = design(h, 'butter');
% y = filtfilt(d1.sosMatrix, d1.ScaleValues, data);

ydiff = diff(data);    % differentiator
ysq = ydiff.^2;     % squaring
% windowWidth = 5;   % moving intergration window
yint = conv(ysq, ones(1, windowWidth)); % intergration
yid = diff(yint);


peak = zeros(length(data),1);
i = 3;
while i <= length(data)
    if yid(i) < yid(i-1) && yid(i-1)>yid(i-2) && yid(i-1) > 0.0048 % thres for peak
        peak(i-1) = 1;
        i = i + windowWidth - 1;
    end
    i = i + 1;
end
% Plot result
figure;
subplot(5,1,1), plot(data);
subplot(5,1,2), plot(ydiff, 'g-');
subplot(5,1,3), plot(yint, 'k-');
subplot(5,1,4), plot(yid, 'r-');
subplot(5,1,5), plot(peak, 'r-');