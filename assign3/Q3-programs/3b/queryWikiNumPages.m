

% code to obtain the number of webpages for a particular wiki search

function out = queryWikiNumPages(query)
qstring = strcat('https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=',query,'&srprop=timestamp&format=json&maxlag=5');
s = urlread(qstring);
temp = s(strfind(s,'hits')+6:strfind(s,'hits')+15);
out = str2double(temp(1:strfind(temp,'}')-1));
return;
