function v=atan2piclock(y,x)
% atan2 function but output the arc range from 0~2*pi. We set 12 clock is 0 and
% [0 2*pi] in clockwise direction. So [0, 3, 6, 9] clock are [0, pi/2, pi, 3pi/2]

if nargin==1 %just in case the user only gives the value of y myatan(y)
    x=1;
end
v=nan;

if x>=0 && y>=0
    v=pi/2-atan2(y,x);
end
if x>=0&&y<0
    v=pi/2-atan2(y,x);
end

if y>=0 && x<0
    v=2*pi-(atan2(y,x)-pi/2);
end
if y<0 && x<0
    v=pi/2-atan2(y,x);
end

end