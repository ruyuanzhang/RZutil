function v=atan2pid(y,x)
% atan2 function but output the arc range from 0~2*pi



if (~isnan(y))&(~isnan(x))
if y>0
    v=atan2d(y,x);
end

if y<=0
    v=360+atan2d(y,x);
end

else
    v=nan;
end

end