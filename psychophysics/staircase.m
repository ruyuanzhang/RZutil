% sc = staircase('create', params); % create struct
% sc = staircase('update', sc, correct); % update data for each trial
% staircase('plot', sc); % plot result online or offline
% sc=staircase('compute', sc, nDiscard); % re-compute threshold
% sc=staircase('undo', sc); % remove last trial
% 
% This is a single m file for staircase procedure using stochastic
% approximation. In your code, you 'create' the staircase struct, giving it
% necessary parameters. Then within each trial, you 'update' it once. After
% you are done, you 'plot' the result. In the extreme case, you call this
% only in 3 lines, and the result is shown to you!
% 
% sc = staircase('create', [up down], [min max], nTrials, nReversals, linStep);
% - Initialize the staircase. The 2nd input defines the staircase type,
% default [1 3], which means 1-up, 3-down staircase. It can also be a
% scalar number defining the percent performance (0~1). The 3rd input is
% stimulus range, default [0 1]. The 4th and 5th are maximal number of
% trials and maximal number of reversals to run. These two parameters
% determine when the staircase stops. If you leave them out, or set both
% them to [] or inf, the default 100 trials and 12 reversals will be used,
% so the staircase stops when either of them is met. If you set only one of
% them, this one will be the only stop criterion. The value in sc.stimVal
% is the stimulus value for next trial. If it is empty, it means a stop
% criterion has met. If the 6th input, linStep, is nonzero, it means the
% staircase step will be additive, instead of multiplicative, which is the
% default. Here are several examples: 
% 
% sc = staircase('create', [1 3], [0 1], 200); % stop after 200 trials
% sc = staircase('create', [1 2], [0 1], [], 16); % stop after 16 reversals
% sc = staircase('create'); % stop after either trials reach 100 or
%    reversals reach 12.  
% sc = staircase('create', [1 4], [1 20], [], [], 2); % stimulus value 
%    range is from 1 to 20. The additive step of 2 will be used.  
% sc = staircase('create', 0.75); % converge at 75% performance  
% 
% If the only stop criterion is the number of reversals, you can do your
% trial loop like this: 
% 
%   while ~isempty(sc.stimVal)
%       ... % show stim and collect response
%       sc=staircase('update',sc,correct); % sc.stimVal is empty when done
%   end
% 
% If you use the "smart" staircase, where stop criterion is determined by
% both number of trials and number of reversals, you can do this:
% 
%   for i=1:sc.nTrials
%       if isempty(sc.stimVal), break; end % done
%       ... % show stim and collect response
%       sc=staircase('update',sc,correct);
%   end
% 
% Optionally, after you 'create' the staircase, you could add any field for
% it, as long as the field does not conflict with built-in field names. You
% can also change some field value. For example, you can do 
%   sc.dataLabel={'contrast' 'correct' 'RT'}; % data column meaning
% 
% The initial stimulus value is the mean of min and max stimulus. If
% needed, you can set it to yours by
%   sc.stimVal=0.2; % set initial stimulus value
% 
% sc = staircase('update', sc, vector);
% - Update the data within each trial. You can call this only once within
% each trial. The second input must be the struct returned by 'create'. The
% 3rd input can be a scalar or vector. Its first element indicates the
% response is correct (non-zero) or not (zero), while others can be any
% double value experimenter likes to store. These will be saved into field
% 'data'. 
% 
% sc = staircase('undo', sc);
% - Remove last trial from the data. This does the opposite to 'update', so
% it goes to the state before last 'update'. The returned stimVal is what
% is used in the removed trial. This may be useful when subject realizes he
% made a wrong key press, and wants to undo that response. Since a wrong
% key press may make the staircase run longer and inaccurate, it may be a
% good idea to redo the trial if there is no feedback in the experiment. 
% 
% staircase('plot', sc);
% - Plot the result for visualization. This can be called either in your
% code, or from Command Window after you load the saved struct.
% 
% sc = staircase('compute', sc, nDiscard);
% - You call this only when you want to re-compute threshold with a new
% nDiscard number. The optional nDiscard is the number of reversals to
% discard from beginning. It will by adjusted by 1 if the remaining number
% of reversals is an odd number.
% 
% Note that the 'plot' and 'compute' commands apply to multiple staircases,
% i.e., struct sc can have length greater than 1, while 'create' and
% 'update' works only for a single staircase. For multiple staircases, the
% analysis result will be combined. The averaged result is saved in field
% 'meanResult' of the first struct. Of course, the average makes sense only
% when the staircases are for the same stimulus parameters.
% 
% The 'compute' command, which is called by 'plot' if necessary, saves a
% mat file 'staircase_rst' in the current folder. In case of code error,
% you may retrieve it. This file is overwritten after each 'compute'.
% 
% - The struct sc contains all parameters and result. Following are a list
% of its fields:
% 
%  result: a string explaining the result. Shown after 'plot' or 'compute'.
%  threshold: numeric result. Its four elements are threshold, standard
%     deviation, number of reversals used to compute the threshold, and
%     probability of correct. nan means you did not do 'compute' or 'plot',
%     or the data is invalid to 'compute'.
%  reversal: stimulus value at reversal points.
%  stimVal: stimulus value for next trial, set by 'create' and 'update'. 
%    Empty value means a stop criterion has met.
%  data: raw data. Each row is for a trial. Columns are stimulus values,
%     correct, and others which were passed into during 'update'.
%  minMax: stimulus range [min max]. stimVal is always within this range.
%  upDown: staircase type [up down]. For example, [2 3] means the
%     sc.stimVal is increased after consecutive 2 wrong trials, and it is
%     decreased after consecutive 3 correct trials.
%  logStep: 0 or 1, indicating we are using linear or log step. 
%  step: two elements mean step sizes to decrease and increase stimulus. If
%     we use logStep, we increase or decrease stimVal by *sc.step(2) or
%     /sc.step(1). The sc.step is set to 2 by 'create', and 'update' will
%     reduce it according to number of reversals. If we use linear step,
%     stimVal will be increased or decreased by +sc.step(2) or -sc.step(1).
%     The 6th input of 'create' is the step size. User can change step size
%     after certain number of reversals, if applicable.
%  nTrials: max number of trials to stop staircase.
%  nReversals: max number of reversals to stop staircase.
%  meanResult: shown only in the first struct for mutiple staircases. It
%     has the same elements as 'threshold'. 

