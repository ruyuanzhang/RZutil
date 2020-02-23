function mailme(mailtitle,mailcontent, password, receiver)
% using matlab to send out email
% <mailtile>: a string, email title
% <mailcontent>: a string, email content
% <password>: the password for the email
% <receiver>: receiver email
%
%
% 20200105 RZ switch 163 mail, gmail is hard to configure

if notDefined('mailtitle')
    error('Please input mailtitle');
end
if notDefined('mailcontent')
    error('Please input mailcontent');
end
if notDefined('password')
    error('Please input password');
end
if notDefined('receiver')
    receiver = 'ruyuanzhang@gmail.com'; % default to sent it to self
end


%% gmail
% account set
% mail = 'fenbukaide@gmail.com';  %
% 
% % setup the server
% setpref('Internet','E_mail',mail);
% setpref('Internet','SMTP_Server','smtp.gmail.com'); % 
% setpref('Internet','SMTP_Username',mail);
% setpref('Internet','SMTP_Password',password);
% props = java.lang.System.getProperties;
% props.setProperty('mail.smtp.auth','true');
% props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
% props.setProperty('mail.smtp.socketFactory.port','465');

%% 163 mail
mail = 'fenbukaide@163.com';
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.163.com'); % ?SMTP???
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

%% send
sendmail(receiver,mailtitle,mailcontent);
end
