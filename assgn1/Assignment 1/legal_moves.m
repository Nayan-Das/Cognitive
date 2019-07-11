
function moves = legal_moves(curr,mat)

moves= [];
if(curr-1>0); moves = [moves curr-1]; end;
if(rem(curr,length(mat))~=0); moves = [moves curr+1]; end;
if(curr-length(mat)>0); moves = [moves curr-length(mat)]; end;
if(curr+length(mat)<length(mat)^2); moves = [moves curr+length(mat)]; end;

return;