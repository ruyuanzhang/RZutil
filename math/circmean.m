function f = circmean(m,weight,modv,dim)

if ~exist('modv','var') || isempty(modv)
  modv = 2*pi;
end
if ~exist('dim','var') || isempty(dim)
  m = m(:);
  dim = 1;
end

f = mod(angle(nansum(ang2complex(m*((2*pi)/modv)).* vflatten(weight),dim)),2*pi)*(modv/(2*pi));