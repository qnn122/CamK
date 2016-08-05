function key = keydetection(im, X, K, r)
% KEYDETECTION determine which key in the keyboard the X is putting on
% given the frame image 'im'. If no key found, the function return -1.
%
% In:
%   im:         current rgb image
%   X <1x2>:    Cartesian coordinate of the finger, [x, y], anchor =
%   K <1xn cell>: keyboard layout with n keys, field including
%           td <5x2 double>: coordinates of 4 corners and the center point
%           name : key name
%           area : key area (double)
%   Optional:
%   r   : delta r - radius of circle
%
% Out:
%   key <char> : key name
%
% Dependencies: Candidate_Key, Circle_Point, Circle_Filter,
% Cal_cover_ratio, Key_name

KB = rgb2gray(im);

% Skin segment - denoise
Skin = ycbcr(im);
Skin = medfilt2(Skin);

% Find S_avg as Avarage of Key Area
S_avg = 0;
for i = 1 : length(K)
    S_avg = S_avg + K{i}.area;
end
S_avg = S_avg / (64 + 5 - 1);

% TODO: Generalize this para
thres = 0.25; % threshold for cover ratio. if cover > thres -> still candidate

CK = Candidate_Key(X, K);     % find 4 nearest keys

CP = Circle_Point(X, r, size(KB,1), size(KB,2)); % extend to circle
New_CK = Circle_filter(CK, CP, K);   % key containing fingertips (posible keys)

if isempty(New_CK)
    disp('Nothing here')
    key = -1;
else
    numkey = length(New_CK);
    if numkey == 1
        name = Key_name(K{New_CK(numkey)}.name);
        disp(['Pressed key is : ' name]);
        key = name;
    else
        disp('Calculate coverage ratio');
        p = zeros(numkey, 1);
        for j = 1:numkey
            p(j) = Cal_cover_ratio(New_CK(j), Skin, K, S_avg);
        end
        vt = find(p > thres);
        if isempty(vt)
            disp('Nothing for coverage ratio');
            key = -1;
        else
            % find key have maxi value of p
            p_max = max(p);
            vt = find(p==p_max);
            name = Key_name(K{New_CK(vt)}.name);
            disp(['Pressed key is : ' name]);
            key = name;
        end
    end
end
