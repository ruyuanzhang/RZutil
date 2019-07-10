function [trainind,testind]=getsplitdataind(elenum,k)
% function [trainind,testind]=getsplitdataind(elenum,k)
% This function is useful when we consider cross-validation, we have to
% split data into training dataset and testing dataset. This is a easy way 
%
%
%
% Input:
%   elenum: a scalar, how many elements you want to split
%   k:k-fold.
%
% Output:
%   trainind:a cell vector contains the element index for training data set
%   testind:a cell vector contains the element index for testing data set 
% 
% trainind and testing ind are 1on1 correponded.to split the data, you can
% use the format like
%   [trainind,testind]=getsplitdataind(100,20)
%   for i=1:20
%       trainingdata = data(trainind{i});
%       testingdata = data(testind{i});
%       %fit the model then test
%   end
%

% checkinput
if ~exist('elenum','var')||isempty(elenum)
    error('Please input the data element numer');
end
if ~exist('k','var')||isempty(k)
    error('K number for k fold cross validation');
end

if rem(elenum,k)~=0
    warning('number of element in data is not aliquot by k,may reinput k!');
end
ind = randperm(elenum);
foldsize = ceil(elenum/k);

trainind=cell(1,k); % we use cell case to deal with unaliquot part
testind=cell(1,k);

for i=1:k
    if i<k
        indtmp = foldsize*(i-1)+1:foldsize*i;
    else % 
        indtmp = foldsize*(i-1)+1:elenum;
    end
    testind{i} = ind(indtmp);
    trainind{i} = deleteel(ind,indtmp);
end


