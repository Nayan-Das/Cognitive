
function out = drawFromADist(p)

if(sum(p)==0)
	p = 0.05*ones(1,length(p));
end;
p = p/sum(p);
c = cumsum(p);
[~,idx] = find((rand - cumsum(p))<0);
sample = min(idx);
out = zeros(size(p));
out(sample) = 1;
%out(out==0) = 0.1;
return;
    
