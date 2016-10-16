function c0=mycolororder(type)
%two different types of color order when making figures
 

switch type
    case 'color'
        c0=[0    0.4470    0.7410
            0.8500    0.3250    0.0980
            0.9290    0.6940    0.1250
            0.4940    0.1840    0.5560
            0.4660    0.6740    0.1880
            0.3010    0.7450    0.9330
            0.6350    0.0780    0.1840];
    case 'gray'
        c0=linspace(0,1,7)'*ones(1,3);
        
end
end