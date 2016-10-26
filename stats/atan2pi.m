function v=atan2pi(y,x)
% atan2 function but output the arc range from 0~2*pi

if nargin==1 %just in case the user only gives the value of y myatan(y)
    x=1;
end
v=nan;

if x>0&y>=0
    v=atan2(y,x);
end
if x>0&y<0
    v=2*pi+atan2(y,x);
end

if y>=0 & x<0
    v=pi-atan2(y,x);
end
if y<0 & x<0
    v=pi+atan2(y,x);
end

end