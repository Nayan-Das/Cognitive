
function out = queryGoogleNumPages(query)

offset = 23;
qstring = strcat('https://www.google.co.in/search?source=hp&ei=-ZWFWrPvGY20vwTv9ZGgAQ&q=', query);
s = urlread(qstring);

sIdx = strfind(s,'id="resultStats"');
eIdx = strfind(s(sIdx:end),' results');
eIdx = eIdx(1);

rstring = s(sIdx+offset:sIdx+eIdx-1);
out = log(str2double(rstring));

pause(2);               % very important if you don't want to seem like a bot and have your IP blocked by Google

return;