% 2010/09   xl  wrote it.
% 2010/10   xl  implemented 'undo'.
% 2011/05   xl  bug fix for insufficient nReversals for fixed nTrials

function varargout=staircase(cmd, varargin)
if nargin<1, help(mfilename); return; end
if ~ischar(cmd), error('stairecase command must be a string.'); end
if any(cmd=='?'), subFuncHelp(mfilename,cmd); return; end % online help

if strcmpi(cmd,'update') % first update, maybe faster?
    if nargin<3 || ~isstruct(varargin{1}) || ...
            ischar(varargin{2}) || ~isvector(varargin{2})
        error('staircase:InvalidInput',...
            'Usage: st=staircase(''update'', st, datavector)'); 
    end
    if nargout~=1, error('update command needs one output'); end
    
    [sc vector]=varargin{1:2};
    if isempty(sc.stimVal)
        error('staircase:stopped','Staircase already stopped.');
    end
    
    iT=find(isnan(sc.data(:,1)),1); % current trial index
    n=length(vector)+1;
    if iT==1 && n~=size(sc.data,2)
        sc.data=nan(sc.nTrials,n); % resize it
    elseif n~=size(sc.data,2)
        error('staircase:InvalidInput', ...
            'Data vector size should be consistent among trials.'); 
    elseif isempty(iT) % all used, unlikely
        iT=size(sc.data,1)+1;
        sc.data(iT+(0:sc.nTrials),:)=nan;
    end
    
    nR=find(isnan(sc.reversal),1)-1; % # of reversal we have
    if isempty(nR) % all used, unlikely
        nR=numel(sc.reversal);
        sc.reversal(nR+(1:sc.nReversals))=nan;
    end

    val=sc.stimVal; % read current stim value
    ok= vector(1)~=0; % 1 or 0, response correct or not
    vec=vector(2:end); % take care of column vector
    sc.data(iT,:)=[val ok vec(:)']; % update a row
    
    % Need to change stim? Here is the critical part. An example: if we do
    % 3-down, and the response is correct for this trial, we need to change
    % stimulus when all 3 conditions meet: we have 3 or more trials, all
    % last 3 trials have correct response, and use the same stimulus value. 
    % Similar if the response is incorrect. This also takes care of the
    % fake reversal problem when stimVal is changed by this code (out of
    % range) or by user code.
    % We use iT>=max(sc.upDown) instead of iP>0, to avoid changing value
    % for the first several trials, which is likely to be response error.
    
    iP=iT-sc.upDown(ok+1)+1; % index of trial to start check with
    % if iP>0 && all(sc.data(iP:iT,2)==ok) && all(sc.data(iP:iT,1)==val)
    if iT>=max(sc.upDown) && all(sc.data(iP:iT,2)==ok) && all(sc.data(iP:iT,1)==val)
        iC=find(sc.data(1:iT,1)~=val,1,'last'); % last different stimVal
        if (sc.data(iC,1)<val)==ok % a reversal? was up, now correct or vice versa
            nR=nR+1; % increase it only when this is a reversal
            sc.reversal(nR)=val; % add it to reversal
            
            if sc.logStep
                if max(sc.step)>1.1 % arbituary limit to avoid too small step
                    sc.step=exp(log(sc.step)*nR/(1+nR));
                end
            else sc.step=sc.step*nR/(1+nR);
            end
        end
        
        % change stimVal
        if sc.logStep
            if ok, val=val/sc.step(1);
            else val=val*sc.step(2);
            end
        else
            if ok, val=val-sc.step(1);
            else val=val+sc.step(2);
            end
        end
        val=max(sc.minMax(1),min(val,sc.minMax(2))); % make it within range
        sc.stimVal=val; % set stimVal for next trial
    end
    
    % set stop flag if done
    if iT>=sc.nTrials || nR>=sc.nReversals
        sc.stimVal=[]; 
    end
    
elseif strcmpi(cmd,'undo')
    if nargin<2 || ~isstruct(varargin{1})
        error('staircase:InvalidInput','Usage: st=staircase(''undo'', st)'); 
    end
    if nargout~=1, error('undo command needs one output'); end
    
    sc=varargin{1};
    iT=find(isnan(sc.data(:,1)),1)-1; % current trial index
    if iT==0, varargout={sc}; return; end
    if isempty(iT), iT=size(sc.data,1); end
    
    nR=find(isnan(sc.reversal),1)-1; % # of reversal we have
    if isempty(nR), nR=numel(sc.reversal); end

    val=sc.data(iT,1); % read previous stim value
    ok=sc.data(iT,2); % previous correctness
    
    iP=iT-sc.upDown(ok+1)+1; % index of trial to start check with
    if iT>=max(sc.upDown) && all(sc.data(iP:iT,2)==ok) && all(sc.data(iP:iT,1)==val)
        iC=find(sc.data(1:iT,1)~=val,1,'last'); % last different stimVal
        if (sc.data(iC,1)<val)==ok % was a reversal?
            sc.reversal(nR)=[]; % remove last reversal
            
            if sc.logStep
                if max(sc.step)/nR*(1+nR)>1.05
                    sc.step=exp(log(sc.step)/nR*(1+nR)); 
                end
            else sc.step=sc.step/nR*(1+nR);
            end
            
        end
    end
    sc.stimVal=val; % change it back to previous
    sc.data(iT,:)=[]; % remove last row

elseif strcmpi(cmd,'create')
    ins=varargin; n=length(ins);
    if n<5 || isempty(ins{5}) || ins{5}==0
        sc.logStep=true; % 
        % final step size should be 0.5~1 of spread
        sc.step=2; % will be reduced after reversals
    else % additive step
        sc.logStep=false; 
        sc.step=ins{5};
    end
    
    if n<4 || isempty(ins{4}), sc.nReversals=inf;
    else sc.nReversals=ins{4};
    end

    if n<3 || isempty(ins{3}), sc.nTrials=inf;
    else sc.nTrials=ins{3};
    end
    
    if n<2 || isempty(ins{2})
        sc.minMax=[0 1];
    elseif length(ins{2})~=2
        error('staircase:InvalidInput',...
            'Stimulus range must be in formart of [min max].'); 
    else sc.minMax=ins{2};
    end

    if n<1 || isempty(ins{1})
        sc.upDown=[1 3];
    elseif length(ins{1})>2 || (length(ins{1})==1 && (ins{1}>1 || ins{1}<0))
        error('staircase:InvalidInput',...
            'Staircase type must be 0~1, or in formart of [up down].'); 
    else sc.upDown=ins{1};
    end
    
    if all(isinf([sc.nReversals sc.nTrials])) % smart staircase
        sc.nReversals=12; sc.nTrials=100; 
    elseif isinf(sc.nTrials)
        sc.nTrials=sc.nReversals*sum(sc.upDown)*5; % more than enough
    elseif isinf(sc.nReversals)
        sc.nReversals=ceil(sc.nTrials/max(sc.upDown));
    end
    
    % compute percent correct
    if isscalar(ins{1})
        prob=ins{1};
        [foo ind]=min(abs(0.5.^(1./(1:9))-prob)); %#ok
        sc.upDown=[1 ind];
    elseif sc.upDown(1)==1, prob=0.5^(1/sc.upDown(2));
    elseif sc.upDown(2)==1, prob=1-0.5^(1/sc.upDown(1));
    elseif diff(sc.upDown)==0, prob=0.5;
    else
        prob=0.5^(sc.upDown(1)/sc.upDown(2)); % only an estimate
        if all(sc.upDown==[2 3]), prob=0.604; % by simulation
            % Idea: chance for decrease is 0.5
            % func=@(x) x^3*(2+x)-0.5; % not right
            % prob=fsolve(func,prob,optimset('display','off'));
        elseif all(sc.upDown==[3 2]), prob=1-0.604;
        elseif all(sc.upDown==[2 4]), prob=0.667; % by simulation
        elseif all(sc.upDown==[4 2]), prob=1-0.667;
        else
            str=sprintf(['Probability of correct for staircase '...
                '[%g %g] is an estimate.'],sc.upDown);
            warning('staircase:fakePC',str); %#ok
        end
    end
    
    sc.stimVal=mean(sc.minMax); % use the middle value for first trial
    % pre-allocate is important for huge number of trials for simulation
    sc.data=nan(sc.nTrials,2);
    sc.dataLabel={'stimVal' 'correct'}; % data column label
    sc.reversal=nan(1,sc.nReversals);

    if sc.logStep
        sc.step(2)=exp(log(sc.step(1))*(1/(1-prob^sc.upDown(2))-1));
    else
        sc.step(2)=sc.step(1)*(1/(1-prob^sc.upDown(2))-1);
    end
    sc.threshold=[nan(1,3) prob*100];
    sc.result='';
        
elseif strcmpi(cmd,'plot')
    if nargin<2 || ~isstruct(varargin{1})
        error('staircase:InvalidInput','Usage: staircase(''plot'',st)'); 
    end
    sc=varargin{1};
    if isnan(sc(1).threshold(1)), sc=staircase('compute',sc); end
    nsc=length(sc);
    figure(7);
    set(gcf,'position',[100 100 800 200*nsc+100],'Name','Staircase Result');
    for i=1:nsc
        subplot(nsc,1,i);
        plot(sc(i).data(:,1),'b'); hold all;
        ind=find(sc(i).data(:,2)); % index for correct trials
        h(1)=plot(ind,sc(i).data(ind,1),'.g','markersize',16);
        ind=find(sc(i).data(:,2)==0); % for wrong trials
        h(2)=plot(ind,sc(i).data(ind,1),'.r','markersize',16);
        
        % find trial index for reversals. we could save this during
        % 'update', but this serves as a checkup for reversals
        ss=sign(diff(sc(i).data(:,1))); % -1/0/1 for down/noChange/up
        ind=find(ss~=0); % index for -1 and 1
        ind([true; ss(ind(2:end))==ss(ind(1:end-1))])=[]; % 1st and repeated
        iR=sc(i).reversal*0+size(sc(i).data,1);
        iR(1:length(ind))=ind; % if 1 longer than ind, it is the last trial

        x=xlim;
        h(3)=plot(iR,sc(i).reversal,'+k','markersize',8);
        h(4)=line(x,[1 1]*sc(i).threshold(1),'color','m','LineStyle',':');
        if i==1, legend(h,{'Correct', 'Wrong', 'Reversal', 'Threshold'}); end
        if i==nsc, xlabel('Trial Number'); ylabel('Stimulus Value'); end
        if nsc>1
            y=ylim;
            text(x(1)+diff(x)*0.3,y(1)+diff(y)*0.8,sc(i).result); 
        end
        hold off;
    end
    if nsc==1
        str=sc.result;
    else
        if ~isfield(sc(1),'meanResult'), sc=staircase('compute',sc); end
        str=sprintf(['Average of %g staircases: threshold = ' ...
            '%.3g %s %.2g (N=%g), at %.1f%% correct'], ...
            nsc, sc(1).meanResult(1), char(177),sc(1).meanResult(2:4));
        subplot(nsc,1,1);
    end
    title(str);
    
elseif strcmpi(cmd,'compute')
    if nargin<2 || ~isstruct(varargin{1})
        error('staircase:InvalidInput',...
            'Usage: st=staircase(''compute'', st, nDiscard)'); 
    end
    sc=varargin{1};
    nsc=length(sc); % number of staircases
    
    ToDiscard=nan(1,nsc);
    if nargin>2
        ToDiscard=varargin{2}; len=length(ToDiscard);
        if ~isnumeric(ToDiscard) || (len~=1 && len~=nsc)
            error('staircase:InvalidInput',...
               'nDiscard must have same length with struct, or a scalar.');
        end
        if len~=nsc, ToDiscard=repmat(ToDiscard,[1 nsc]); end
    end

    % compute threshold and std
    for i=1:nsc
        % clear tailing nan
        nR=find(isnan(sc(i).reversal),1)-1; % number of reversals
        if ~isempty(nR), sc(i).reversal(nR+1:end)=[]; 
        else nR=numel(sc(i).reversal);
        end
        nT=find(isnan(sc(i).data(:,1)),1); % number of trials
        if ~isempty(nT), sc(i).data(nT:end,:)=[]; end
        
        if nR==0 % bad experiment, use last point
            sc(i).threshold(1:3)=[sc(i).stimVal 0 0];
        else
            if nR<3, ndiscard=0; % 1 or 2 reversal, bad too
            else % 3 or more
                if ~isnan(ToDiscard(i)) && nR-ToDiscard(i)>1 % user asks to discard 
                    ndiscard=max(ToDiscard(i),1);
                    if mod(nR-ndiscard,2)
                        ndiscard=ndiscard-sign((ToDiscard(i)>1)-0.5);
                    end
                elseif ~isnan(sc(i).threshold(3)) % we had it so keep it
                    ndiscard=nR-sc(i).threshold(3);
                else % default, we discard 1 or 2 to make reversals even
                    ndiscard=2-mod(nR,2);
                end
            end
            revs=sc(i).reversal(ndiscard+1:nR); % remove ndiscard reversals
            sc(i).threshold(1:3)=[mean(revs) std(revs) nR-ndiscard];

            if ndiscard==0
                warning('staircase:tooLessReversals',...
                    'Too less reversals to estimate threshold.');
            end
        end
        
        sc(i).result=sprintf('threshold = %.3g %s %.2g (N=%g), at %.1f%% correct', ...
                sc(i).threshold(1), char(177),sc(i).threshold(2:4));
    end
    
    if nsc>1
        a=reshape(cell2mat({sc.threshold}),4,nsc)';
        sc(1).meanResult([1 4])=mean(a(:,[1 4])); % threshold and prob
        sc(1).meanResult(2)=sqrt(sum(a(:,2).^2.*(a(:,3)-1))/(sum(a(:,3))-1)); % std
        sc(1).meanResult(3)=sum(a(:,3)); % N
    end
    try save staircase_rst sc; end %#ok just in case of error, you have it!
    
    if nargout==0 % if no output, we print the result
        if nsc==1
            fprintf(sc.result);
        else
            fprintf('     Threshold %s SD      N  Probability\n',char(177));
            for i=1:nsc
                fprintf(' %1g   %9.3g %s %7.2g %g   %.1f%%\n', i, ...
                    sc(i).threshold(1), char(177), sc(i).threshold(2:4));
            end
            fprintf(' avg %9.3g %s %7.2g %g   %.1f%%\n', ...
                sc(1).meanResult(1), char(177), sc(1).meanResult(2:4));
        end
    end
        
else
    error('staircase:InvalidInput','Invalid command: %s',cmd);
end

if nargout, varargout={sc}; end
