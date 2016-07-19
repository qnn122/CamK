function [skele] = FindCurve(path,dist,ang)
%
% In:
%   path:
%   dist:   distance between P(i) and P(i+-q)
%   ang:    thresholding angle
%
extrema = [];
nextrema = 0;
ampli = [];
head1 = 0;
tail1 = 0;  
mid1 = 0;
angle = [];
npath = length(path);
number = ones(1,npath);
nangle = 0;
for i=1:npath
    nangle = nangle + 1;
    point = path(i,:);
    point1 = path(max(1,i-dist),:);
    point2 = path(min(npath,i+dist),:);
    vctor1 = point1 - point; vctor2 = point2 - point;
    angle(nangle) = acos( (vctor1)*(vctor2)'/sqrt((vctor1(1)^2+vctor1(2)^2)*(vctor2(1)^2+vctor2(2)^2)));
    
    % Find the middle point of the white part - the graph's top
    if(angle(nangle)<ang)
        if(nangle>1&&angle(nangle-1)>=ang)
            head1 = nangle;
        end
    elseif(angle(nangle)>=ang&&head1>0)
        tail1 = nangle;
        if (tail1 - head1 >= 3)
            number(head1:tail1) = 2;
        end
        mid1 = round((head1 + tail1)/2.5);
        head1 = 0;
        extrema = [extrema,mid1];
        nextrema = nextrema + 1;
        ampli = [ampli,angle(mid1)];
    end
end
skele = zeros(1,nangle);
for k=1:nextrema
    skele(extrema(k)) = ampli(k);
end
% subplot(1,2,1)
% plot(1:nangle,angle);
% subplot(1,2,2)
% plot(1:nangle,skele);
