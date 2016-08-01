function mycd(pathname)
%%quickly switch between some frequently used paths
%   utility functions
%       util = 'Users/ruyuan/Documents/Code_git/CodeRepositories';
%   main path
%       main = '~/Documents/git';
%

if(~exist('pathname','var') || isempty(pathname))
    error('Please input the correct pathname mask');
end

if strcmp(pathname,'util')
    target_path = '/Users/ruyuan/Documents/Code_git/CodeRepositories';
elseif strcmp(pathname,'main')
    target_path = '~/Documents/Code_git';
else
    error('it seems I dont save this path')
end


cd(target_path);