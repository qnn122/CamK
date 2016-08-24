function timestamp = Find_timestamp(peak,time,mov,Fs)
% Input
%   peak : peak detection 0 and 1 vector (1 is peak)
%   time : timestamp in csv file
%   mov : video reader frame object
%   Fs : frame per second as recorded (30 Fps)
% Output
%   timestamp : Touch-Frame number

pos = find(peak); % find peak (value = 1)
timestamp = time(pos) - time(1); % time from beginning
timestamp = ceil(timestamp / (1000/Fs)); % find Frame number
for i = 1 : length(timestamp) % plot
    imshow(mov(timestamp(i)).cdata);
    pause(0.5)
end