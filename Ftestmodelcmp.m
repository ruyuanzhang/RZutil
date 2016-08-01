function [F,df1,df2]=Ftestmodelcmp(Rsqure1,numpara1,Rsqure2,numpara2,numdata)
% F=Ftestmodelcmp(Rsqure1,df1,Rsqure2,df2,numData)
%computer F value when comparing two models using R squre

%


df1=numpara1-numpara2;
df2=numdata-numpara1;


F=(Rsqure1-Rsqure2)/df1/((1-Rsqure1)/df2);
 
fprintf('    df1 is  %02f;\n',df1);
fprintf('    df2 is  %02f;\n',df2);
fprintf('    F value is  %02f;\n',F);

end