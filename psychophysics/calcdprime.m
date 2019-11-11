% calculate dprime
%% for a detection task
A = norminv(1-hitrate,0,1);
B = norminv(1-falsealarmrate,0,1);
dprime = -A + B; 

%% for a 2AFC task
% can treat one option as hit, another option as false alarm
A = norminv(1-hitrate,0,1);
B = norminv(1-falsealarmrate,0,1);
dprime = -A + B;  % spatial cases x behtype x subjects