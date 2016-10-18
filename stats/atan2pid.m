function v=atan2pid(y,x)
if nargin==1 %just in case the user only gives the value of y myatan(y)
    x=1;
end
v=nan;
if x>0
    v=atand(y/x);
end
if y>=0 & x<0
    v=180+atand(y/x);
end
if y<0 & x<0
    v=-180+atand(y/x);
end
if y>0 & x==0
    v=180/2;
end
if y<0 & x==0
    v=-180/2;
end
if v<0
    v=v+2*180;
end
end