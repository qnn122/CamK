function nP = OrderPoint(P)
% 4 point in order, which ...

[te,ix] = sort(P(:,1),'ascend');
P = P(ix,:);
P1 = P(1:2,:);
P2 = P(3:4,:);
[te,ix] = sort(P1(:,2),'ascend');
P1 = P1(ix,:);
[te,ix] = sort(P2(:,2),'descend');
P2 = P2(ix,:);
nP = [P1;P2];