function [F,df1,df2]=Ftestmodelcmp(Rsqure1,numpara1,Rsqure2,numpara2,numdata)
% F=Ftestmodelcmp(Rsqure1,numpara1,Rsqure2,numpara2,numData)
%compute F value when comparing two models using R squre
% Input:
%       Rsqure1: r squre of the fuller model
%       numpara1: number of free parameters of the fuller model
%       Rsqure2:    r squre of the reduced model
%       numpara2:   number of free parameters of the reduced model
%       numdata: total of data point to predict
% 
% Output:
%       F:F value
%       df1,df2: two degree of freedom of Ftest
%  Example:
%   Model1: r2=0.94, 5 parameters;
%   Model2: r2=0.91, 3 parameters;
%   total 20 data points;
% Ftestmodelcmp(0.94,5,0.91,3,20);



if (~exist('Rsqure1','var')||isempty(Rsqure1))
    error('Please input Rsqure1');
end
if (~exist('numpara1','var')||isempty(numpara1))
    error('Please input numpara1');
end
if (~exist('Rsqure2','var')||isempty(Rsqure2))
    error('Please input Rsqure2');
end
if (~exist('numpara2','var')||isempty(numpara2))
    error('Please input Rsqure1');
end
if (~exist('numdata','var')||isempty(numdata))
    error('Please input numdata');
end



df1=numpara1-numpara2;
df2=numdata-numpara1;


F=(Rsqure1-Rsqure2)/df1/((1-Rsqure1)/df2);
 
fprintf('    df1 is  %02f;\n',df1);
fprintf('    df2 is  %02f;\n',df2);
fprintf('    F value is  %02f;\n',F);

end