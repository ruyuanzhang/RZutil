function outStruct=updatestruct(input, target, mode)
% function outStruct=updatestruct(input, target, mode)
% 
% Use the value in the screenRect <Struct> to update values in <target>.
%
% <input>,<target>: two structs
% <mode>: 
%   0 (default), combine all fields from two structs, if two struct
%       share the same field, use the value in <input>
%   1, only update <target> non empty value in <input>
%   1, check all fields in <input>, if a field in <input> does not exist in
%       <target>, we issue an error

if ~exist('input','var')||isempty(input)
    error('You should provide an input struct');
end
if ~exist('target','var')||isempty(target)
    error('You should provide an target struct');
end
if ~exist('mode','var')||isempty(mode)
    mode=0;
end


fn = fieldnames(input);
assert(~isempty(fn), 'no fields in the input struct!');

if mode==0
    for f = 1:numel(fn)
        value = input(fn{f});
        if ~isempty(value)
            target.(fn{f})=input.(fn{f});
        end
    end
elseif mode==1
   for f = 1:numel(fn)
        value=input(fn{f});
        if ~(isnumeric(opt) && isempty(opt)) && isfield(p,fn{f})
            p.(fn{f})=input_opts.(fn{f});
        else
            error('You might input wrong variable: %s', fn{f});
        end
    end
end









end