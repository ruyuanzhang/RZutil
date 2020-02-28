function [timing, keys] = cleankeypress(timekeys,trigger)
% function output = cleankeypress(timekeys,trigger)
% clean up button press data saved by ptviewmoview.m function. Basically it
% deals with two problems
%`1. expand multiple key press
%`2. remove trigger key
%
% Input:
%   timekeys: a nx2 cell array that output from ptviewmovie.m function. the
%       first column is key press timing from onset of experiment, second
%       column is the key to press
%   trigger: trigger button of scanner, '5'(default) or 't'.
% Output:
%   timing: a column vector contains all key press timing according to 
%   keys: a cell vector contains all keybutton
% 
% Example:
%   [time,cleanedkeys] = clearnkeypress(timekeys);

if ~exist('timekeys','var')||isempty(timekeys)
    error('Please input timekey variables saved by ptviewmovie.m function');
end
if ~exist('trigger','var')||isempty(trigger)
    trigger = '5';
end

%% step 1. first expand multiple keybuttons

% sometimes participants might press multiple button at the same time. so
% we first deal with it
timekeysB = {};
for p=1:size(timekeys,1)
    if iscell(timekeys{p,2})
        for pp=1:length(timekeys{p,2})
            timekeysB{end+1,1} = timekeys{p,1};
            timekeysB{end,2} = timekeys{p,2}{pp};
        end
    else
        timekeysB(end+1,:) = timekeys(p,:);
    end
end
timing = cell2mat(timekeysB(:,1)); 
keys = timekeysB(:,2); % keys is still a cell vector

%% step 2. remove trigger keys
ind = cell2mat(cellfun(@ismember,repmat({trigger},size(keys,1),1),keys,'UniformOutput',0));
timing = timing(~ind);
keys = keys(~ind);

assert(all(size(timing)==size(keys)));

