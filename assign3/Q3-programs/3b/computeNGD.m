
% function to calculate normalized Google Distance between two query
% strings a and b

% NGD is a version of Google Distance (which spans the positive real line)
% normalized to fit within the range (0,1). An NGD of 1 means the two terms
% are infinitely far apart in semantic space. 

function NGD = computeNGD(a,b)
lN = log(47000000000);          % number of webpages indexed by Google in Feb 2018
la = queryGoogleNumPages(a);
lb = queryGoogleNumPages(b);
lab = queryGoogleNumPages(strcat(a,'+',b));
NGD = (max(la,lb) - lab)/(lN - min(la,lb));
return;